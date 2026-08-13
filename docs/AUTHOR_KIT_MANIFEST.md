# Author Kit Manifest

## Purpose

This manifest lists the files that belong in a future source-derived author kit.
It is a packaging boundary, not a second copy of the project.

## Required Files

| Area | Include |
| --- | --- |
| Repository overview | `README.md` |
| Contribution guide | `CONTRIBUTING.md` |
| Author workflow | `docs/AUTHOR_WORKFLOW.md` |
| Starter inventory | `docs/STARTER_INVENTORY.md` |
| Public interface record | `docs/PUBLIC_INTERFACES.md` |
| Classes | `src/classes/` |
| Packages | `src/packages/` |
| Physics quiz bank starter | `examples/physicsquiz/starter_quiz_bank.tex` |
| Versioned quiz starter | `examples/physicsquiz/starter_versioned_quiz.tex` |
| Student notes starter | `examples/studentnotes/starter_notes.tex` |
| Engineering notes starter | `examples/otengineering/starter_engineering_notes.tex` |
| Science notes starter | `examples/otscience/starter_science_notes.tex` |
| Workbook module starter | `examples/vector-workbook/starter_module.tex` |
| Workbook shared setup | `examples/vector-workbook/00_common_setup.tex` |
| Starter verification | `tests/run_phase7c_starter_tests.ps1` |
| Log retry helper | `tests/powershell_log_helpers.ps1` |

## Optional Reference Examples

These are helpful but can make an author kit feel less lightweight:

| Area | Optional file |
| --- | --- |
| Full PHY104 structured paper | `examples/physicsquiz/PHY104_structured_revision.tex` |
| Full PHY104 versioned paper | `examples/physicsquiz/PHY104_versioned_paper.tex` |
| Student notes example | `examples/studentnotes/Optics.tex` |
| Engineering notes example | `examples/otengineering/test.tex` |
| Full vector workbook | `examples/vector-workbook/00_main_combined_workbook.tex` |

## Excluded Files

Exclude generated or local-only files:

* `build/`;
* `tests/__pycache__/`;
* `examples/physicsquiz/indent.log`;
* ordinary `.aux`, `.log`, `.fls`, `.fdb_latexmk`, `.out`, `.toc`, and
  `.synctex.gz` files; and
* local instruction files that are not meant for collaborators.

## Verification

After creating an author kit from the manifest, run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

The kit is usable when all starter builds pass.
