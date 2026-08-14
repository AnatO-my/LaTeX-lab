# Branch and Pull Request Policy

## Purpose

This policy describes how collaborators should make shared changes after the
first GitHub launch.

It began as a working agreement first. Checkpoint 8I adds
`docs/BRANCH_PROTECTION_CHECKLIST.md`, which records the first protected-`main`
settings after the starter-build workflow passed consistently on `main`.

## Stable Branch

Use `main` as the stable branch.

`main` should contain source that has either:

* passed the relevant local check; or
* been intentionally recorded as a checkpoint with its verification boundary.

Maintainer checkpoint commits may still go directly to `main` until branch
protection is enabled. Collaborator changes should use branches and pull
requests.

## Feature Branches

Use short branch names that describe the outcome:

```text
docs-branch-policy
starter-studentnotes-example
fix-physicsquiz-message
workflow-ci-checklist
```

Prefer one clear outcome per branch. Avoid mixing unrelated class, package,
example, documentation, and workflow changes in a single pull request.

## Pull Requests

Open a pull request for collaborator changes.

Each pull request should state:

* what changed;
* which files or author-facing behavior were touched;
* which commands were run;
* whether generated artifacts were excluded; and
* whether visual PDF review is needed.

Use `.github/PULL_REQUEST_TEMPLATE.md` as the review checklist.

## Required Local Checks

Before opening a pull request, run:

```powershell
git status --short --branch
git diff --check
```

For documentation, starter, workflow, packaging, and onboarding changes, also
run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

For `physicsquiz.cls` behavior changes, run the latest relevant physicsquiz
phase runner and explain why that runner is sufficient.

For OT class or package changes, run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_ot_phase5_tests.ps1
```

## Generated Artifacts

Do not commit ordinary generated outputs:

* `build/`;
* PDFs created by local builds;
* `.aux`, `.log`, `.fls`, `.fdb_latexmk`, `.out`, `.toc`, or SyncTeX files;
* Python cache folders; or
* local editor/theme files.

Generated assets belong in GitHub release assets only when a release checklist
explicitly calls for them.

## Review Expectations

Small documentation and starter changes can be reviewed for clarity, build
commands, and artifact hygiene.

Class, package, public-interface, baseline, and representative-example changes
need stricter review. The pull request should identify the author-facing impact,
the compatibility risk, and the verification command.

## GitHub Settings

Use `docs/BRANCH_PROTECTION_CHECKLIST.md` for the first protected-`main` setup.

The first rule should:

* requiring pull requests before merging into `main`;
* require the `Starter documents` status check to pass;
* require at least one approving review;
* require conversation resolution;
* clear stale approvals after new commits; and
* block force pushes and deletion of `main`.

Stricter settings such as signed commits, linear history, merge queue, full
regression workflows, and removing admin bypass remain later decisions.
