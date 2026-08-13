# Release PDF Checklist

## Purpose

This checklist defines when and how to create preview PDFs for a GitHub release.
Preview PDFs help collaborators see the expected output without building
locally, but they remain release assets rather than ordinary source files.

## 1. Decide Whether PDFs Are Needed

Create release PDFs only when at least one of these is true:

* a collaborator needs visual previews before installing MiKTeX;
* a release announcement should show the starter outputs;
* a reviewer needs to compare expected layout against local builds; or
* a public-facing release needs quick inspection artifacts.

For routine source work, do not create release PDFs.

## 2. Build From a Clean Source Commit

From the repository root:

```powershell
git status --short --branch
git diff --check
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

Use the committed source state as the release source. Do not build release PDFs
from unstaged edits or local-only files.

## 3. Starter PDF Preview Set

The first preview set should come from the Phase 7 starter documents:

| Output | Source |
| --- | --- |
| Starter quiz bank PDF | `examples/physicsquiz/starter_quiz_bank.tex` |
| Starter versioned quiz PDF | `examples/physicsquiz/starter_versioned_quiz.tex` |
| Starter student notes PDF | `examples/studentnotes/starter_notes.tex` |
| Starter engineering notes PDF | `examples/otengineering/starter_engineering_notes.tex` |
| Starter science notes PDF | `examples/otscience/starter_science_notes.tex` |
| Starter workbook module PDF | `examples/vector-workbook/starter_module.tex` |

The Phase 7C starter runner already builds these PDFs under `build/examples/`.

## 4. Visual Review

Before attaching PDFs to a release, open each preview and check:

* the title or first page clearly identifies the starter;
* pages are not blank;
* text is not visibly overlapping;
* tables, boxes, and formulas fit the page;
* the versioned quiz answer key and solutions match the rendered paper; and
* the workbook module builds as a standalone document.

If a PDF fails visual review, fix the source starter and rerun the starter
runner. Do not patch generated PDFs directly.

## 5. File Naming

Use names that make the release and source clear:

```text
latex-lab-starter-quiz-bank-YYYY-MM-DD.pdf
latex-lab-starter-versioned-quiz-YYYY-MM-DD.pdf
latex-lab-starter-student-notes-YYYY-MM-DD.pdf
latex-lab-starter-engineering-notes-YYYY-MM-DD.pdf
latex-lab-starter-science-notes-YYYY-MM-DD.pdf
latex-lab-starter-workbook-module-YYYY-MM-DD.pdf
```

## 6. Attach to Release

Attach preview PDFs to a GitHub release. Do not commit them as ordinary source
files.

In the release notes, record:

* source commit hash;
* build command;
* whether all starter tests passed;
* whether visual review was completed; and
* which PDFs are attached.

## 7. Keep Source Clean

After preparing release PDFs:

```powershell
git status --short --branch
```

Generated PDFs, logs, and auxiliaries should remain untracked or ignored unless
a checkpoint explicitly approves a tracked baseline artifact.
