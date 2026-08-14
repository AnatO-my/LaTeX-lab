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

## Author Workflow

Start with the copyable starter documents in `examples/`, then build from the
repository root so `.latexmkrc` can discover the project-local classes and
packages. Phase 7 currently provides starters for quiz banks, versioned quiz
papers, student notes, engineering notebooks, science notes, and workbook
modules, including a combined workbook root.

See `docs/AUTHOR_WORKFLOW.md` for document-starting steps, build commands,
collaboration notes, and the Phase 7 GitHub-readiness checklist.
See `docs/RELEASE_READINESS.md` for the first shareable repository boundary and
future author-kit rules.
See `docs/AUTHOR_KIT_BUILD_CHECKLIST.md` before creating any author-kit zip.
See `docs/AUTHOR_KIT_AUDIT.md` for the current local source-derived author kit.
See `docs/RELEASE_PDF_CHECKLIST.md` before attaching preview PDFs to a release.
See `docs/RELEASE_PREVIEW_PDF_AUDIT.md` for the current local preview PDF set.
See `docs/GITHUB_PUSH_CHECKLIST.md` before adding a GitHub remote or pushing
`main`.
See `docs/GITHUB_LAUNCH_AUDIT.md` for the current local pre-push audit.
See `docs/COLLABORATOR_ONBOARDING_CHECKLIST.md` before inviting first
collaborators.
See `docs/BRANCH_AND_PR_POLICY.md` for the branch and pull-request working
agreement.
See `docs/BRANCH_PROTECTION_CHECKLIST.md` for the first protected-`main`
settings.
See `docs/GITHUB_ACTIONS_CI_CHECKLIST.md` for the starter-build GitHub Actions
boundary.
See `docs/BUILD_MEASUREMENT_BASELINE.md` for Phase 9 build timing and generated
file measurement.
See `docs/GENERATED_FILE_HYGIENE.md` for Phase 9 generated-file hygiene and
cleanup boundaries.
See `docs/BUILD_RECIPE_RELIABILITY.md` for Phase 9 build-script and hosted
workflow reliability checks.

## Collaboration

The repository is suitable for private-first GitHub collaboration. Read
`CONTRIBUTING.md` before opening a pull request, and use the GitHub issue
templates for bug reports, starter/example requests, and workflow questions.

Do not commit generated PDFs, logs, or `build/` outputs unless a checkpoint
explicitly calls for a tracked baseline artifact.

## Status

Phase 9 is open as the automation and performance phase. Phase 8 closed the
private GitHub launch, starter-build CI, collaborator onboarding docs,
release-preview and author-kit audits, and protected-`main` branch settings.
