# Phase 10 Checkpoints 10I and 10J - Targeted regression and release candidate

## Summary

Checkpoints 10I and 10J add targeted regression planning and a release-candidate dry run.

Checkpoint 10I records how broader regression checks should enter hosted CI
without becoming required too early. Checkpoint 10J records the first
source-only release-candidate rehearsal.

These checkpoints do not create a targeted-regression workflow, release tag,
GitHub release, generated asset, class/package version bump, branch-protection
change, or `l3build` adoption.

Phase 10I/J adds:

```text
docs/TARGETED_REGRESSION_GATE_PLAN.md
docs/RELEASE_CANDIDATE_DRY_RUN.md
tests/run_phase10ij_release_candidate.ps1
PHASE10_CHECKPOINT_10I_10J.md
```

## Targeted Regression Plan

The first targeted regression candidates are:

* `tests\run_phase6f_tests.ps1`;
* `tests\run_ot_phase5_tests.ps1`.

They remain manual or scheduled candidates. They should not become protected
pull-request requirements until hosted runs are stable and failures are easy to
diagnose.

## Release Candidate Dry Run

The dry-run label is:

```text
v0.1.0-rc-dry-run
```

It is not a Git tag. It is a rehearsal label for checking release notes, source
guards, CI gates, and the release-asset manifest before a real release.

## Verification

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase10ij_release_candidate.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase10gh_release_source_checks.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase9c_build_recipe_reliability.ps1
```

The runner writes ignored reports under:

```text
build/phase10ij-release-candidate/
```

Expected result:

```text
All Phase 10I/J release candidate checks passed with 0 warning(s) and 1 note(s).
```

The guard checks 11 required files and 17 required markers.

The cross-checks also passed:

* Phase 10G/H release-source checks: 0 warnings and 0 failures;
* Phase 9C build-recipe reliability: 31 of 31 PowerShell runners parsed, with 0
  findings and 0 failures.

## Decision

The next step is to let the current pull request prove `Release source checks`
on GitHub. After that, Phase 10 can either observe another hosted run or perform
the source-only release-candidate dry run.
