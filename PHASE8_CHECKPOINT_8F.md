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

Initial hosted verification after push:

```text
Starter documents passed in 4m 33s.
```

GitHub reported one warning: Node.js 20 is deprecated for
`actions/checkout@v4` and `actions/upload-artifact@v4`, and GitHub forced those
actions to run on Node.js 24. This warning does not block the starter-build
workflow, but future action-version updates should watch it.

Later hosted verification found a path-discovery failure:

```text
MiKTeX binary directory not found: C:\Program Files\MiKTeX\miktex\bin\x64
```

The workflow was updated to discover MiKTeX from several likely Chocolatey and
Program Files paths instead of relying on one hardcoded directory.

The next hosted run showed that Chocolatey did not leave any usable MiKTeX-like
CLI directory on the runner. The workflow was then changed to use MiKTeX's
standalone setup utility, install into `RUNNER_TEMP`, and add discovered TeX
tool directories to `GITHUB_PATH`.

The standalone setup step also updates the current step's `PATH` before running
MiKTeX commands, then installs `latexmk` explicitly.

Final hosted verification after the standalone setup fix:

```text
Commit f40f051: Success in 4m 43s.
Starter documents job passed in 4m 40s.
Artifact: starter-pdfs, 780 KB.
```

The remaining annotation is the known Node.js 20 deprecation warning for the
current GitHub action versions.

A later documentation-only push reached the same install step but timed out
while downloading `miktexsetup-x64.zip` from `miktex.org`. The workflow now uses
bounded retry and backoff for that setup download before extracting the
standalone installer.

Hosted verification after the download retry:

```text
Commit e9374af: Success in 5m 12s.
Starter documents job passed in 5m 9s.
Artifact: starter-pdfs, 780 KB.
```
