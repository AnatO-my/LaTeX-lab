# Author Kit Manifest

## Purpose

This manifest lists the files that belong in a source-derived author kit. It is
a packaging boundary, not a second copy of the project.

Use `docs/AUTHOR_KIT_BUILD_CHECKLIST.md` for the step-by-step process of
assembling, verifying, and sharing the kit. Use
`scripts/new-author-kit.ps1` to create the standard kit under
`build/author-kit/`.

## Required Files

| Area | Include |
| --- | --- |
| Repository overview | `README.md` |
| Contribution guide | `CONTRIBUTING.md` |
| Local build configuration | `.latexmkrc` |
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
| Personal book starter | `examples/otbook/starter_personal_book.tex` |
| Copyable book project | `templates/otbook-project/` (source only, including dotfiles) |
| Workbook module starter | `examples/vector-workbook/starter_module.tex` |
| Combined workbook starter | `examples/vector-workbook/starter_combined_workbook.tex` |
| Workbook shared setup | `examples/vector-workbook/00_common_setup.tex` |
| Starter verification | `tests/run_phase7c_starter_tests.ps1` and `tests/run_otbook_tests.ps1` |
| Book smoke document | `tests/otbook_class_smoke.tex` |
| Log retry helper | `tests/powershell_log_helpers.ps1` |

The required class tree includes `src/classes/otbook.cls`. Include the complete
package tree so its conditional OT companion commands are available. The kit
contains eight starters; the Phase 7 runner verifies the original seven and
the otbook runner verifies the book workflow.

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
powershell -ExecutionPolicy Bypass -File tests\run_otbook_tests.ps1
```

The kit is usable when both runners pass. The otbook runner verifies the book
starter, smoke document, and project template; do not include the generated
template `build/` directory when packaging the kit.
The historical kit in `docs/AUTHOR_KIT_AUDIT.md` predates `otbook`; updating this
manifest does not rebuild that archive.
