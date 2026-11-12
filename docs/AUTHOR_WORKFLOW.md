# Author Workflow

## Purpose

This guide explains how a local author should start, build, and share documents
from this repository without needing to know the internal class implementation.

Phase 7 treats the project as a usable local product: a collaborator should be
able to clone the repository, choose a starter, edit content, build locally, and
avoid committing generated clutter.

## Local Setup

Use the repository root as the working directory. The root `.latexmkrc` makes
the classes in `src/classes` and packages in `src/packages` visible to TeX.

Required local tools:

* MiKTeX
* `latexmk`
* pdfLaTeX
* Python as `py -3` or `python`
* MiKTeX packages including `xsim` and `siunitx`

## Starting Documents

Use these copyable starters:

| Goal | Starter |
| --- | --- |
| Structured physics quiz bank | `examples/physicsquiz/starter_quiz_bank.tex` |
| Versioned quiz paper | `examples/physicsquiz/starter_versioned_quiz.tex` |
| Student notes | `examples/studentnotes/starter_notes.tex` |
| Engineering notes | `examples/otengineering/starter_engineering_notes.tex` |
| Science notes | `examples/otscience/starter_science_notes.tex` |
| Personal book with native chapters | `examples/otbook/starter_personal_book.tex` |
| Vector workbook module | `examples/vector-workbook/starter_module.tex` |
| Combined vector workbook | `examples/vector-workbook/starter_combined_workbook.tex` |

See `docs/STARTER_INVENTORY.md` for the distinction between true starters and
representative examples. Larger course-shaped examples remain available when
you want to study a finished document rather than start a small one.

Copy a starter into a new project folder only after deciding whether the new
document should remain inside this repository or become a separate downstream
author project.

## Personal Books with `otbook`

Choose `otbook` for a long document organized into chapters. It derives from
LaTeX's `book` class; `otscience` derives from `article` and has no native
`\chapter`. The default book settings are 11pt, A4, and one-sided. Standard
book options are forwarded, for example `\documentclass[12pt]{otbook}`.

Start with `examples/otbook/starter_personal_book.tex`. Its structure is:

```latex
\documentclass{otbook}
\title{My Personal Book}
\booksubtitle{Notes and worked examples}
\author{Author Name}
\bookedition{Draft edition}
\date{\today}

\begin{document}
\frontmatter
\hypersetup{pageanchor=false}
\makeotbooktitle
\makeotbookdedication{For the people who made this book possible.} % Optional
\hypersetup{pageanchor=true}
\tableofcontents
\mainmatter
\chapter{Foundations}
\otbookepigraph{A short chapter quotation.}{Attribution}
\begin{chapteroverview}
  Explain what this chapter covers and why it matters.
\end{chapteroverview}
\begin{chaptergoals}
  \item Understand the central idea.
\end{chaptergoals}
\section{Main Idea}
Write the chapter content here.
\appendix
\chapter{Formula Reference}
Write optional appendix content here.
\backmatter
\chapter{Reading Notes}
Write unnumbered reference notes here.
\end{document}
```

Subtitle and edition are optional. Use `\makeotbooktitle` for the OT title
page; the inherited `\maketitle` does not render those extra fields. Put
numbered appendices before `\backmatter`, which disables chapter numbering.

`\makeotbookdedication{...}` creates a dedicated, unnumbered page and is
optional. Keep the title and dedication between the `pageanchor=false` and
`pageanchor=true` lines shown above. Use `\otbookepigraph{<quotation>}{<attribution>}`
after a chapter heading when a brief quotation helps frame it. `chapteroverview`
is a compact opening summary box for prose; use `chaptergoals` when the opening
is a list. Both boxes are breakable, so a long chapter opening can continue
onto the next page.

The class loads `otcore`, `ottheme`, and `otboxes`, plus `otnotation`, `otmath`,
`ottensors`, `otphysics`, `otcoordinates`, `otpractice`, and `otfigures` when
available. Keep the full `src/classes/` and `src/packages/` trees accessible;
copying `otbook.cls` alone is insufficient. Do not load another OT class as a
package. See `docs/PUBLIC_INTERFACES.md` for the book metadata, box interfaces,
package ownership, and current numbering limits.

From the repository root, build with an absolute output directory so the
repository's change-directory setting cannot place it inside `examples/`:

```powershell
$bookOutput = Join-Path (Get-Location).Path 'build/examples/otbook'
latexmk -pdf -halt-on-error "-outdir=$bookOutput" examples/otbook/starter_personal_book.tex
```

The PDF is `build/examples/otbook/starter_personal_book.pdf`; auxiliary files
share that directory. The existing Phase 7 starter runner covers its original
seven documents, so run this book build separately.

For a separate project under `Current-projects/`, copy the source files from
[`templates/otbook-project/`](../templates/otbook-project/README.md), including
its dotfiles and source subfolders, without copying generated `build/` output.
Set the LaTeX-lab path in the copied `.latexmkrc` or through `LATEX_LAB_ROOT`.
From the new project's root, run `latexmk -pdf main.tex`; the PDF lands in
`build/pdf/main.pdf` and auxiliary files in `build/aux/`.

Edit metadata and chapter order in `main.tex`, and content in `chapters/`.
The template README explains figure lookup, cleanup, and the reserved
bibliography folder. Keep LaTeX-lab as the shared styling source. Verify all
three book paths from the repository root with:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_otbook_tests.ps1
```

## Build Commands

Build a single document from the repository root:

```powershell
latexmk -pdf examples\physicsquiz\starter_quiz_bank.tex
```

Clean generated files for one document:

```powershell
latexmk -C examples\physicsquiz\starter_quiz_bank.tex
```

Run the latest physicsquiz guard:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase6f_tests.ps1
```

Run the fast starter guard:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_starter_tests.ps1
```

Run the OT-side guard:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_ot_baseline_tests.ps1
```

## Git Hygiene

Before committing, check:

```powershell
git status --short --branch
git diff --check
```

Commit source, tests, examples, and documentation. Do not commit generated
build files under `build/`, temporary logs, local cache folders, or editor
clutter.

The current known local leftovers are:

* `src/classes/physicsquiz.cls` line-ending noise, with `git diff -w` empty;
* `AGENTS.md`, a local instruction file;
* `examples/physicsquiz/indent.log`; and
* `tests/__pycache__/`.

## GitHub Collaboration Track

Yes, it is worth preparing for GitHub collaboration in Phase 7. The repository
already has useful commit history, tests, examples, and public-interface records.

Before pushing for collaborators, decide:

* repository visibility: private first, then public later if desired;
* branch policy: whether collaborators work from feature branches;
* review policy: whether every change needs a pull request;
* artifact policy: whether PDFs are generated locally only or attached to
  releases;
* issue labels: templates, bugs, documentation, examples, class internals, tests;
* release boundary: whether an author kit is a zip, a GitHub release, or simply
  the repository itself; and
* collaborator setup: MiKTeX package list, build commands, and expected checks.

Recommended first GitHub shape:

* keep `main` protected once collaborators are active;
* use feature branches for phase work;
* require at least the relevant phase runner before merge;
* keep generated build artifacts out of ordinary commits;
* put human-facing setup instructions in `README.md`; and
* track public author guarantees in `docs/PUBLIC_INTERFACES.md`.

Phase 7 should prepare this structure before any serious multi-person editing.
See `docs/GITHUB_WORKFLOW.md#github-collaboration-checklist` for the working checklist.
See `CONTRIBUTING.md` before opening a collaborator pull request.
See `docs/release/RELEASE_PROCESS.md#release-readiness` before preparing a release or author kit.
See `docs/GITHUB_WORKFLOW.md#github-push-checklist` before pushing the repository to GitHub.
See `docs/GITHUB_WORKFLOW.md#collaborator-onboarding-checklist` before inviting or onboarding
first collaborators.
