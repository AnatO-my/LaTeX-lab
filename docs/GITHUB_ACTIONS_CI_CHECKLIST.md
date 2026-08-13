# GitHub Actions CI Checklist

## Purpose

This checklist defines when GitHub Actions should be added and what the first CI
workflow should prove.

Checkpoint 8F adds the first workflow at
`.github/workflows/starter-build.yml`. After hosted MiKTeX setup stabilization,
commit `f40f051` passed on `main` and produced the `starter-pdfs` artifact.
The workflow is still not a required branch-protection check until it has passed
consistently.

## 1. Add CI Only After GitHub Push

Checkpoint 8F satisfies the preconditions for adding the first workflow:

* the private GitHub repository exists;
* `main` has been pushed;
* README, issue templates, and pull-request template render correctly;
* the Phase 7C starter runner passes locally; and
* the first collaborator workflow is clear.

## 2. First CI Scope

The first CI workflow is narrow:

* install or provide a TeX environment;
* run `git diff --check`;
* run `tests/run_phase7c_starter_tests.ps1`; and
* upload starter PDFs only as workflow artifacts, not as source files.

The first workflow does not run the full historical regression suites.

## 3. Why Start With Starters

The starter runner is the best first CI target because it proves the author
experience:

* the project-local class and package discovery works;
* all copyable starter documents build;
* generated outputs stay under `build/`; and
* collaborators can trust the starting points before editing larger examples.

## 4. Hosted Environment Risks

Before requiring CI for pull requests, confirm:

* the selected runner has a reliable LaTeX distribution;
* required packages such as `xsim` and `siunitx` are available;
* PowerShell path behaviour is stable;
* hosted package downloads survive transient network timeouts;
* builds do not rely on user-local MiKTeX state;
* generated PDFs land in the expected `build/` paths; and
* the workflow finishes quickly enough to be useful.

## 5. CI Pass Criteria

The first workflow is ready to become a required check only when:

* `git diff --check` passes;
* all Phase 7C starter builds pass;
* no generated outputs are committed;
* logs are available for failed builds; and
* a failed starter build blocks the pull request only after the workflow has
  passed consistently on `main`.

The first pushed run passed in 4m 33s. Later runs exposed hosted MiKTeX
installation and path-discovery issues with Chocolatey. The workflow now uses
MiKTeX's standalone setup utility, installs into `RUNNER_TEMP`, and adds
discovered TeX tool directories to `GITHUB_PATH`. It also updates the current
step's `PATH` before running MiKTeX commands and installs `latexmk` explicitly.
After a later documentation-only push timed out while downloading the setup
zip, the workflow added bounded retry and backoff around that download.

GitHub also reported a Node.js 20 deprecation warning for `actions/checkout@v4`
and `actions/upload-artifact@v4` being forced to run on Node.js 24. Treat that
as a watch item for future action-version updates, not as a failed starter-build
result.

Final stabilized run:

```text
Commit f40f051: Success in 4m 43s.
Starter documents job passed in 4m 40s.
Artifact: starter-pdfs, 780 KB.
```

## 6. What Stays Local For Now

Keep these local until CI is stable:

* full Phase 4 physicsquiz regression chain;
* full Phase 5 OT rendering baseline checks;
* visual PDF review;
* release PDF preparation; and
* author-kit zip creation.

## 7. Later CI Expansion

After starter CI is stable, consider adding:

* a scheduled full regression job;
* manual workflow dispatch for release PDF previews;
* artifact upload for starter PDFs;
* branch protection requiring starter CI; and
* separate jobs for physicsquiz and OT-side regression suites.

Each expansion should be a separate checkpoint because hosted LaTeX behaviour
can differ from the local MiKTeX environment.
