# GitHub Collaboration Checklist

## Purpose

This checklist captures the decisions needed before pushing the repository for
collaborators.

## Recommended First Setup

Start with a private GitHub repository. Invite collaborators after the README,
author workflow guide, starter inventory, and starter build checks are present.

Use:

* `main` as the stable branch;
* feature branches for changes;
* pull requests once more than one person is editing;
* source-only commits by default;
* generated PDFs and logs excluded from ordinary commits; and
* `README.md`, `docs/AUTHOR_WORKFLOW.md`, and `docs/PUBLIC_INTERFACES.md` as
  the onboarding and contract documents.

## Decisions Before Push

| Decision | Recommended default |
| --- | --- |
| Visibility | Private first. |
| Default branch | `main`. |
| Branch naming | Use short feature branches, for example `phase7-starters`. |
| Review style | Pull requests for collaborator changes. |
| Required checks | Relevant phase runner plus `git diff --check`. |
| Build artifacts | Keep `build/`, logs, and generated auxiliaries out of commits. |
| PDFs | Generate locally; attach release PDFs only when intentionally publishing. |
| Issues | Use labels for docs, starters, tests, examples, classes, packages, and workflow. |
| Releases | Use the source repository first; prepare author-kit assets later from a manifest. |

## Suggested Labels

* `docs`
* `starter`
* `workflow`
* `physicsquiz`
* `studentnotes`
* `otscience`
* `otengineering`
* `vector-workbook`
* `tests`
* `packaging`
* `question`

## Pull Request Checklist

Each collaborator pull request should say:

* what changed;
* which public interface is affected, if any;
* which command was run;
* whether generated artifacts were intentionally excluded; and
* whether the change needs visual review.

Checkpoint 7D adds `.github/PULL_REQUEST_TEMPLATE.md`, so GitHub will present
this checklist automatically when a collaborator opens a pull request.

## Issue Templates

Checkpoint 7D adds issue templates for:

* bug reports;
* starter or example requests; and
* workflow questions.

Use these to keep support requests tied to an outcome, a command, and the file
or starter involved.

## Not Yet Decided

These can wait until after the initial collaboration and release boundary:

* whether to add GitHub Actions for LaTeX builds;
* whether to mirror docs into a hosted site; and
* whether to support a downstream project template separate from this lab repo.

## Release Boundary

Checkpoint 7E records `docs/RELEASE_READINESS.md` and
`docs/AUTHOR_KIT_MANIFEST.md`. The first shareable form should be the source
repository itself. A future author kit should be generated from the manifest,
and optional preview PDFs should be attached to releases rather than committed
as ordinary source.

Checkpoint 7G adds `docs/AUTHOR_KIT_BUILD_CHECKLIST.md`, which describes how to
assemble and verify that future kit without maintaining a second copy.
Checkpoint 7H adds `docs/RELEASE_PDF_CHECKLIST.md`, which describes how optional
preview PDFs should be generated, reviewed, and attached to releases.
Checkpoint 7I adds `docs/GITHUB_ACTIONS_CI_CHECKLIST.md`, which describes when
hosted CI should be added and why it should start with the starter runner.
Checkpoint 7J adds `docs/COMBINED_WORKBOOK_STARTER_CHECKLIST.md`, which records
the decision to support both standalone workbook modules and a combined workbook
root.

## Push Checklist

Checkpoint 7F records `docs/GITHUB_PUSH_CHECKLIST.md`. Use it when the project
is ready to create the private GitHub repository, add the `origin` remote, push
`main`, and inspect the rendered GitHub templates.

## Collaborator Onboarding

Checkpoint 8D adds `docs/COLLABORATOR_ONBOARDING_CHECKLIST.md`. Use it before
inviting the first collaborators.

The first onboarding packet should include:

* the repository URL;
* `README.md`;
* `docs/AUTHOR_WORKFLOW.md`;
* `CONTRIBUTING.md`;
* `docs/STARTER_INVENTORY.md`;
* `docs/COLLABORATOR_ONBOARDING_CHECKLIST.md`; and
* the starter verification command.

Keep the first collaborator path small: clone the repository, build a starter,
run the starter guard, then make a small branch-based contribution.
