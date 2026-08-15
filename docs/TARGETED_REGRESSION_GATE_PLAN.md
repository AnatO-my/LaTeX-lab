# Targeted Regression Gate Plan

## Purpose

This plan defines how broader regression checks should enter hosted CI without
making ordinary pull requests slow or hard to diagnose.

The current required check remains:

```text
Starter documents
```

The current non-required source check is:

```text
Release source checks
```

Targeted regression checks are the next wider layer. They should begin as manual
or scheduled checks before they become pull-request requirements.

## Candidate Checks

Start with the smallest high-value candidates:

| Candidate | Command | Why it matters | First hosted mode |
| --- | --- | --- | --- |
| PhysicsQuiz versioned-paper review | `tests\run_phase6f_tests.ps1` | catches versioned-paper selection and review regressions | manual dispatch |
| OT rendering baseline | `tests\run_ot_phase5_tests.ps1` | catches class/package rendering drift | manual dispatch or scheduled |

These checks are intentionally separate from `Release source checks` because
they may need MiKTeX package installation, generated build output, and more
careful log review.

## Hosted Workflow Shape

A future workflow can be named:

```text
Targeted Regression Checks
```

Recommended triggers:

```yaml
workflow_dispatch:
schedule:
```

Do not run the targeted regression workflow on every pull request until it has
proven stable on GitHub.

## Pass Criteria

Before promoting any targeted regression job:

* it passes locally in the normal MiKTeX PowerShell environment;
* it passes on GitHub at least twice;
* missing hosted MiKTeX packages are installed explicitly;
* logs point clearly to the failing source or baseline;
* generated files remain under ignored `build/` paths or workflow artifacts; and
* the job runtime is acceptable for the chosen trigger.

## Failure Handling

When a targeted regression job fails:

* do not patch generated PDFs or logs;
* inspect the source change, baseline record, or hosted MiKTeX package setup;
* keep failures separate from starter failures; and
* update the checkpoint record before changing branch protection.

## Branch Protection Boundary

Do not add targeted regression checks to branch protection yet.

The first protected checks should remain:

```text
Starter documents
```

and, only after promotion:

```text
Release source checks
```

Targeted regression checks should become required only after manual or scheduled
hosted runs are stable and their failures are easy to interpret.

## Phase 10I Boundary

Phase 10I creates no targeted regression workflow, required status check,
baseline update, generated PDF, release asset, tag, version bump, or `l3build`
adoption.

The next implementation checkpoint can add a manual `Targeted Regression
Checks` workflow after this plan is reviewed.
