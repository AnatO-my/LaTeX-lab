# Phase 7 Checkpoint 7I - GitHub Actions CI Checklist

## Scope

Checkpoint 7I records when and how GitHub Actions should be introduced. It does
not add a workflow file, require CI, or change local build behaviour.

## Added

* `docs/GITHUB_ACTIONS_CI_CHECKLIST.md`
* `PHASE7_CHECKPOINT_7I.md`

## Outcome

The CI boundary is now explicit:

* add CI only after the repository is pushed and inspected on GitHub;
* start with `git diff --check` and the Phase 7C starter runner;
* upload PDFs only as workflow artifacts;
* keep full regression suites and visual review local until CI is stable; and
* expand hosted checks one checkpoint at a time.

## Verification

This checkpoint is documentation-only. Verification:

```powershell
git diff --check
git status --short --branch
```
