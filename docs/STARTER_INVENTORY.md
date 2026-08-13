# Starter Inventory

## Purpose

This inventory separates true copyable starters from representative examples.
Representative examples prove the classes work, but they are often too large or
course-specific to be the best starting point for a new author document.

## Current Starters and Examples

| Area | Current file | Current role | Phase 7 decision |
| --- | --- | --- | --- |
| Structured physics quiz bank | `examples/physicsquiz/starter_quiz_bank.tex` | True starter | Keep as the first approved starter. |
| Full PHY104 structured paper | `examples/physicsquiz/PHY104_structured_revision.tex` | Representative example | Do not present as a blank starter. |
| Versioned PHY104 paper | `examples/physicsquiz/PHY104_versioned_paper.tex` | Representative versioning example | Keep as an example; later add a smaller versioned starter if useful. |
| Legacy PHY104 paper | `examples/physicsquiz/PHY104_Exam revision.tex` | Baseline example | Do not use as a starter. |
| Student notes | `examples/studentnotes/Optics.tex` | Representative example | Needs a small starter. |
| Engineering notes | `examples/otengineering/test.tex` | Representative example | Needs a small starter. |
| Science notes | none under `examples/otscience/` | Missing example/starter | Needs a small starter and example folder. |
| Vector workbook | `examples/vector-workbook/00_main_combined_workbook.tex` | Representative combined workbook | Needs a small module starter or copy instructions. |

## Starter Acceptance Rules

A Phase 7 starter should:

* compile from the repository root with the project `.latexmkrc`;
* use the public class or package interface only;
* contain enough real content to show structure;
* avoid course-specific bulk content;
* avoid generated outputs in source control unless explicitly approved;
* use paths that survive being copied within the repository; and
* have a small verification command or be included in a starter runner.

## Missing Starter Set

The minimum useful starter set is:

* `examples/physicsquiz/starter_quiz_bank.tex` - already present;
* `examples/physicsquiz/starter_versioned_quiz.tex`;
* `examples/studentnotes/starter_notes.tex`;
* `examples/otengineering/starter_engineering_notes.tex`;
* `examples/otscience/starter_science_notes.tex`;
* `examples/vector-workbook/starter_module.tex`; and
* optionally `examples/vector-workbook/starter_combined_workbook.tex`.

## Next Checkpoint

Checkpoint 7C should add the missing minimal starters and a runner that builds
them all. The runner should be separate from the large regression suites so
authors can quickly verify that the copyable starting points still work.
