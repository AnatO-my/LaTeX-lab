# Phase 8 Checkpoint 8D - Collaborator onboarding

## Scope

Checkpoint 8D records the first collaborator-onboarding plan after the GitHub
repository has been pushed and inspected.

This checkpoint does not invite named collaborators, change repository
permissions, add branch protection, or add hosted CI. It defines the manual
onboarding packet and the first-work expectations for collaborators.

## Onboarding packet

Send each collaborator:

* the repository URL: `https://github.com/AnatO-my/LaTeX-lab.git`;
* `README.md`;
* `docs/AUTHOR_WORKFLOW.md`;
* `CONTRIBUTING.md`;
* `docs/STARTER_INVENTORY.md`;
* `docs/COLLABORATOR_ONBOARDING_CHECKLIST.md`; and
* the starter verification command:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

## First collaborator expectations

Collaborators should:

* clone the repository;
* confirm they can build at least one starter;
* run the starter verification command before proposing source changes;
* keep generated PDFs, logs, auxiliary files, and `build/` outputs out of
  commits;
* work from short feature branches; and
* open pull requests for shared changes once more than one person is editing.

## Role boundary

The first safe default is repository write access only for trusted active
collaborators. Admin access, branch protection, required checks, and release
permissions remain separate Phase 8 decisions.

## Verification

This is a documentation-only checkpoint. The verification point is:

```powershell
git diff --check
```
