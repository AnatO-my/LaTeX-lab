# Release Source Checks Promotion Checklist

## Purpose

This checklist records when the `Release source checks` GitHub Actions job can
move from optional CI to a required branch-protection check.

Checkpoint 10G adds the workflow. Checkpoint 10H keeps it non-required until the
hosted run history proves that it is stable and useful.

## Current Status

The workflow file is:

```text
.github/workflows/release-source-checks.yml
```

The job name is:

```text
Release source checks
```

Current branch protection should still require only:

```text
Starter documents
```

## What The Workflow Runs

The workflow runs source-level checks only:

```powershell
git diff --check
tests\run_phase10a_release_policy.ps1
tests\run_phase10b_release_notes_template.ps1
tests\run_phase10c_local_release_checklist.ps1
tests\run_phase10d_release_asset_manifest.ps1
tests\run_phase10e_l3build_pilot.ps1
tests\run_phase10f_ci_release_gate_plan.ps1
tests\run_phase10gh_release_source_checks.ps1
tests\run_phase9c_build_recipe_reliability.ps1
```

It does not install MiKTeX, build starter PDFs, run the Phase 5 rendering
baseline, run Phase 6F generated-paper checks, build release assets, or adopt
`l3build`.

## Promotion Criteria

Promote `Release source checks` to a required status check only after:

* it passes on at least two pull requests or workflow dispatches without source
  changes made only to appease hosted CI;
* failures are readable from the GitHub Actions log;
* runtime remains acceptable for ordinary pull requests;
* the `Starter documents` required check remains stable;
* generated outputs remain ignored and are not uploaded as release assets by
  this workflow; and
* the maintainer is comfortable recovering with admin bypass if hosted CI
  changes unexpectedly.

## How To Promote Later

When the criteria are met:

1. Open repository branch protection settings.
2. Edit the `main` branch rule.
3. Keep `Starter documents` required.
4. Add `Release source checks` as a second required status check.
5. Keep force pushes and deletion disabled.
6. Keep admin bypass available until the second check survives normal use.

Do not require this check before it has completed successfully on GitHub.

## Rollback

If the check becomes noisy:

* remove only `Release source checks` from required status checks;
* keep `Starter documents` required;
* fix the workflow on a branch; and
* restore the requirement after the workflow is stable again.

## Phase 10H Boundary

Phase 10H does not change branch protection.

It records the promotion criteria for a future manual GitHub setting change.
