# Branch Protection Checklist

## Purpose

This checklist records the first protected-`main` setup for the GitHub
repository.

The goal is simple: collaborators should use pull requests, the starter build
should pass before merge, and `main` should not be force-pushed or deleted by
accident.

## Preconditions

Enable branch protection only after:

* `main` has been pushed to GitHub;
* `.github/workflows/starter-build.yml` exists on `main`;
* the hosted `Starter documents` job has passed on `main`; and
* generated outputs remain absent from the repository source.

These conditions were met before this checklist was added. Commit `e9374af`
passed the hosted starter workflow in 5m 12s and produced the `starter-pdfs`
artifact.

## Recommended First Rule

Use a classic branch protection rule first.

Repository path:

```text
Settings -> Branches -> Branch protection rules -> Add rule
```

Rule target:

```text
main
```

Enable:

* require a pull request before merging;
* require approvals: `1`;
* dismiss stale pull request approvals when new commits are pushed;
* require conversation resolution before merging;
* require status checks to pass before merging;
* require branches to be up to date before merging; and
* required status check: `Starter documents`.

Leave disabled for the first rule:

* require signed commits;
* require linear history;
* require merge queue;
* require deployments before merging;
* lock branch;
* restrict who can push to matching branches;
* allow force pushes; and
* allow deletions.

Do not enable "Do not allow bypassing the above settings" for the first rule.
Keeping admin bypass available gives the maintainer a recovery path while the
hosted workflow is still young.

## Expected Outcome

After the rule is saved:

* collaborators cannot merge into `main` without a pull request;
* pull requests need one approval;
* unresolved conversations block merge;
* `Starter documents` must pass before merge;
* stale approvals are cleared when new commits are pushed; and
* force pushes and branch deletion stay blocked by default.

## Applied Result

The first rule has been applied on GitHub. The branch settings page showed:

```text
main
Currently applies to 1 branch
```

## Deferred Tightening

Do not add stricter requirements until the first protected collaborator pull
request has been tried.

Later candidates:

* require signed commits;
* require linear history;
* require full regression workflows;
* add `Release source checks` after applying
  `docs/RELEASE_SOURCE_CHECKS_PROMOTION.md`;
* use repository rulesets if several branches need shared rules; and
* remove admin bypass only after the recovery path is clear.
