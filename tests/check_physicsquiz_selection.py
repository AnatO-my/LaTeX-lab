"""Verify Phase 4D deterministic question-bank selection."""

from pathlib import Path
import re
import sys


MODE_CONTENT = {
    "default": {"QUESTIONS", "ANSWERKEY", "TOPICS", "SOLUTIONS", "REFERENCE"},
    "student": {"QUESTIONS", "REFERENCE"},
    "teacher": {"QUESTIONS", "ANSWERKEY", "TOPICS", "TEACHER", "REFERENCE"},
    "solutions": {"SOLUTIONS", "REFERENCE"},
    "answerkey": {"ANSWERKEY", "TOPICS"},
}

MODE_ORDER = ["phy104-opt-060", "phy104-osc-001"]
ANSWERS = {
    "phy104-osc-001": "C",
    "phy104-nm-026": "B",
    "phy104-wave-031": "B",
    "phy104-opt-060": "E",
}

POSITIVE_SELECTIONS = {
    "physicsquiz_selection_metadata": ["phy104-nm-026", "phy104-wave-031"],
    "physicsquiz_selection_tags": ["phy104-wave-031"],
    "physicsquiz_selection_topic": ["phy104-opt-060"],
    "physicsquiz_selection_append_deduplicate": [
        "phy104-opt-060",
        "phy104-nm-026",
        "phy104-wave-031",
    ],
    "physicsquiz_selection_clear_all": [
        "phy104-osc-001",
        "phy104-nm-026",
        "phy104-wave-031",
        "phy104-opt-060",
    ],
}


def markers(text: str, prefix: str) -> list[str]:
    return re.findall(rf"^{re.escape(prefix)}([^\s]+)$", text, re.MULTILINE)


def pairs(text: str, prefix: str) -> list[tuple[str, str]]:
    return re.findall(
        rf"^{re.escape(prefix)}([^=\s]+)=([^\s]+)$", text, re.MULTILINE
    )


def expected_pairs(order: list[str]) -> list[tuple[str, str]]:
    return [(record_id, ANSWERS[record_id]) for record_id in order]


def read_log(build_dir: Path, stem: str, failures: list[str]) -> str:
    log = build_dir / f"{stem}.log"
    if not log.is_file():
        failures.append(f"{stem}: missing log {log}")
        return ""
    for suffix in ("pdf", "synctex.gz"):
        artifact = build_dir / f"{stem}.{suffix}"
        if not artifact.is_file():
            failures.append(f"{stem}: missing artifact {artifact}")
    return log.read_text(encoding="utf-8", errors="replace")


def check_selection(
    stem: str,
    text: str,
    order: list[str],
    failures: list[str],
    *,
    expect_questions: bool = True,
    expect_answers: bool = True,
    expect_solutions: bool = True,
    expect_topics: bool = True,
    selection_events: list[str] | None = None,
) -> None:
    selected = markers(text, "PQ4D-SELECT:")
    expected_events = order if selection_events is None else selection_events
    if selected != expected_events:
        failures.append(
            f"{stem}: selection events {selected}, expected {expected_events}"
        )

    questions = markers(text, "PQ4D-QUESTION:")
    expected_questions = order if expect_questions else []
    if questions != expected_questions:
        failures.append(
            f"{stem}: rendered questions {questions}, expected {expected_questions}"
        )

    answer_records = pairs(text, "PQ4C-ANSWER:")
    expected_answers = expected_pairs(order) if expect_answers else []
    if answer_records != expected_answers:
        failures.append(
            f"{stem}: answer records {answer_records}, expected {expected_answers}"
        )

    solution_records = pairs(text, "PQ4C-SOLUTION:")
    expected_solutions = expected_pairs(order) if expect_solutions else []
    if solution_records != expected_solutions:
        failures.append(
            f"{stem}: solution records {solution_records}, expected {expected_solutions}"
        )

    topic_records = re.findall(
        r"^PQ4C-RECORD:([^|\s]+)\|[^\s]+$", text, re.MULTILINE
    )
    expected_topics = order if expect_topics else []
    if topic_records != expected_topics:
        failures.append(
            f"{stem}: topic records {topic_records}, expected {expected_topics}"
        )


def main() -> int:
    if len(sys.argv) > 2:
        raise SystemExit("usage: check_physicsquiz_selection.py [build-directory]")

    build_dir = (
        Path(sys.argv[1])
        if len(sys.argv) == 2
        else Path(__file__).resolve().parents[1] / "build" / "tests"
    )
    failures: list[str] = []

    for mode, expected_content in MODE_CONTENT.items():
        stem = f"physicsquiz_selection_ids_{mode}"
        text = read_log(build_dir, stem, failures)
        if not text:
            continue
        content = set(re.findall(r"^PQ4C-CONTENT:([A-Z]+)$", text, re.MULTILINE))
        if content != expected_content:
            failures.append(
                f"{stem}: content {sorted(content)}, expected {sorted(expected_content)}"
            )
        for marker in (
            "PQ4D-COUNT:2",
            "PQ4D-TOTAL:4",
            "PQ4D-ORDER:phy104-opt-060,phy104-osc-001",
        ):
            if marker not in text:
                failures.append(f"{stem}: missing marker {marker}")
        check_selection(
            stem,
            text,
            MODE_ORDER,
            failures,
            expect_questions="QUESTIONS" in expected_content,
            expect_answers="ANSWERKEY" in expected_content,
            expect_solutions="SOLUTIONS" in expected_content,
            expect_topics="TOPICS" in expected_content,
        )

    for stem, order in POSITIVE_SELECTIONS.items():
        text = read_log(build_dir, stem, failures)
        if not text:
            continue
        selection_events = None
        if stem == "physicsquiz_selection_clear_all":
            selection_events = ["phy104-opt-060", *order]
        check_selection(
            stem, text, order, failures, selection_events=selection_events
        )

    if failures:
        for failure in failures:
            print(f"FAIL {failure}", file=sys.stderr)
        return 1

    print("All Phase 4D deterministic-selection checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
