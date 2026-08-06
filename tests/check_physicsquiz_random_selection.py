"""Verify Phase 4E seeded, reproducible random question selection."""

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

ANSWERS = {
    "phy104-osc-001": "C",
    "phy104-nm-026": "B",
    "phy104-wave-031": "B",
    "phy104-opt-060": "E",
}

ALL_RECORDS = [
    "phy104-osc-001",
    "phy104-nm-026",
    "phy104-wave-031",
    "phy104-opt-060",
]

MODE_ORDER = ["phy104-wave-031", "phy104-nm-026", "phy104-osc-001"]

CASES = {
    "physicsquiz_random_default": {
        "order": MODE_ORDER,
        "seed": "104",
        "candidates": ALL_RECORDS,
    },
    "physicsquiz_random_repeat": {
        "order": MODE_ORDER,
        "seed": "104",
        "candidates": ALL_RECORDS,
    },
    "physicsquiz_random_other_seed": {
        "order": ["phy104-osc-001", "phy104-opt-060", "phy104-nm-026"],
        "seed": "105",
        "candidates": ALL_RECORDS,
    },
    "physicsquiz_random_filtered": {
        "order": ["phy104-nm-026"],
        "seed": "104",
        "candidates": ["phy104-nm-026", "phy104-wave-031"],
    },
    "physicsquiz_random_append": {
        "order": ["phy104-opt-060", "phy104-wave-031", "phy104-osc-001"],
        "seed": "104",
        "candidates": [
            "phy104-osc-001",
            "phy104-nm-026",
            "phy104-wave-031",
        ],
        "picks": ["phy104-wave-031", "phy104-osc-001"],
    },
    "physicsquiz_random_all_candidates": {
        "order": [
            "phy104-nm-026",
            "phy104-osc-001",
            "phy104-opt-060",
            "phy104-wave-031",
        ],
        "seed": "17",
        "candidates": ALL_RECORDS,
    },
}


def markers(text: str, prefix: str) -> list[str]:
    return re.findall(rf"^{re.escape(prefix)}([^\s]+)$", text, re.MULTILINE)


def pairs(text: str, prefix: str) -> list[tuple[str, str]]:
    return re.findall(
        rf"^{re.escape(prefix)}([^=\s]+)=([^\s]+)$", text, re.MULTILINE
    )


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


def check_rendered_records(
    stem: str,
    text: str,
    order: list[str],
    expected_content: set[str],
    failures: list[str],
) -> None:
    expected_questions = order if "QUESTIONS" in expected_content else []
    questions = markers(text, "PQ4D-QUESTION:")
    if questions != expected_questions:
        failures.append(
            f"{stem}: questions {questions}, expected {expected_questions}"
        )

    expected_pairs = [(record_id, ANSWERS[record_id]) for record_id in order]
    answers = pairs(text, "PQ4C-ANSWER:")
    if answers != (expected_pairs if "ANSWERKEY" in expected_content else []):
        failures.append(f"{stem}: answer order/content mismatch: {answers}")

    solutions = pairs(text, "PQ4C-SOLUTION:")
    if solutions != (expected_pairs if "SOLUTIONS" in expected_content else []):
        failures.append(f"{stem}: solution order/content mismatch: {solutions}")

    topics = re.findall(r"^PQ4C-RECORD:([^|\s]+)\|", text, re.MULTILINE)
    if topics != (order if "TOPICS" in expected_content else []):
        failures.append(f"{stem}: topic-report order mismatch: {topics}")


def check_random_case(
    stem: str,
    text: str,
    case: dict[str, object],
    failures: list[str],
    expected_content: set[str],
) -> None:
    order = case["order"]
    seed = case["seed"]
    candidates = case["candidates"]
    picks = case.get("picks", order)

    if "PQ4E-RANDOM:ALGORITHM=park-miller-v1" not in text:
        failures.append(f"{stem}: missing algorithm marker")
    if f"PQ4E-RANDOM:SEED={seed}" not in text:
        failures.append(f"{stem}: missing seed marker {seed}")
    if f"PQ4E-RANDOM:COUNT={len(picks)}" not in text:
        failures.append(f"{stem}: missing random-count marker {len(picks)}")
    if f"PQ4E-RANDOM:POOL={len(candidates)}" not in text:
        failures.append(f"{stem}: missing candidate-pool marker {len(candidates)}")

    actual_candidates = markers(text, "PQ4E-RANDOM:CANDIDATE=")
    if actual_candidates != candidates:
        failures.append(
            f"{stem}: candidates {actual_candidates}, expected {candidates}"
        )

    actual_picks = markers(text, "PQ4E-RANDOM:PICK=")
    if actual_picks != picks:
        failures.append(f"{stem}: picks {actual_picks}, expected {picks}")

    selected = markers(text, "PQ4D-SELECT:")
    if selected != order:
        failures.append(f"{stem}: selected {selected}, expected {order}")

    if len(set(actual_picks)) != len(actual_picks):
        failures.append(f"{stem}: random picks contain duplicates")

    check_rendered_records(stem, text, order, expected_content, failures)


def main() -> int:
    if len(sys.argv) > 2:
        raise SystemExit("usage: check_physicsquiz_random_selection.py [build-directory]")

    build_dir = (
        Path(sys.argv[1])
        if len(sys.argv) == 2
        else Path(__file__).resolve().parents[1] / "build" / "tests"
    )
    failures: list[str] = []
    logs: dict[str, str] = {}

    for mode, expected_content in MODE_CONTENT.items():
        stem = f"physicsquiz_random_{mode}"
        text = read_log(build_dir, stem, failures)
        logs[stem] = text
        if not text:
            continue
        content = set(re.findall(r"^PQ4C-CONTENT:([A-Z]+)$", text, re.MULTILINE))
        if content != expected_content:
            failures.append(
                f"{stem}: content {sorted(content)}, expected {sorted(expected_content)}"
            )
        check_random_case(
            stem,
            text,
            CASES["physicsquiz_random_default"],
            failures,
            expected_content,
        )

    for stem, case in CASES.items():
        if stem == "physicsquiz_random_default":
            continue
        text = read_log(build_dir, stem, failures)
        logs[stem] = text
        if text:
            check_random_case(
                stem,
                text,
                case,
                failures,
                MODE_CONTENT["default"],
            )

    default_picks = markers(logs.get("physicsquiz_random_default", ""), "PQ4E-RANDOM:PICK=")
    repeat_picks = markers(logs.get("physicsquiz_random_repeat", ""), "PQ4E-RANDOM:PICK=")
    other_picks = markers(logs.get("physicsquiz_random_other_seed", ""), "PQ4E-RANDOM:PICK=")
    if default_picks != repeat_picks:
        failures.append("same bank, filter, count, and seed did not reproduce the same picks")
    if default_picks == other_picks:
        failures.append("the selected comparison seeds produced identical picks")

    all_picks = markers(
        logs.get("physicsquiz_random_all_candidates", ""), "PQ4E-RANDOM:PICK="
    )
    if sorted(all_picks) != sorted(ALL_RECORDS):
        failures.append("all-candidate selection is not a permutation of the bank")

    if failures:
        for failure in failures:
            print(f"FAIL {failure}", file=sys.stderr)
        return 1

    print("All Phase 4E seeded-random-selection checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
