# GitHub Push Checklist

## Purpose

This checklist is the final local runbook before the repository is pushed for
collaborators. It assumes the first GitHub repository is private and that the
source repository is the first shareable form.

## 1. Local Readiness

Before creating or pushing to a remote:

* confirm the working branch is `main`;
* confirm all intended Phase 7 checkpoints are committed;
* leave local-only files untracked or ignored;
* keep generated outputs out of source commits;
* run `git diff --check`; and
* run the starter check:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

Expected known local leftovers before push:

* `src/classes/physicsquiz.cls` line-ending-only working-tree noise;
* `AGENTS.md`;
* `examples/physicsquiz/indent.log`; and
* `tests/__pycache__/`.

Do not stage those unless a later checkpoint explicitly changes the policy.

## 2. Create the GitHub Repository

Recommended first settings:

* visibility: private;
* default branch: `main`;
* initialize with README: no, because the local repository already has one;
* add `.gitignore`: no, because the local repository already has one;
* add license: decide separately before public release.

## 3. Add the Remote

After creating the empty GitHub repository, add the remote from the local
repository root:

```powershell
git remote add origin <github-repository-url>
git remote -v
```

If a remote already exists, inspect it before changing it:

```powershell
git remote -v
```

## 4. Push `main`

Push the current branch:

```powershell
git push -u origin main
```

If GitHub rejects the push because the remote is not empty, stop and inspect the
remote before merging or force-pushing.

## 5. Inspect GitHub After Push

In GitHub, confirm:

* `README.md` renders on the repository landing page;
* `CONTRIBUTING.md` is visible;
* `.github/PULL_REQUEST_TEMPLATE.md` appears when opening a test pull request;
* issue templates appear for bug reports, starter/example requests, and workflow
  questions;
* `docs/AUTHOR_WORKFLOW.md` and `docs/RELEASE_READINESS.md` render correctly;
* generated `build/` files are absent; and
* starter files are present under `examples/`.

## 6. First Collaborator Instructions

Send collaborators:

* the repository URL;
* `README.md`;
* `docs/AUTHOR_WORKFLOW.md`;
* `CONTRIBUTING.md`;
* `docs/STARTER_INVENTORY.md`; and
* the starter verification command.

Ask them to work from feature branches and open pull requests for shared
changes.

## 7. Optional Branch Protection

After the first collaborator has access, consider enabling:

* pull requests before merging into `main`;
* no direct pushes to `main`;
* required status checks later, once CI exists; and
* branch deletion after merge.

Do not require CI checks until a GitHub Actions workflow exists and has passed
on the repository.
