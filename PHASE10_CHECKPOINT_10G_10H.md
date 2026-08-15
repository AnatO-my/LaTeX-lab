# Phase 10 Checkpoints 10G and 10H - Release source checks workflow

## Summary

Checkpoints 10G and 10H add the non-required Release source checks workflow and
its promotion checklist.

Checkpoint 10G adds a hosted GitHub Actions workflow for source-level release
guards. Checkpoint 10H records when that workflow may later become a required
branch-protection check.

These checkpoints do not change branch protection.

Phase 10G/H adds:

```text
.github/workflows/release-source-checks.yml
docs/RELEASE_SOURCE_CHECKS_PROMOTION.md
tests/run_phase10gh_release_source_checks.ps1
PHASE10_CHECKPOINT_10G_10H.md
```

## Workflow Scope

The new workflow job is:

```text
Release source checks
```

It runs source-level checks:

* `git diff --check`;
* Phase 10A release policy guard;
* Phase 10B release-notes template guard;
* Phase 10C local release checklist guard;
* Phase 10D release-asset manifest guard;
* Phase 10E `l3build` pilot guard;
* Phase 10F CI release-gate plan guard;
* Phase 10G/H release-source workflow guard; and
* Phase 9C build-recipe reliability guard.

It does not install MiKTeX, build starter PDFs, upload artifacts, run full
regression suites, publish release assets, or adopt `l3build`.

## Promotion Boundary

The current required branch-protection check remains:

```text
Starter documents
```

`Release source checks` should become required only after it passes on GitHub at
least twice and its failures are clear enough for normal pull-request review.

## Verification

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase10gh_release_source_checks.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase10f_ci_release_gate_plan.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase9c_build_recipe_reliability.ps1
```

The runner writes ignored reports under:

```text
build/phase10gh-release-source-checks/
```

Expected result:

```text
All Phase 10G/H release source checks passed with 0 warning(s) and 1 note(s).
```

The guard checks 10 required files and 18 required markers.

The cross-checks also passed:

* Phase 10F CI release-gate plan: 1 expected warning and 0 failures;
* full local equivalent of `Release source checks`: all Phase 10 source guards
  and Phase 9C passed from the committed source state;
* Phase 9C build-recipe reliability: 30 of 30 PowerShell runners parsed, with 0
  findings and 0 failures.

## Decision

The next step is to open a pull request and let GitHub prove the new
non-required `Release source checks` job. Do not add it to branch protection
until the hosted run history is stable.
