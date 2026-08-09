"""Verify Phase 4G full-source fidelity and structured selection behaviour."""

from pathlib import Path
import re
import sys


def normalise(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip()


def resolve_correct_letter(text: str, letter: str) -> str:
    """Resolve the Phase 4I answer-letter macro back to the declared letter.

    Checkpoint 4I replaced the literal answer letter in every migrated worked
    solution with \\quizcorrectletter, which expands to the record's declared
    letter whenever options are not shuffled.  Resolving it here keeps this
    fidelity comparison about the reasoning text, and makes it fail if a record
    ever used the macro while declaring a different answer from the legacy
    source.
    """
    return text.replace(r"\quizcorrectletter", letter)


def topic_for(number: int) -> tuple[str, str]:
    position = (number - 1) % 20 + 1
    if position <= 5:
        return "oscillations", "osc"
    if position <= 10:
        return "normal-modes", "nm"
    if position <= 15:
        return "waves-and-sound", "wave"
    return "optics", "opt"


def band_for(number: int) -> tuple[str, str]:
    if number <= 20:
        return "foundation", "1"
    if number <= 40:
        return "applied", "2"
    return "challenge", "3"


def record_id(number: int) -> str:
    _, prefix = topic_for(number)
    return f"phy104-{prefix}-{number:03d}"


EXPECTED_IDS = [record_id(number) for number in range(1, 61)]
EXPECTED_SELECTIONS = {
    "physicsquiz_full_migration_all": EXPECTED_IDS,
    "physicsquiz_full_migration_foundation": EXPECTED_IDS[:20],
    "physicsquiz_full_migration_applied": EXPECTED_IDS[20:40],
    "physicsquiz_full_migration_challenge": EXPECTED_IDS[40:60],
    "physicsquiz_full_migration_ids": [
        "phy104-opt-060",
        "phy104-osc-001",
        "phy104-wave-031",
        "phy104-nm-026",
        "phy104-osc-045",
        "phy104-opt-057",
    ],
    "physicsquiz_full_migration_metadata": [
        "phy104-opt-056",
        "phy104-opt-057",
        "phy104-opt-058",
        "phy104-opt-059",
        "phy104-opt-060",
    ],
    "physicsquiz_full_migration_tags": [
        "phy104-wave-034",
        "phy104-wave-053",
    ],
}
RANDOM_STEMS = (
    "physicsquiz_full_migration_random",
    "physicsquiz_full_migration_random_repeat",
)


def extract_legacy(source: str) -> tuple[list[str], list[tuple[str, str]]]:
    question_section = source[
        source.index(r"\begin{quizquestions}") : source.index(r"\end{quizquestions}")
    ]
    question_section = re.sub(r"^  \\levelbanner.*$", "", question_section, flags=re.M)
    questions = [
        normalise(item)
        for item in re.split(r"^  \\item ", question_section, flags=re.M)[1:]
    ]
    if len(questions) != 60:
        raise ValueError(f"expected 60 legacy questions, found {len(questions)}")
    if any(question.count(r"\choices") != 1 for question in questions):
        raise ValueError("each legacy question must contain exactly one choices command")

    solutions: list[tuple[str, str]] = []
    for number in range(1, 61):
        match = re.search(
            rf"\\begin\{{workedsolution\}}\{{{number}\}}\{{([A-E])\}}(.*?)"
            r"\\end\{workedsolution\}",
            source,
            re.S,
        )
        if not match:
            raise ValueError(f"legacy solution {number} was not found")
        body = re.sub(
            r"^\\textbf\{Topic:.*?\.\}\\par\s*", "", match.group(2), count=1, flags=re.S
        )
        solutions.append((match.group(1), normalise(body)))

    key_section = source[
        source.index(r"\begin{answerkey}") : source.index(r"\end{answerkey}")
    ]
    key_pairs = re.findall(r"\\textbf\{(\d+)\.\}\s*([A-E])", key_section)
    answer_key = {int(number): answer for number, answer in key_pairs}
    if len(answer_key) != 60:
        raise ValueError(f"expected 60 answer-key entries, found {len(answer_key)}")
    for number, (solution_answer, _) in enumerate(solutions, start=1):
        if answer_key[number] != solution_answer:
            raise ValueError(f"legacy answer/solution mismatch at question {number}")
    return questions, solutions


def scalar(options: str, key: str) -> str:
    match = re.search(rf"(?:^|,)\s*{re.escape(key)}\s*=\s*([^,\n]+)", options)
    return match.group(1).strip() if match else ""


def braced(options: str, key: str) -> str:
    match = re.search(rf"(?:^|,)\s*{re.escape(key)}\s*=\s*\{{([^}}]*)\}}", options)
    return match.group(1).strip() if match else ""


def extract_bank(bank: str) -> list[dict[str, str]]:
    questions = list(
        re.finditer(
            r"\\begin\{quizquestion\}\[(.*?)\]\s*(.*?)\\end\{quizquestion\}",
            bank,
            re.S,
        )
    )
    solutions = list(
        re.finditer(r"\\begin\{quizsolution\}\s*(.*?)\\end\{quizsolution\}", bank, re.S)
    )
    if len(questions) != 60 or len(solutions) != 60:
        raise ValueError(
            f"expected 60 question/solution pairs, found {len(questions)}/{len(solutions)}"
        )

    records = []
    for question, solution in zip(questions, solutions):
        options = question.group(1)
        records.append(
            {
                "id": scalar(options, "id"),
                "topic": scalar(options, "topic"),
                "difficulty": scalar(options, "difficulty"),
                "marks": scalar(options, "marks"),
                "correct": scalar(options, "correct"),
                "tags": braced(options, "tags"),
                "outcome": braced(options, "outcome"),
                "question": normalise(question.group(2)),
                "solution": normalise(
                    resolve_correct_letter(
                        solution.group(1), scalar(options, "correct")
                    )
                ),
            }
        )
    return records


def markers(text: str, prefix: str) -> list[str]:
    return re.findall(rf"^{re.escape(prefix)}([^\s]+)$", text, re.MULTILINE)


def answer_pairs(text: str, prefix: str) -> list[tuple[str, str]]:
    return re.findall(rf"^{re.escape(prefix)}([^=\s]+)=([^\s]+)$", text, re.MULTILINE)


def main() -> int:
    if len(sys.argv) != 4:
        raise SystemExit(
            "usage: check_physicsquiz_full_migration.py LEGACY_TEX BANK_TEX BUILD_DIR"
        )

    legacy_path, bank_path, build_path = map(Path, sys.argv[1:])
    failures: list[str] = []
    legacy_questions, legacy_solutions = extract_legacy(
        legacy_path.read_text(encoding="utf-8")
    )
    records = extract_bank(bank_path.read_text(encoding="utf-8"))

    ids = [record["id"] for record in records]
    if ids != EXPECTED_IDS:
        failures.append("bank declaration order or stable IDs differ from questions 1--60")
    if len(set(ids)) != 60:
        failures.append("stable IDs are not unique")

    answers: dict[str, str] = {}
    for number, record in enumerate(records, start=1):
        expected_id = record_id(number)
        topic, _ = topic_for(number)
        difficulty, marks = band_for(number)
        answer, solution = legacy_solutions[number - 1]
        answers[expected_id] = answer
        if record["question"] != legacy_questions[number - 1]:
            failures.append(f"{expected_id}: stem or choices changed during migration")
        if record["solution"] != solution:
            failures.append(f"{expected_id}: worked solution changed during migration")
        if record["correct"] != answer:
            failures.append(f"{expected_id}: correct answer changed during migration")
        actual_metadata = (record["topic"], record["difficulty"], record["marks"])
        expected_metadata = (topic, difficulty, marks)
        if actual_metadata != expected_metadata:
            failures.append(
                f"{expected_id}: metadata {actual_metadata}, expected {expected_metadata}"
            )
        if not record["tags"] or not record["outcome"]:
            failures.append(f"{expected_id}: tags or learning outcome are missing")

    logs: dict[str, str] = {}
    stems = list(EXPECTED_SELECTIONS) + list(RANDOM_STEMS)
    for stem in stems:
        log_path = build_path / f"{stem}.log"
        pdf_path = build_path / f"{stem}.pdf"
        if not log_path.is_file() or not pdf_path.is_file():
            failures.append(f"{stem}: missing PDF or log")
            continue
        log = log_path.read_text(encoding="utf-8", errors="replace")
        logs[stem] = log
        selected = markers(log, "PQ4D-SELECT:")
        expected = EXPECTED_SELECTIONS.get(stem)
        if expected is not None and selected != expected:
            failures.append(f"{stem}: selected {selected}, expected {expected}")
        if stem in RANDOM_STEMS:
            if len(selected) != 12 or len(set(selected)) != 12:
                failures.append(f"{stem}: random selection is not 12 unique records")
            if any(record not in answers for record in selected):
                failures.append(f"{stem}: random selection contains an unknown ID")
        expected_pairs = [(selected_id, answers[selected_id]) for selected_id in selected]
        if stem == "physicsquiz_full_migration_all":
            if answer_pairs(log, "PQ4C-ANSWER:") or answer_pairs(log, "PQ4C-SOLUTION:"):
                failures.append(f"{stem}: student-mode output exposed answers or solutions")
        else:
            if answer_pairs(log, "PQ4C-ANSWER:") != expected_pairs:
                failures.append(f"{stem}: generated answer key is misaligned")
            if answer_pairs(log, "PQ4C-SOLUTION:") != expected_pairs:
                failures.append(f"{stem}: generated solutions are misaligned")

    random_ids = markers(logs.get(RANDOM_STEMS[0], ""), "PQ4D-SELECT:")
    repeat_ids = markers(logs.get(RANDOM_STEMS[1], ""), "PQ4D-SELECT:")
    random_picks = markers(logs.get(RANDOM_STEMS[0], ""), "PQ4E-RANDOM:PICK=")
    repeat_picks = markers(logs.get(RANDOM_STEMS[1], ""), "PQ4E-RANDOM:PICK=")
    if random_ids != repeat_ids or random_picks != repeat_picks:
        failures.append("identical seed 104 did not reproduce the same ordered selection")

    all_log = logs.get("physicsquiz_full_migration_all", "")
    for marker in ("PQ4C-COUNT:60", "PQ4C-TOTAL:120", "PQ4D-COUNT:60", "PQ4D-TOTAL:120"):
        if marker not in all_log:
            failures.append(f"full-bank assertion marker is missing: {marker}")

    band_ids = []
    for stem in (
        "physicsquiz_full_migration_foundation",
        "physicsquiz_full_migration_applied",
        "physicsquiz_full_migration_challenge",
    ):
        band_ids.extend(markers(logs.get(stem, ""), "PQ4D-SELECT:"))
    if band_ids != EXPECTED_IDS:
        failures.append("difficulty-band output does not cover Questions 1--60 exactly once")

    if failures:
        for failure in failures:
            print(f"FAIL {failure}", file=sys.stderr)
        return 1

    print("All Phase 4G full-migration checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
