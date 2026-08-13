# Phase 8 Checkpoint 8F - Starter-build GitHub Actions

## Scope

Checkpoint 8F adds the first hosted GitHub Actions workflow.

The workflow is intentionally narrow. It runs the starter confidence path, not
the full historical regression suites.

## Added workflow

The workflow is:

```text
.github/workflows/starter-build.yml
```

It runs on:

* pushes to `main`;
* pull requests targeting `main`; and
* manual `workflow_dispatch`.

## Hosted checks

The workflow:

* checks out the source;
* installs MiKTeX on `windows-latest`;
* enables MiKTeX package installation;
* runs `git diff --check`;
* runs `tests\run_phase7c_starter_tests.ps1`; and
* uploads starter PDFs as workflow artifacts.

Starter PDFs remain artifacts. They are not committed as source.

## Deferred

Checkpoint 8F does not:

* enable branch protection;
* require the workflow before merging;
* run the full Phase 4 physicsquiz regression chain;
* run the full Phase 5 OT rendering baseline guard;
* prepare release PDFs; or
* prepare an author kit.

The workflow should pass on `main` before it becomes a required branch
protection check.

## Verification

Local verification before committing:

```powershell
git diff --check
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

Hosted verification happens after the workflow is pushed to GitHub.
