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
| Releases | Wait until starter and packaging boundaries are clear. |

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

## Not Yet Decided

These can wait until after Phase 7 starters:

* whether to publish an author-kit zip;
* whether to track release PDFs;
* whether to add GitHub Actions for LaTeX builds;
* whether to mirror docs into a hosted site; and
* whether to support a downstream project template separate from this lab repo.
