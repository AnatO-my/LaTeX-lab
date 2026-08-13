# Author Kit Audit

## Purpose

This audit records the first source-derived author kit. The kit is a release
asset, not a maintained second copy of the repository.

## Source State

Source commit:

```text
de87e4b
```

Manifest:

```text
docs/AUTHOR_KIT_MANIFEST.md
```

## Local Artifact Paths

Kit folder:

```text
build/author-kit/latex-lab-author-kit-2026-08-13/
```

Zip:

```text
build/author-kit/latex-lab-author-kit-2026-08-13.zip
```

Both paths are under ignored `build/`.

## Zip

| File | Bytes | SHA256 |
| --- | ---: | --- |
| `latex-lab-author-kit-2026-08-13.zip` | 56899 | `093855b8fbfd9fd2313cd49f674e5c00ffb26bc3faa6f0b499b6d6f16219fe60` |

## Included Files

The kit includes:

* `README.md`;
* `CONTRIBUTING.md`;
* `.latexmkrc`;
* `docs/AUTHOR_WORKFLOW.md`;
* `docs/STARTER_INVENTORY.md`;
* `docs/PUBLIC_INTERFACES.md`;
* `src/classes/`;
* `src/packages/`;
* `examples/physicsquiz/starter_quiz_bank.tex`;
* `examples/physicsquiz/starter_versioned_quiz.tex`;
* `examples/studentnotes/starter_notes.tex`;
* `examples/otengineering/starter_engineering_notes.tex`;
* `examples/otscience/starter_science_notes.tex`;
* `examples/vector-workbook/starter_module.tex`;
* `examples/vector-workbook/starter_combined_workbook.tex`;
* `examples/vector-workbook/00_common_setup.tex`;
* `tests/run_phase7c_starter_tests.ps1`; and
* `tests/powershell_log_helpers.ps1`.

Optional reference examples were not included.

## Verification

The kit was verified from the kit root with:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

The starter runner passed.

Before zipping, kit-local generated `build/` outputs were removed.

The final kit folder and zip were scanned and do not contain:

* `build/`;
* `.git/`;
* `tests/__pycache__/`;
* `examples/physicsquiz/indent.log`; or
* `AGENTS.md`.
