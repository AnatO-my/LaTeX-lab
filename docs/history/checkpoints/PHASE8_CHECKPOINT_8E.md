# Phase 8 Checkpoint 8E - Branch and pull-request policy

## Scope

Checkpoint 8E records the first branch and pull-request policy for GitHub
collaboration.

This checkpoint does not enable GitHub branch protection, required checks,
review enforcement, or hosted CI. It defines the human working agreement to use
before repository settings are tightened.

## Policy

The first collaboration policy is:

* keep `main` as the stable branch;
* make shared edits on short feature branches;
* open pull requests for collaborator changes;
* keep direct pushes to `main` for maintainer-only checkpoint commits until
  branch protection is enabled;
* run `git diff --check` before pull requests;
* run the Phase 7C starter runner for starter, workflow, documentation, and
  packaging changes; and
* explain any broader phase runner used for class or package changes.

## Branch names

Use short branch names that describe the outcome:

```text
docs-branch-policy
starter-studentnotes-example
fix-physicsquiz-message
workflow-ci-checklist
```

## Pull request expectations

Each pull request should include:

* the outcome of the change;
* files or author-facing behavior touched;
* commands run;
* whether generated artifacts were excluded; and
* whether visual PDF review is needed.

## Deferred enforcement

Actual GitHub branch protection should wait until:

* at least one collaborator pull request has been tried; and
* the starter-build GitHub Actions workflow exists and passes.

Until then, the policy is documented and manual.

## Verification

This is a documentation-only checkpoint. The verification points are:

```powershell
git diff --check
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```
