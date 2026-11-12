#!/usr/bin/env python3
"""Generate the LaTeX-lab interface and dependency inventory.

Scans every class and package under src/ and writes a Markdown report listing,
per file: version line, options, base class, required/conditional packages,
public commands, environments, counters, colours and load-time side effects.
It then cross-references names defined in more than one file and names that
are defined with \\providecommand (whose meaning can depend on load order).

Usage (from the repository root):

    python scripts/audit_interfaces.py                 # writes docs/INTERFACE_INVENTORY.md
    python scripts/audit_interfaces.py --stdout        # print instead
    python scripts/audit_interfaces.py --check         # exit 1 if the file is stale

The scan is lexical, not a TeX run: it reports what the source declares, so
definitions produced indirectly (loops, \\csname constructions) are not seen.
"""

from __future__ import annotations

import argparse
import re
import sys
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCE_DIRS = ["src/classes", "src/packages", "src/legacy"]
OUTPUT = ROOT / "docs" / "INTERFACE_INVENTORY.md"
PUBLIC_DOC = ROOT / "docs" / "PUBLIC_INTERFACES.md"

NAME = r"[A-Za-z@]+"
CMD_DEF = re.compile(
    r"\\(newcommand|renewcommand|providecommand|DeclareMathOperator|"
    r"NewDocumentCommand|RenewDocumentCommand|ProvideDocumentCommand|"
    r"DeclareDocumentCommand|newrobustcmd|DeclareRobustCommand)\*?\s*\{?\\(" + NAME + r")"
)
ENV_DEF = re.compile(
    r"\\(newenvironment|renewenvironment|NewDocumentEnvironment|newtcolorbox|"
    r"NewTColorBox|DeclareTColorBox|newtcbtheorem|newtcblisting|NewTCBListing|"
    r"newtheorem|declaretheorem)\*?\s*(?:\[[^\]]*\]\s*)?\{(" + NAME + r")\}"
)
COUNTER_DEF = re.compile(r"\\newcounter\{(" + NAME + r")\}")
COLOUR_DEF = re.compile(r"\\(?:definecolor|colorlet)\{([A-Za-z0-9@-]+)\}")
OPTION_DEF = re.compile(
    r"\\(?:DeclareOption|DeclareStringOption|DeclareBoolOption|"
    r"DeclareComplementaryOption|DeclareVoidOption)\*?(?:\[[^\]]*\])?\{([A-Za-z0-9-]+)\}"
)
KEYS_DEF = re.compile(r"\\DeclareKeys\b")
LOAD_CLASS = re.compile(r"\\LoadClass(?:WithOptions)?\s*(?:\[[^\]]*\])?\s*\{([^}]+)\}")
REQUIRE = re.compile(r"\\RequirePackage\s*(?:\[[^\]]*\])?\s*\{([^}]+)\}")
COND_REQUIRE = re.compile(
    r"\\IfFileExists\{([^}]+?)\.sty\}\s*\{\s*\\RequirePackage\s*(?:\[[^\]]*\])?\s*\{([^}]+)\}"
)
PROBE = re.compile(r"\\(?:IfFileExists|InputIfFileExists)\{([^}]+)\}")
SIDE_EFFECTS = {
    "hypersetup": r"\\hypersetup\b",
    "geometry": r"\\RequirePackage\s*\[[^\]]*\]\s*\{geometry\}|\\geometry\{",
    "pagestyle": r"\\pagestyle\{",
    "titleformat": r"\\titleformat\b",
    "setlist": r"\\setlist\b",
    "sisetup": r"\\sisetup\b",
    "setlength": r"\\setlength\b",
    "AtBeginDocument": r"\\AtBeginDocument\b",
}


def strip_comments(text: str) -> str:
    out = []
    for line in text.splitlines():
        cut = re.search(r"(?<!\\)%", line)
        out.append(line[: cut.start()] if cut else line)
    return "\n".join(out)


def split_names(spec: str) -> list[str]:
    return [p.strip() for p in spec.split(",") if p.strip()]


def scan(path: Path) -> dict:
    raw = path.read_text(encoding="utf-8", errors="replace")
    text = strip_comments(raw)
    provides = re.search(r"\\Provides(?:Class|Package)\{[^}]+\}\[([^\]]*)\]", text)
    conditional = [(m.group(1), m.group(2)) for m in COND_REQUIRE.finditer(text)]
    cond_names = {pkg for _, spec in conditional for pkg in split_names(spec)}
    required = []
    for m in REQUIRE.finditer(text):
        for pkg in split_names(m.group(1)):
            if pkg not in cond_names and pkg not in required:
                required.append(pkg)
    commands = defaultdict(set)
    for m in CMD_DEF.finditer(text):
        commands[m.group(2)].add(m.group(1))
    envs = defaultdict(set)
    for m in ENV_DEF.finditer(text):
        envs[m.group(2)].add(m.group(1))
    probes = sorted({m.group(1) for m in PROBE.finditer(text)} - {f"{c}.sty" for c, _ in conditional})
    return {
        "path": path.relative_to(ROOT).as_posix(),
        "kind": "class" if path.suffix == ".cls" else "package",
        "version": provides.group(1) if provides else "(no version line)",
        "base": [m.group(1) for m in LOAD_CLASS.finditer(text)],
        "options": sorted(set(OPTION_DEF.findall(text))) + (["(l3keys \\DeclareKeys)"] if KEYS_DEF.search(text) else []),
        "required": required,
        "conditional": sorted(cond_names),
        "probes": probes,
        "commands": commands,
        "envs": envs,
        "counters": sorted(set(COUNTER_DEF.findall(text))),
        "colours": sorted(set(COLOUR_DEF.findall(text))),
        "effects": [k for k, pat in SIDE_EFFECTS.items() if re.search(pat, text)],
    }


def documented_names() -> set[str]:
    if not PUBLIC_DOC.exists():
        return set()
    text = PUBLIC_DOC.read_text(encoding="utf-8", errors="replace")
    return set(re.findall(r"\\?([A-Za-z@]+)", " ".join(re.findall(r"`([^`]+)`", text))))


def status(name: str, documented: set[str]) -> str:
    if "@" in name:
        return "internal"
    return "documented" if name in documented else "undocumented"


def fmt_names(items: dict, documented: set[str]) -> str:
    if not items:
        return "—"
    parts = []
    for name in sorted(items, key=str.lower):
        tag = status(name, documented)
        how = items[name]
        mark = ""
        if "providecommand" in how or "ProvideDocumentCommand" in how:
            mark = " ⚠provide"
        elif "renewcommand" in how or "renewenvironment" in how:
            mark = " ↻renew"
        parts.append(f"`{name}`{'' if tag == 'documented' else ' (' + tag + ')'}{mark}")
    return ", ".join(parts)


def build(files: list[dict]) -> str:
    documented = documented_names()
    lines = [
        "# Interface Inventory",
        "",
        "Generated by `scripts/audit_interfaces.py`; do not edit by hand. Re-run",
        "the script after changing any class or package, and use `--check` in",
        "release checks to detect a stale inventory.",
        "",
        "The scan is lexical. Status labels: *documented* means the name appears in",
        "`docs/PUBLIC_INTERFACES.md`; *undocumented* means it does not (it may still be",
        "intended as public); *internal* means the name contains `@`. `⚠provide` marks",
        "a `\\providecommand`-style definition, whose meaning can depend on load order;",
        "`↻renew` marks a redefinition of an existing name.",
        "",
        "## Dependency graph",
        "",
        "| File | Base class | Requires | Conditional (`\\IfFileExists`) | Other file probes |",
        "| --- | --- | --- | --- | --- |",
    ]
    for f in files:
        lines.append(
            f"| `{f['path']}` | {', '.join(f['base']) or '—'} | "
            f"{', '.join(f['required']) or '—'} | {', '.join(f['conditional']) or '—'} | "
            f"{', '.join('`' + p + '`' for p in f['probes']) or '—'} |"
        )
    # Cross-file analysis
    owners = defaultdict(list)
    for f in files:
        for name in list(f["commands"]) + list(f["envs"]):
            if "@" not in name:
                owners[name].append(f["path"])
    shared = {n: p for n, p in owners.items() if len(p) > 1}
    provided = sorted(
        (n, f["path"]) for f in files for n, how in f["commands"].items()
        if "providecommand" in how or "ProvideDocumentCommand" in how
    )
    lines += ["", "## Names defined in more than one file", ""]
    if shared:
        lines += ["| Name | Defined in |", "| --- | --- |"]
        for n in sorted(shared, key=str.lower):
            lines.append(f"| `{n}` | {', '.join('`' + p + '`' for p in shared[n])} |")
    else:
        lines.append("None.")
    lines += ["", "## Load-order-dependent definitions (`\\providecommand`)", ""]
    if provided:
        lines += ["| Name | File |", "| --- | --- |"]
        lines += [f"| `\\{n}` | `{p}` |" for n, p in provided]
    else:
        lines.append("None.")
    lines += ["", "## Per-file inventory", ""]
    for f in files:
        lines += [
            f"### `{f['path']}`",
            "",
            f"* **Kind / version:** {f['kind']}, `{f['version']}`",
            f"* **Options:** {', '.join('`' + o + '`' for o in f['options']) or '—'}",
            f"* **Load-time effects:** {', '.join('`' + e + '`' for e in f['effects']) or '—'}",
            f"* **Commands:** {fmt_names(f['commands'], documented)}",
            f"* **Environments:** {fmt_names(f['envs'], documented)}",
            f"* **Counters:** {', '.join('`' + c + '`' for c in f['counters']) or '—'}",
            f"* **Colours:** {', '.join('`' + c + '`' for c in f['colours']) or '—'}",
            "",
        ]
    return "\n".join(lines).rstrip() + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--stdout", action="store_true", help="print the report")
    parser.add_argument("--check", action="store_true", help="fail if the report is stale")
    args = parser.parse_args()
    paths = sorted(p for d in SOURCE_DIRS for p in (ROOT / d).glob("*") if p.suffix in {".cls", ".sty"})
    report = build([scan(p) for p in paths])
    if args.stdout:
        sys.stdout.write(report)
        return 0
    if args.check:
        current = OUTPUT.read_text(encoding="utf-8") if OUTPUT.exists() else ""
        if current != report:
            print(f"{OUTPUT.relative_to(ROOT)} is stale; re-run scripts/audit_interfaces.py")
            return 1
        print("Interface inventory is current.")
        return 0
    OUTPUT.write_text(report, encoding="utf-8", newline="\n")
    print(f"Wrote {OUTPUT.relative_to(ROOT)} ({len(paths)} files scanned)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
