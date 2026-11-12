# Phase 8 Checkpoint 8I - Branch protection

## Scope

Checkpoint 8I records the first protected-`main` branch rule.

This checkpoint prepares the GitHub-side settings that should be applied before
Phase 8 closes. It does not expand hosted CI beyond the starter workflow.

## Preconditions met

The repository has reached the protection point:

* `main` has been pushed to GitHub;
* generated output files and `build/` remain absent from source;
* `.github/workflows/starter-build.yml` exists on `main`;
* the hosted `Starter documents` job passed at commit `f40f051`;
* the hosted download retry was added at commit `e9374af`; and
* commit `e9374af` passed the hosted `Starter documents` job in 5m 9s, with
  total workflow duration 5m 12s and the `starter-pdfs` artifact at 780 KB.

## Branch rule

Use the checklist in:

```text
docs/BRANCH_PROTECTION_CHECKLIST.md
```

The first rule targets:

```text
main
```

It should require:

* pull requests before merging;
* one approving review;
* stale approvals to be dismissed when new commits are pushed;
* conversation resolution before merging;
* status checks before merging;
* branches to be up to date before merging; and
* the `Starter documents` status check.

Force pushes and branch deletion should remain blocked.

## Deferred

The first protection rule should not yet require:

* signed commits;
* linear history;
* merge queue;
* deployments;
* full historical regression workflows; or
* no-admin-bypass enforcement.

These can be reconsidered after the first protected collaborator pull request
has been tried.

## Verification

Local source verification:

```powershell
git diff --check
```

Hosted evidence:

```text
Commit e9374af: Success in 5m 12s.
Starter documents job passed in 5m 9s.
Artifact: starter-pdfs, 780 KB.
```

GitHub branch-protection confirmation:

```text
main
Currently applies to 1 branch
```
