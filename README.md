# LaTeX Lab

Local LaTeX class, package, and document-workflow lab for OT notes, engineering
notes, science notes, personal books, vector workbooks, and structured physics
quiz papers.

The project is currently moving from internal refactoring into author workflow
and collaboration readiness. The working source lives under `src/`, examples
live under `examples/`, tests live under `tests/`, and public interface rules
are recorded in `docs/PUBLIC_INTERFACES.md`.

## Requirements

* Windows with MiKTeX
* `latexmk`
* pdfLaTeX
* Python as `py -3` or `python` for checker scripts
* MiKTeX packages used by the examples, especially `xsim` and `siunitx`

## Quick Start

Build a document from the repository root:

```powershell
latexmk -pdf examples\physicsquiz\starter_quiz_bank.tex
```

Run the fast starter check:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

Run the latest accepted Phase 6 guard:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase6f_tests.ps1
```

Run the OT-side design-system guard:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_ot_phase5_tests.ps1
```

Generated build outputs belong under `build/` and are not source files.

Historical checkpoint records live in [docs/history/checkpoints/](docs/history/checkpoints/).

## Author Workflow

Start with the copyable starter documents in `examples/`, then build from the
repository root so `.latexmkrc` can discover the project-local classes and
packages. Phase 7 currently provides starters for quiz banks, versioned quiz
papers, student notes, engineering notebooks, science notes, and workbook
modules, including a combined workbook root. The `otbook` class adds a
[personal-book starter](examples/otbook/starter_personal_book.tex) with native
chapters, front matter, main matter, back matter, and OT semantic boxes.

For a chaptered book, use `\documentclass{otbook}`; `otscience` remains an
article-based class for science notes. See the
[book workflow](docs/AUTHOR_WORKFLOW.md#personal-books-with-otbook) for metadata,
document structure, and a build command that writes under `build/`.

For a new book outside this repository, copy
[`templates/otbook-project/`](templates/otbook-project/README.md). It includes
chapter, figure, and bibliography folders plus a `.latexmkrc` pointer to
LaTeX-lab, with PDFs under `build/pdf/` and auxiliary files under `build/aux/`.

## Documentation Map

| Need | Document |
| --- | --- |
| Start a document, build commands | [`docs/AUTHOR_WORKFLOW.md`](docs/AUTHOR_WORKFLOW.md) |
| Which starter to copy | [`docs/STARTER_INVENTORY.md`](docs/STARTER_INVENTORY.md) |
| Public commands, environments, options | [`docs/PUBLIC_INTERFACES.md`](docs/PUBLIC_INTERFACES.md) (contracts) and [`docs/INTERFACE_INVENTORY.md`](docs/INTERFACE_INVENTORY.md) (generated list) |
| Upgrading after the 2026 refactor | [`docs/MIGRATION_GUIDE.md`](docs/MIGRATION_GUIDE.md) |
| Adding or changing a class or package | [`docs/PACKAGE_AUTHOR_CHECKLIST.md`](docs/PACKAGE_AUTHOR_CHECKLIST.md) |
| Architecture plan, audit and refactor release notes | [`docs/architecture/`](docs/architecture/) |
| Versioning, release checks, CI gates, `l3build` | [`docs/release/RELEASE_PROCESS.md`](docs/release/RELEASE_PROCESS.md), templates in [`docs/release/templates/`](docs/release/templates/) |
| Author kit (contents, build, audit) | [`docs/AUTHOR_KIT.md`](docs/AUTHOR_KIT.md); build with `scripts/new-author-kit.ps1` |
| GitHub collaboration, branches, protection, CI | [`docs/GITHUB_WORKFLOW.md`](docs/GITHUB_WORKFLOW.md) and `CONTRIBUTING.md` |
| Generated-file rules | [`docs/GENERATED_FILE_HYGIENE.md`](docs/GENERATED_FILE_HYGIENE.md) |
| Running the tests | [`tests/README.md`](tests/README.md) |
| Skill library | [`skills/README.md`](skills/README.md) |
| Completed audits, phase checkpoints, project log | [`docs/history/`](docs/history/) |

## Collaboration

The repository is suitable for private-first GitHub collaboration. Read
`CONTRIBUTING.md` before opening a pull request, and use the GitHub issue
templates for bug reports, starter/example requests, and workflow questions.

Do not commit generated PDFs, logs, or `build/` outputs unless a checkpoint
explicitly calls for a tracked baseline artifact.

## Status

Phase 10 is open as the testing and releases phase. Checkpoints 10A through 10H
define release policy, release-note structure, local release readiness, the
optional release-asset manifest, the `l3build` pilot boundary, and the staged CI
release-gate plan without changing class/package versions. Checkpoints 10G and
10H add a non-required `Release source checks` workflow and a promotion
checklist. Checkpoints 10I and 10J add targeted-regression planning and a
source-only release-candidate dry run.
