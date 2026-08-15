# Phase 10 Checkpoint 10F - CI release-gate plan

## Summary

Checkpoint 10F adds a broader CI release-gate plan.

The checkpoint documents how hosted CI should grow from the current required
starter check into later release-source, targeted-regression, and release-asset
gates. It does not create a new GitHub Actions workflow or add a new required
branch-protection check.

Phase 10F adds:

```text
docs/CI_RELEASE_GATE_PLAN.md
tests/run_phase10f_ci_release_gate_plan.ps1
PHASE10_CHECKPOINT_10F.md
```

It also links the plan from the README, local release checklist, and GitHub
Actions CI checklist.

## Gate Levels

The plan defines four levels:

* Level 1: current required `Starter documents` gate;
* Level 2: planned `Release source checks` gate;
* Level 3: planned targeted regression gate; and
* Level 4: deferred release asset gate.

The next implementation checkpoint should start with Level 2 as a non-required
workflow. Branch protection should not require it until it has passed on GitHub
repeatedly.

## Verification

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase10f_ci_release_gate_plan.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase10e_l3build_pilot.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase9c_build_recipe_reliability.ps1
```

The runner writes ignored reports under:

```text
build/phase10f-ci-release-gate-plan/
```

Expected result:

```text
All Phase 10F CI release-gate plan checks passed with 0 warning(s) and 1 note(s).
```

The guard checks 9 required files and 19 required markers.

The cross-checks also passed:

* Phase 10E `l3build` pilot: 1 expected warning and 0 failures;
* Phase 9C build-recipe reliability: 29 of 29 PowerShell runners parsed, with 0
  findings and 0 failures.

## Decision

Phase 10F keeps the current branch-protection requirement unchanged:

```text
Starter documents
```

The next Phase 10 checkpoint can add a non-required `Release source checks`
workflow and let GitHub prove it before it becomes a protected requirement.
