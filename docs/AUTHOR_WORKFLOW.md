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
| Vector workbook module | `examples/vector-workbook/starter_module.tex` |

See `docs/STARTER_INVENTORY.md` for the distinction between true starters and
representative examples. Larger course-shaped examples remain available when
you want to study a finished document rather than start a small one.

Copy a starter into a new project folder only after deciding whether the new
document should remain inside this repository or become a separate downstream
author project.

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
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

Run the OT-side guard:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_ot_phase5_tests.ps1
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
See `docs/GITHUB_COLLABORATION.md` for the working checklist.
See `CONTRIBUTING.md` before opening a collaborator pull request.
