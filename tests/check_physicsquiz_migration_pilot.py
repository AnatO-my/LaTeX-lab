"""Verify Phase 4F source fidelity and real-question selection behaviour."""

from pathlib import Path
import re
import sys


PILOT_NUMBERS = [1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 60]
ID_BY_NUMBER = {
    1: "phy104-osc-001",
    6: "phy104-nm-006",
    11: "phy104-wave-011",
    16: "phy104-opt-016",
    21: "phy104-osc-021",
    26: "phy104-nm-026",
    31: "phy104-wave-031",
    36: "phy104-opt-036",
    41: "phy104-osc-041",
    46: "phy104-nm-046",
    51: "phy104-wave-051",
    60: "phy104-opt-060",
}
EXPECTED_ANSWERS = {
    "phy104-osc-001": "C",
    "phy104-nm-006": "B",
    "phy104-wave-011": "C",
    "phy104-opt-016": "A",
    "phy104-osc-021": "B",
    "phy104-nm-026": "B",
    "phy104-wave-031": "B",
    "phy104-opt-036": "B",
    "phy104-osc-041": "C",
    "phy104-nm-046": "C",
    "phy104-wave-051": "C",
    "phy104-opt-060": "E",
}
EXPECTED_METADATA = {
    "phy104-osc-001": ("oscillations", "foundation", "1"),
    "phy104-nm-006": ("normal-modes", "foundation", "1"),
    "phy104-wave-011": ("waves-and-sound", "foundation", "1"),
    "phy104-opt-016": ("optics", "foundation", "1"),
    "phy104-osc-021": ("oscillations", "applied", "2"),
    "phy104-nm-026": ("normal-modes", "applied", "2"),
    "phy104-wave-031": ("waves-and-sound", "applied", "2"),
    "phy104-opt-036": ("optics", "applied", "2"),
    "phy104-osc-041": ("oscillations", "challenge", "3"),
    "phy104-nm-046": ("normal-modes", "challenge", "3"),
    "phy104-wave-051": ("waves-and-sound", "challenge", "3"),
    "phy104-opt-060": ("optics", "challenge", "3"),
}
EXPECTED_SELECTIONS = {
    "physicsquiz_migration_pilot_ids": [
        "phy104-opt-060",
        "phy104-osc-001",
        "phy104-wave-031",
        "phy104-nm-026",
    ],
    "physicsquiz_migration_pilot_metadata": [
        "phy104-nm-006",
        "phy104-nm-026",
        "phy104-nm-046",
    ],
    "physicsquiz_migration_pilot_random": [
        "phy104-opt-016",
        "phy104-wave-051",
        "phy104-osc-001",
        "phy104-osc-021",
        "phy104-nm-046",
    ],
    "physicsquiz_migration_pilot_random_repeat": [
        "phy104-opt-016",
        "phy104-wave-051",
        "phy104-osc-001",
        "phy104-osc-021",
        "phy104-nm-046",
    ],
}


def normalise(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip()


def metadata_value(options: str, key: str) -> str:
    match = re.search(rf"(?:^|,)\s*{re.escape(key)}\s*=\s*([^,\n]+)", options)
    return match.group(1).strip() if match else ""


def extract_legacy(source: str) -> tuple[dict[int, str], dict[int, tuple[str, str]]]:
    question_section = source[
        source.index(r"\begin{quizquestions}") : source.index(r"\end{quizquestions}")
    ]
    pairs = re.findall(r"^  \\item (.*?)\n  (\\choices.*)$", question_section, re.M)
    questions = {number: normalise(" ".join(pairs[number - 1])) for number in PILOT_NUMBERS}

    solutions: dict[int, tuple[str, str]] = {}
    for number in PILOT_NUMBERS:
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
        solutions[number] = (match.group(1), normalise(body))
    return questions, solutions


def extract_bank(bank: str) -> list[dict[str, str]]:
    question_matches = list(
        re.finditer(
            r"\\begin\{quizquestion\}\[(.*?)\]\s*(.*?)\\end\{quizquestion\}",
            bank,
            re.S,
        )
    )
    solution_matches = list(
        re.finditer(r"\\begin\{quizsolution\}\s*(.*?)\\end\{quizsolution\}", bank, re.S)
    )
    if len(question_matches) != len(solution_matches):
        raise ValueError("pilot bank does not have one solution per question")

    records = []
    for question, solution in zip(question_matches, solution_matches):
        options = question.group(1)
        records.append(
            {
                "id": metadata_value(options, "id"),
                "topic": metadata_value(options, "topic"),
                "difficulty": metadata_value(options, "difficulty"),
                "marks": metadata_value(options, "marks"),
                "correct": metadata_value(options, "correct"),
                "question": normalise(question.group(2)),
                "solution": normalise(solution.group(1)),
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
            "usage: check_physicsquiz_migration_pilot.py LEGACY_TEX BANK_TEX BUILD_DIR"
        )

    legacy_path, bank_path, build_path = map(Path, sys.argv[1:])
    failures: list[str] = []
    legacy_questions, legacy_solutions = extract_legacy(
        legacy_path.read_text(encoding="utf-8")
    )
    records = extract_bank(bank_path.read_text(encoding="utf-8"))

    ids = [record["id"] for record in records]
    expected_ids = [ID_BY_NUMBER[number] for number in PILOT_NUMBERS]
    if ids != expected_ids:
        failures.append(f"bank order/IDs {ids}, expected {expected_ids}")

    for number, record in zip(PILOT_NUMBERS, records):
        record_id = ID_BY_NUMBER[number]
        answer, solution = legacy_solutions[number]
        if record["question"] != legacy_questions[number]:
            failures.append(f"{record_id}: stem or choices changed during migration")
        if record["solution"] != solution:
            failures.append(f"{record_id}: worked solution changed during migration")
        if record["correct"] != answer or answer != EXPECTED_ANSWERS[record_id]:
            failures.append(f"{record_id}: correct answer mismatch")
        actual_metadata = (record["topic"], record["difficulty"], record["marks"])
        if actual_metadata != EXPECTED_METADATA[record_id]:
            failures.append(
                f"{record_id}: metadata {actual_metadata}, expected {EXPECTED_METADATA[record_id]}"
            )

    logs: dict[str, str] = {}
    for stem, expected_order in EXPECTED_SELECTIONS.items():
        log_path = build_path / f"{stem}.log"
        pdf_path = build_path / f"{stem}.pdf"
        if not log_path.is_file() or not pdf_path.is_file():
            failures.append(f"{stem}: missing PDF or log")
            continue
        text = log_path.read_text(encoding="utf-8", errors="replace")
        logs[stem] = text
        selected = markers(text, "PQ4D-SELECT:")
        if selected != expected_order:
            failures.append(f"{stem}: selected {selected}, expected {expected_order}")
        expected_pairs = [(record_id, EXPECTED_ANSWERS[record_id]) for record_id in expected_order]
        if answer_pairs(text, "PQ4C-ANSWER:") != expected_pairs:
            failures.append(f"{stem}: generated answer key is misaligned")
        if answer_pairs(text, "PQ4C-SOLUTION:") != expected_pairs:
            failures.append(f"{stem}: generated solutions are misaligned")

    random_picks = markers(logs.get("physicsquiz_migration_pilot_random", ""), "PQ4E-RANDOM:PICK=")
    repeat_picks = markers(
        logs.get("physicsquiz_migration_pilot_random_repeat", ""), "PQ4E-RANDOM:PICK="
    )
    if random_picks != repeat_picks:
        failures.append("identical seed 104 did not reproduce the same selection")

    if failures:
        for failure in failures:
            print(f"FAIL {failure}", file=sys.stderr)
        return 1

    print("All Phase 4F migration-pilot checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
