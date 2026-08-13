# Collaborator Onboarding Checklist

## Purpose

This checklist gives a new collaborator the smallest safe path from GitHub
access to a useful first contribution.

## Access

Recommended first access:

* keep the repository private;
* give trusted active collaborators write access;
* keep admin permissions limited to repository maintainers;
* defer branch protection until the first collaborator workflow is confirmed;
  and
* defer required CI checks until a starter-build GitHub Actions workflow exists.

## First Message to a Collaborator

Send:

* repository URL: `https://github.com/AnatO-my/LaTeX-lab.git`;
* `README.md`;
* `docs/AUTHOR_WORKFLOW.md`;
* `CONTRIBUTING.md`;
* `docs/STARTER_INVENTORY.md`; and
* this checklist.

Ask them to start by cloning the repository and building one starter document.

## First Local Check

From the repository root, run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

A collaborator is ready to edit source when the starter runner passes locally.

## First Contribution Shape

Good first contributions are small and easy to review:

* fix or clarify documentation;
* add a small starter note or example request through an issue;
* improve a starter without changing public class behavior; or
* report a build issue with the exact command and log excerpt.

Avoid first contributions that change class internals, package behavior,
generated artifacts, or large representative examples unless the change has
already been discussed.

## Branch and Pull Request Habit

Use short feature branches, for example:

```powershell
git switch -c docs-onboarding-note
```

Before opening a pull request:

```powershell
git status --short --branch
git diff --check
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

The pull request should say what changed, which command was run, and whether any
generated artifacts were intentionally excluded.

## Do Not Commit

Do not commit:

* `build/`;
* generated PDFs, logs, auxiliary files, or SyncTeX files;
* local editor color/theme changes;
* Python cache folders; or
* local instruction files.

## Escalate Before Editing

Ask before changing:

* `src/classes/`;
* `src/packages/`;
* `docs/PUBLIC_INTERFACES.md`;
* representative course-scale examples; or
* test baselines.
