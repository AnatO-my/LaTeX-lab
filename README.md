# LaTeX Lab

Local LaTeX class, package, and document-workflow lab for OT notes, engineering
notes, science notes, vector workbooks, and structured physics quiz papers.

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

Run the latest accepted Phase 6 guard:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase6f_tests.ps1
```

Run the OT-side design-system guard:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_ot_phase5_tests.ps1
```

Generated build outputs belong under `build/` and are not source files.

## Author Workflow

Start with the copyable starter documents in `examples/`, then build from the
repository root so `.latexmkrc` can discover the project-local classes and
packages.

See `docs/AUTHOR_WORKFLOW.md` for document-starting steps, build commands,
collaboration notes, and the Phase 7 GitHub-readiness checklist.

## Collaboration

The repository is suitable for GitHub collaboration once the Phase 7 workflow
docs, starter templates, and repository hygiene checks are in place. Do not
commit generated PDFs, logs, or `build/` outputs unless a checkpoint explicitly
calls for a tracked baseline artifact.

## Status

Phase 6 is complete. Phase 7 opens the local author workflow and distribution
readiness workstream.
