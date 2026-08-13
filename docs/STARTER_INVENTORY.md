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
| Versioned quiz paper | `examples/physicsquiz/starter_versioned_quiz.tex` | True starter | Use as the copyable versioned-paper starter. |
| Versioned PHY104 paper | `examples/physicsquiz/PHY104_versioned_paper.tex` | Representative versioning example | Keep as a full-course example. |
| Legacy PHY104 paper | `examples/physicsquiz/PHY104_Exam revision.tex` | Baseline example | Do not use as a starter. |
| Student notes | `examples/studentnotes/starter_notes.tex` | True starter | Use as the copyable notes starter. |
| Student notes optics document | `examples/studentnotes/Optics.tex` | Representative example | Keep as a larger worked example. |
| Engineering notes | `examples/otengineering/starter_engineering_notes.tex` | True starter | Use as the copyable engineering notebook starter. |
| Engineering headphones document | `examples/otengineering/test.tex` | Representative example | Keep as a larger worked example. |
| Science notes | `examples/otscience/starter_science_notes.tex` | True starter | Use as the copyable science notes starter. |
| Vector workbook module | `examples/vector-workbook/starter_module.tex` | True starter | Use as the copyable standalone module starter. |
| Vector workbook combined root | `examples/vector-workbook/starter_combined_workbook.tex` | True starter | Use as the copyable combined-workbook root. |
| Vector workbook | `examples/vector-workbook/00_main_combined_workbook.tex` | Representative combined workbook | Keep as the full combined-workbook example. |

## Starter Acceptance Rules

A Phase 7 starter should:

* compile from the repository root with the project `.latexmkrc`;
* use the public class or package interface only;
* contain enough real content to show structure;
* avoid course-specific bulk content;
* avoid generated outputs in source control unless explicitly approved;
* use paths that survive being copied within the repository; and
* have a small verification command or be included in a starter runner.

## Starter Set

The minimum useful starter set is:

* `examples/physicsquiz/starter_quiz_bank.tex`;
* `examples/physicsquiz/starter_versioned_quiz.tex`;
* `examples/studentnotes/starter_notes.tex`;
* `examples/otengineering/starter_engineering_notes.tex`;
* `examples/otscience/starter_science_notes.tex`;
* `examples/vector-workbook/starter_module.tex`; and
* `examples/vector-workbook/starter_combined_workbook.tex`.

## Verification

Checkpoint 7C added the missing minimal starters and
`tests/run_phase7c_starter_tests.ps1`. The runner is separate from the large
regression suites so authors can quickly verify that the copyable starting
points still work.
