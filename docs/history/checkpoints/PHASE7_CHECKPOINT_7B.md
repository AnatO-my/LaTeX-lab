# Phase 7 Checkpoint 7B - Starter inventory and GitHub checklist

## Scope

Checkpoint 7B inventories the current starter/example surface and turns the
GitHub collaboration question into an actionable checklist.

This checkpoint is documentation-only. It does not change LaTeX class, package,
example, or test behaviour.

## Outcome

7B adds:

* `docs/STARTER_INVENTORY.md`, separating true starters from representative
  examples and identifying the missing starter set.
* `docs/GITHUB_COLLABORATION.md`, recording the recommended private-first
  GitHub setup, branch/review defaults, artifact policy, labels, and pull
  request checklist.

It also corrects the author workflow guide to point to
`examples/physicsquiz/PHY104_structured_revision.tex`, which is the actual
structured PHY104 example in the repository.

## Decision

Phase 7 should not pretend large representative examples are clean templates.
The next checkpoint should add smaller starter files for student notes,
engineering notes, science notes, versioned quizzes, and vector-workbook modules,
then verify them with a fast starter runner.

## Verification

Run:

```powershell
git diff --check
git status --short --branch
```
