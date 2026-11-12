# Phase 7 Checkpoint 7D - Collaboration Packaging

## Scope

Checkpoint 7D prepares the repository for private-first GitHub collaboration.
It does not push to GitHub, add automation, or change class/package behaviour.

## Added

* `CONTRIBUTING.md`
* `.github/PULL_REQUEST_TEMPLATE.md`
* `.github/ISSUE_TEMPLATE/bug_report.md`
* `.github/ISSUE_TEMPLATE/starter_request.md`
* `.github/ISSUE_TEMPLATE/workflow_question.md`
* `.github/ISSUE_TEMPLATE/config.yml`

## Outcome

Collaborators now have a source-controlled contribution path:

* read the README and author workflow guide;
* work from a feature branch;
* keep generated outputs out of ordinary commits;
* run the relevant local check before opening a pull request; and
* use issue templates for bugs, starter/example requests, and workflow
  questions.

## Verification

This checkpoint is documentation and repository metadata only. Verification:

```powershell
git diff --check
git status --short --branch
```
