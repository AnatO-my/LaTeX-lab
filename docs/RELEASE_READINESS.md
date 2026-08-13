# Release Readiness

## Purpose

This guide defines what is ready to share when the repository is pushed to
GitHub or packaged for collaborators. It keeps the first release source-focused
and avoids treating generated files as ordinary source.

## Recommended First Release Shape

Use a private GitHub repository first. The first collaborator-ready release is
the repository itself, not a separate zip.

The repository should include:

* source classes in `src/classes/`;
* source packages in `src/packages/`;
* copyable starters in `examples/`;
* representative examples for comparison;
* `README.md`;
* `CONTRIBUTING.md`;
* `docs/AUTHOR_WORKFLOW.md`;
* `docs/STARTER_INVENTORY.md`;
* `docs/GITHUB_COLLABORATION.md`;
* `docs/PUBLIC_INTERFACES.md`; and
* local verification runners under `tests/`.

Do not include new generated PDFs, logs, auxiliary files, or `build/` output in
ordinary source commits.

## Author Kit Boundary

An author kit can be produced later as a GitHub release asset, but it should be
derived from source rather than maintained as another hand-edited copy.
Use `docs/AUTHOR_KIT_BUILD_CHECKLIST.md` when preparing the kit.
The current local source-derived kit is recorded in `docs/AUTHOR_KIT_AUDIT.md`.

If an author kit is prepared, include:

* `README.md`;
* `CONTRIBUTING.md`;
* `.latexmkrc`;
* `docs/AUTHOR_WORKFLOW.md`;
* `docs/STARTER_INVENTORY.md`;
* `docs/PUBLIC_INTERFACES.md`;
* `src/classes/`;
* `src/packages/`;
* `examples/physicsquiz/starter_quiz_bank.tex`;
* `examples/physicsquiz/starter_versioned_quiz.tex`;
* `examples/studentnotes/starter_notes.tex`;
* `examples/otengineering/starter_engineering_notes.tex`;
* `examples/otscience/starter_science_notes.tex`;
* `examples/vector-workbook/starter_module.tex`;
* `examples/vector-workbook/starter_combined_workbook.tex`;
* `examples/vector-workbook/00_common_setup.tex`; and
* `tests/run_phase7c_starter_tests.ps1`.

Do not include:

* `build/`;
* `tests/__pycache__/`;
* generated `.aux`, `.log`, `.fls`, `.fdb_latexmk`, `.out`, `.toc`, or
  `.synctex.gz` files;
* local editor settings that are not already part of the project workflow; or
* exploratory files not approved for source control.

## Release PDFs

Release PDFs are optional. They are useful when a collaborator needs to preview
the expected visual result without building locally, but they should be attached
to a GitHub release rather than committed as normal source files.
Use `docs/RELEASE_PDF_CHECKLIST.md` before creating or attaching preview PDFs.
The current local preview set is recorded in
`docs/RELEASE_PREVIEW_PDF_AUDIT.md`.

A first PDF preview set would be:

* starter quiz bank;
* starter versioned quiz;
* starter student notes;
* starter engineering notes;
* starter science notes; and
* starter workbook module; and
* starter combined workbook.

## Pre-Push Checklist

Before pushing for collaborators:

* `git status --short --branch` shows only intentional source changes;
* `git diff --check` passes;
* `tests/run_phase7c_starter_tests.ps1` passes;
* generated build files are excluded;
* the README points to the author workflow and contributing guide;
* issue and pull-request templates are present; and
* any public-interface change is recorded in `docs/PUBLIC_INTERFACES.md`.

Use `docs/GITHUB_PUSH_CHECKLIST.md` for the step-by-step remote creation and
push runbook.

## Starter Automation

Checkpoint 8F adds the first GitHub Actions workflow for starter builds. The
first GitHub push did not depend on CI, and branch protection should still wait
until the starter-build workflow has passed consistently on `main`.
Use `docs/GITHUB_ACTIONS_CI_CHECKLIST.md` before expanding hosted checks.

Hosted CI starts with the starter runner before attempting the full historical
regression suites.
