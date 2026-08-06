"""Verify the markers emitted by the Phase 3 semantic-content fixture."""

from pathlib import Path
import sys


ALL_MARKERS = {
    "QUESTIONS",
    "ANSWERKEY",
    "SOLUTIONS",
    "TEACHER",
    "REFERENCE",
    "MARKS",
    "DIFFICULTY",
}
EXPECTED = {
    "default": {
        "QUESTIONS",
        "ANSWERKEY",
        "SOLUTIONS",
        "REFERENCE",
        "MARKS",
        "DIFFICULTY",
    },
    "student": {"QUESTIONS", "REFERENCE", "MARKS"},
    "teacher": {
        "QUESTIONS",
        "ANSWERKEY",
        "TEACHER",
        "REFERENCE",
        "MARKS",
        "DIFFICULTY",
    },
    "solutions": {"SOLUTIONS", "REFERENCE"},
    "answerkey": {"ANSWERKEY"},
}

DRIVERS = {
    **{mode: mode for mode in EXPECTED},
    **{f"{mode}_print": mode for mode in EXPECTED},
}


def main() -> int:
    if len(sys.argv) > 2:
        raise SystemExit("usage: check_physicsquiz_output_modes.py [log-directory]")

    if len(sys.argv) == 2:
        log_directory = Path(sys.argv[1])
    else:
        log_directory = Path(__file__).resolve().parents[1] / "build" / "tests"

    failures: list[str] = []
    for driver, mode in DRIVERS.items():
        expected = EXPECTED[mode]
        log_path = log_directory / f"physicsquiz_content_{driver}.log"
        if not log_path.is_file():
            failures.append(f"missing log: {log_path}")
            continue

        log_text = log_path.read_text(encoding="utf-8", errors="replace")
        found = {
            marker for marker in ALL_MARKERS if f"PQ-CONTENT:{marker}" in log_text
        }
        if found != expected:
            failures.append(
                f"{driver}: expected {sorted(expected)}, found {sorted(found)}"
            )
        else:
            print(f"PASS {driver}: {', '.join(sorted(found))}")

    if failures:
        for failure in failures:
            print(f"FAIL {failure}", file=sys.stderr)
        return 1

    print("All Phase 3 semantic output-mode checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
