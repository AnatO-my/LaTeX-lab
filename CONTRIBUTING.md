# Contributing

## Working Model

Start from a feature branch and open a pull request before merging into `main`.
Keep commits source-focused: class files, package files, examples, tests, and
documentation are source; generated PDFs, logs, auxiliaries, and `build/` output
are not.

## Before You Edit

Read the relevant guide:

* `README.md` for the repository overview;
* `docs/AUTHOR_WORKFLOW.md` for local author setup;
* `docs/STARTER_INVENTORY.md` for copyable starter documents;
* `docs/PUBLIC_INTERFACES.md` before changing author-facing commands; and
* `docs/GITHUB_COLLABORATION.md` for the collaboration policy; and
* `docs/RELEASE_READINESS.md` before preparing release assets.

## Branches

Use short branch names that describe the work:

```text
phase7-collaboration-packaging
starter-studentnotes-example
fix-physicsquiz-selection-message
docs-author-workflow
```

## Checks

For starter or workflow changes, run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
git diff --check
```

For `physicsquiz.cls` behaviour changes, run the latest relevant physicsquiz
phase runner and explain why that runner is sufficient.

For OT class or package changes, run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_ot_phase5_tests.ps1
```

## Pull Requests

Each pull request should state:

* what changed;
* which public interface changed, if any;
* which commands were run;
* whether generated artifacts were excluded; and
* whether a visual PDF review is needed.

## Generated Files

Do not commit ordinary build outputs. Keep these out of source commits:

* `build/`
* `*.aux`
* `*.log`
* `*.fdb_latexmk`
* `*.fls`
* `*.synctex.gz`
* Python caches

Tracked historical PDFs and logs are exceptions from earlier baseline phases.
Do not add new generated artifacts unless a checkpoint explicitly calls for a
baseline or release artifact.
