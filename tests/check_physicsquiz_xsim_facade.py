"""Verify the production Phase 4C xsim-backed physicsquiz interface."""

from pathlib import Path
import re
import sys


EXPECTED_CONTENT = {
    "default": {"QUESTIONS", "ANSWERKEY", "TOPICS", "SOLUTIONS", "REFERENCE"},
    "student": {"QUESTIONS", "REFERENCE"},
    "teacher": {"QUESTIONS", "ANSWERKEY", "TOPICS", "TEACHER", "REFERENCE"},
    "solutions": {"SOLUTIONS", "REFERENCE"},
    "answerkey": {"ANSWERKEY", "TOPICS"},
}

EXPECTED_ANSWERS = {
    "phy104-osc-001": "C",
    "phy104-nm-026": "B",
    "phy104-wave-031": "B",
    "phy104-opt-060": "E",
}

EXPECTED_RECORDS = {
    "phy104-osc-001": ("oscillations", "foundation", "1"),
    "phy104-nm-026": ("normal-modes", "applied", "2"),
    "phy104-wave-031": ("waves-and-sound", "applied", "2"),
    "phy104-opt-060": ("optics", "challenge", "3"),
}


def marker_pairs(text: str, prefix: str) -> dict[str, str]:
    pattern = rf"^{re.escape(prefix)}([^=\s]+)=([^\s]+)$"
    return dict(re.findall(pattern, text, flags=re.MULTILINE))


def main() -> int:
    if len(sys.argv) > 2:
        raise SystemExit("usage: check_physicsquiz_xsim_facade.py [build-directory]")

    build_dir = (
        Path(sys.argv[1])
        if len(sys.argv) == 2
        else Path(__file__).resolve().parents[1] / "build" / "tests"
    )

    failures: list[str] = []

    for mode, expected_content in EXPECTED_CONTENT.items():
        stem = f"physicsquiz_xsim_{mode}"
        log_path = build_dir / f"{stem}.log"
        pdf_path = build_dir / f"{stem}.pdf"
        synctex_path = build_dir / f"{stem}.synctex.gz"

        if not log_path.is_file():
            failures.append(f"{mode}: missing log {log_path}")
            continue
        if not pdf_path.is_file():
            failures.append(f"{mode}: missing PDF {pdf_path}")
        if not synctex_path.is_file():
            failures.append(f"{mode}: missing SyncTeX file {synctex_path}")

        text = log_path.read_text(encoding="utf-8", errors="replace")
        content = set(re.findall(r"^PQ4C-CONTENT:([A-Z]+)$", text, re.MULTILINE))
        if content != expected_content:
            failures.append(
                f"{mode}: expected content {sorted(expected_content)}, "
                f"found {sorted(content)}"
            )

        for marker in ("PQ4C-BACKEND:XSIM", "PQ4C-COUNT:4", "PQ4C-TOTAL:8"):
            if marker not in text:
                failures.append(f"{mode}: missing marker {marker}")

        answers = marker_pairs(text, "PQ4C-ANSWER:")
        if "ANSWERKEY" in expected_content:
            if answers != EXPECTED_ANSWERS:
                failures.append(
                    f"{mode}: expected answers {EXPECTED_ANSWERS}, found {answers}"
                )
        elif answers:
            failures.append(f"{mode}: answer records leaked into this mode: {answers}")

        solutions = marker_pairs(text, "PQ4C-SOLUTION:")
        if "SOLUTIONS" in expected_content:
            if solutions != EXPECTED_ANSWERS:
                failures.append(
                    f"{mode}: expected solution associations {EXPECTED_ANSWERS}, "
                    f"found {solutions}"
                )
        elif solutions:
            failures.append(f"{mode}: solutions leaked into this mode: {solutions}")

        records = {
            record_id: (topic, difficulty, marks)
            for record_id, topic, difficulty, marks in re.findall(
                r"^PQ4C-RECORD:([^|\s]+)\|([^|\s]+)\|([^|\s]+)\|([^\s]+)$",
                text,
                flags=re.MULTILINE,
            )
        }
        if "TOPICS" in expected_content:
            if records != EXPECTED_RECORDS:
                failures.append(
                    f"{mode}: expected records {EXPECTED_RECORDS}, found {records}"
                )
        elif records:
            failures.append(f"{mode}: metadata records leaked into this mode: {records}")

        if not failures or not any(item.startswith(f"{mode}:") for item in failures):
            print(f"PASS {mode}: {', '.join(sorted(content))}")

    if failures:
        for failure in failures:
            print(f"FAIL {failure}", file=sys.stderr)
        return 1

    print("All Phase 4C structured-interface checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
