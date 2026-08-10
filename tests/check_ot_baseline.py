#!/usr/bin/env python3
"""Record and verify the OT-side rendering baseline for Phase 5.

Phase 5 moves colours, boxes and package loading between files while claiming
that no rendered output changes.  That claim has to be machine-checked, because
Phase 4 produced two late failures that manual inspection missed.

For every document the runner builds, this checker records:

  * the page count and PDF byte size, read from the LaTeX log;
  * the count of every diagnostic class present in the log; and
  * a SHA-256 of the extracted page text, when a text extractor is available.

The OT side cannot assert "zero diagnostics" the way the physicsquiz runners do:
``examples/otengineering/test.tex`` has a known, accepted underfull box, and the
combined workbook loads ``silence``.  So the assertion is *no change from the
recorded baseline*, which is both truthful about the current state and strict
about regressions.

Usage
-----
    python check_ot_baseline.py record <manifest.json> <jobs.tsv>
    python check_ot_baseline.py verify <manifest.json> <jobs.tsv>

``jobs.tsv`` holds one tab-separated ``key<TAB>log<TAB>pdf`` line per document.
The runner writes it, so that neither Windows command-line length limits nor
quoting rules constrain how many documents the suite covers.

Exit status is 0 on success and 1 on any hard failure.  Byte-size drift is
reported as a warning only: it is a weak content proxy and it moves for benign
reasons.  Page counts, diagnostic counts and the text hash are hard assertions.
"""

from __future__ import annotations

import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
from datetime import datetime, timezone

MANIFEST_VERSION = 1

# "Output written on foo.pdf (23 pages, 313392 bytes)."
#
# TeX hard-wraps every log line at max_print_line (79 by default) with no
# continuation marker, and the break can fall anywhere - inside the path,
# inside a number, even inside the word "bytes".  A repository path is long
# enough that this line always wraps in practice:
#
#     Output written on C:/Users\Ot\...\build\tests\ot
#     _palette_probe_science.pdf (1 page, 41351 bytes).
#
# So the search runs against the log with newlines removed, and every
# separator is \s* rather than a literal space, because the wrap consumes
# the space when the break happens to fall on one.
_OUTPUT_RE = re.compile(
    r"Output written on\s*(?:.*?)\s*\((\d+)\s*pages?,\s*(\d+)\s*bytes\)\."
)


def unwrap(text: str) -> str:
    """Undo TeX's fixed-width log wrapping for whole-line pattern matching.

    Only safe for patterns matched once per log.  Diagnostic counting keeps
    using the original line structure, because those messages start at
    column 0 and counting them in unwrapped text would be meaningless.
    """
    return text.replace("\r\n", "\n").replace("\n", "")

# Diagnostic classes counted in every log.  Each entry is (label, matcher).
# Substring matchers are used where the message starts at column 0 and is never
# wrapped by TeX's 79-column log formatting; regexes are used where the package
# or class name varies.
_SUBSTRING_CLASSES = (
    "LaTeX Warning:",
    "LaTeX Font Warning:",
    r"Overfull \hbox",
    r"Underfull \hbox",
    r"Overfull \vbox",
    r"Underfull \vbox",
    "Missing character:",
)

_PACKAGE_WARNING_RE = re.compile(r"^Package (\w+) Warning:")
_CLASS_WARNING_RE = re.compile(r"^Class (\w+) Warning:")


def read_text(path: str) -> str:
    """Read a LaTeX log tolerantly.

    Logs mix encodings depending on which packages wrote to them, so decoding
    must never be the reason a checkpoint fails.
    """
    with open(path, "r", encoding="utf-8", errors="replace") as handle:
        return handle.read()


def parse_log(path: str) -> dict:
    text = read_text(path)

    match = _OUTPUT_RE.search(unwrap(text))
    if match is None:
        raise ValueError(
            f"{path}: no 'Output written on ... (N pages, M bytes).' line. "
            "The build did not produce a PDF, so there is nothing to baseline."
        )
    pages = int(match.group(1))
    size = int(match.group(2))

    diagnostics: dict[str, int] = {label: 0 for label in _SUBSTRING_CLASSES}
    for line in text.splitlines():
        for label in _SUBSTRING_CLASSES:
            if label in line:
                diagnostics[label] += 1
        package = _PACKAGE_WARNING_RE.match(line)
        if package is not None:
            key = f"Package {package.group(1)} Warning:"
            diagnostics[key] = diagnostics.get(key, 0) + 1
        klass = _CLASS_WARNING_RE.match(line)
        if klass is not None:
            key = f"Class {klass.group(1)} Warning:"
            diagnostics[key] = diagnostics.get(key, 0) + 1

    # Drop the always-present zeros so the manifest stays readable and a newly
    # appearing class is visible as an added key rather than a changed number.
    diagnostics = {k: v for k, v in diagnostics.items() if v}
    return {"pages": pages, "bytes": size, "diagnostics": diagnostics}


def text_extractor() -> str | None:
    """Return the name of an available PDF text extractor, or None.

    MiKTeX does not ship ``pdftotext``; it arrives with poppler or Xpdf.  The
    baseline therefore treats text hashing as an optional strengthening rather
    than a requirement, and says so loudly when it is unavailable.
    """
    return "pdftotext" if shutil.which("pdftotext") else None


def hash_pdf_text(pdf_path: str) -> str | None:
    if text_extractor() is None:
        return None
    try:
        completed = subprocess.run(
            ["pdftotext", "-q", "-enc", "UTF-8", pdf_path, "-"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=True,
        )
    except (OSError, subprocess.CalledProcessError) as error:
        print(f"  NOTE  text extraction failed for {pdf_path}: {error}")
        return None
    return hashlib.sha256(completed.stdout).hexdigest()


def load_jobs(path: str) -> list[tuple[str, str, str]]:
    jobs: list[tuple[str, str, str]] = []
    for number, raw in enumerate(read_text(path).splitlines(), start=1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        parts = line.split("\t")
        if len(parts) != 3:
            raise ValueError(
                f"{path}:{number}: expected 'key<TAB>log<TAB>pdf', got {line!r}"
            )
        jobs.append((parts[0], parts[1], parts[2]))
    return jobs


def collect(jobs: list[tuple[str, str, str]]) -> dict:
    documents: dict[str, dict] = {}
    for key, log_path, pdf_path in jobs:
        if not os.path.isfile(log_path):
            raise FileNotFoundError(f"{key}: missing log {log_path}")
        if not os.path.isfile(pdf_path):
            raise FileNotFoundError(f"{key}: missing PDF {pdf_path}")
        entry = parse_log(log_path)
        entry["text_sha256"] = hash_pdf_text(pdf_path)
        documents[key] = entry
    return documents


def command_record(manifest_path: str, jobs_path: str) -> int:
    documents = collect(load_jobs(jobs_path))
    extractor = text_extractor()
    manifest = {
        "manifest_version": MANIFEST_VERSION,
        "recorded": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "text_extractor": extractor,
        "documents": documents,
    }
    with open(manifest_path, "w", encoding="utf-8", newline="\n") as handle:
        json.dump(manifest, handle, indent=2, sort_keys=True)
        handle.write("\n")

    print(f"Recorded {len(documents)} documents into {manifest_path}.")
    total_pages = sum(d["pages"] for d in documents.values())
    print(f"Total pages baselined: {total_pages}.")
    hashed = sum(1 for d in documents.values() if d.get("text_sha256"))
    if extractor is None:
        print(
            "WARNING  No pdftotext on PATH. The baseline proves page counts and\n"
            "         diagnostics only, not rendered text. Install poppler or\n"
            "         Xpdf and re-record for the stronger guarantee."
        )
    elif hashed != len(documents):
        print(
            f"WARNING  {extractor} is installed but produced text for only "
            f"{hashed} of {len(documents)} documents.\n"
            "         The remainder are baselined by page count and "
            "diagnostics only."
        )
    else:
        print(f"Rendered text hashed for all {hashed} documents via {extractor}.")
    return 0


def command_verify(manifest_path: str, jobs_path: str) -> int:
    if not os.path.isfile(manifest_path):
        print(
            f"FAIL  No baseline manifest at {manifest_path}.\n"
            "      Run the suite once with -Record against unmodified sources "
            "before using it to judge a change."
        )
        return 1

    with open(manifest_path, "r", encoding="utf-8") as handle:
        manifest = json.load(handle)

    baseline = manifest.get("documents", {})
    current = collect(load_jobs(jobs_path))

    failures: list[str] = []
    warnings: list[str] = []

    missing = sorted(set(baseline) - set(current))
    for key in missing:
        failures.append(f"{key}: in the baseline but not built by this run.")

    added = sorted(set(current) - set(baseline))
    for key in added:
        failures.append(
            f"{key}: built but absent from the baseline. "
            "Re-record deliberately if this document is a new addition."
        )

    for key in sorted(set(baseline) & set(current)):
        want = baseline[key]
        have = current[key]

        if want["pages"] != have["pages"]:
            failures.append(
                f"{key}: page count {want['pages']} -> {have['pages']}."
            )

        want_diag = want.get("diagnostics", {})
        have_diag = have.get("diagnostics", {})
        if want_diag != have_diag:
            lines = [f"{key}: diagnostics changed."]
            for label in sorted(set(want_diag) | set(have_diag)):
                before = want_diag.get(label, 0)
                after = have_diag.get(label, 0)
                if before != after:
                    lines.append(f"      {label!r}: {before} -> {after}")
            failures.append("\n".join(lines))

        want_hash = want.get("text_sha256")
        have_hash = have.get("text_sha256")
        if want_hash and have_hash:
            if want_hash != have_hash:
                failures.append(
                    f"{key}: rendered text changed "
                    f"({want_hash[:12]}... -> {have_hash[:12]}...)."
                )
        elif want_hash and not have_hash:
            warnings.append(
                f"{key}: baseline has a text hash but this run could not "
                "extract text. Content is unverified for this document."
            )
        elif have_hash and not want_hash:
            warnings.append(
                f"{key}: text hash now available but the baseline predates it. "
                "Re-record to gain rendered-text coverage."
            )

        if want["bytes"] != have["bytes"]:
            warnings.append(
                f"{key}: PDF size {want['bytes']} -> {have['bytes']} bytes "
                "(reported only; size is a weak content proxy)."
            )

    for message in warnings:
        print(f"WARN  {message}")

    if failures:
        print()
        for message in failures:
            print(f"FAIL  {message}")
        print()
        print(f"{len(failures)} baseline difference(s). The checkpoint has "
              "changed rendered output.")
        return 1

    checked = len(set(baseline) & set(current))
    hashed = sum(
        1 for key in set(baseline) & set(current)
        if baseline[key].get("text_sha256") and current[key].get("text_sha256")
    )
    print(
        f"All {checked} documents match the recorded baseline "
        f"({hashed} verified by rendered text, {checked - hashed} by page "
        "count and diagnostics only)."
    )
    return 0


def main(argv: list[str]) -> int:
    if len(argv) != 4 or argv[1] not in {"record", "verify"}:
        print(__doc__)
        return 2
    mode, manifest_path, jobs_path = argv[1], argv[2], argv[3]
    try:
        if mode == "record":
            return command_record(manifest_path, jobs_path)
        return command_verify(manifest_path, jobs_path)
    except (OSError, ValueError, json.JSONDecodeError) as error:
        print(f"FAIL  {error}")
        return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
