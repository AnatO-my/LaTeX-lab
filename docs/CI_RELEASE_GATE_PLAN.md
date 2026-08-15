# CI Release Gate Plan

## Purpose

This plan describes how hosted CI should grow from the current starter check
into a release gate.

It is intentionally a plan, not a new workflow. The current protected `main`
rule should continue to require only `Starter documents` until each wider check
has passed repeatedly on GitHub and remains understandable for collaborators.

## Current Required Gate

The current required GitHub status check is:

```text
Starter documents
```

That job proves:

* the hosted MiKTeX setup works;
* project-local classes and packages are discovered;
* all starter documents build;
* generated PDFs are uploaded only as workflow artifacts; and
* `git diff --check` passes.

The current workflow is `.github/workflows/starter-build.yml`.

## Proposed Gate Levels

### Level 1 - Starter Gate

Status: active and required.

Keep requiring:

```powershell
git diff --check
tests\run_phase7c_starter_tests.ps1
```

This remains the only branch-protection requirement until broader hosted checks
have proven stable.

### Level 2 - Release Source Gate

Status: active as a non-required workflow.

Workflow:

```text
.github/workflows/release-source-checks.yml
```

Candidate checks:

```powershell
tests\run_phase10a_release_policy.ps1
tests\run_phase10b_release_notes_template.ps1
tests\run_phase10c_local_release_checklist.ps1
tests\run_phase10d_release_asset_manifest.ps1
tests\run_phase10e_l3build_pilot.ps1
tests\run_phase9c_build_recipe_reliability.ps1
tests\run_phase10gh_release_source_checks.ps1
```

Purpose:

* confirm release policy files are present;
* confirm release-note and asset-manifest templates stay complete;
* confirm the local release checklist still names the required source gates;
* confirm the `l3build` pilot stays non-mandatory until adoption; and
* confirm PowerShell runners remain parseable.

This level runs on pull requests first. Do not make it required until it has
passed on several ordinary PRs.

### Level 3 - Targeted Regression Gate

Status: planned, not active.

Candidate checks:

```powershell
tests\run_phase6f_tests.ps1
tests\run_ot_phase5_tests.ps1
```

Purpose:

* catch changes to the structured physics quiz behavior;
* catch OT class/package rendering baseline drift; and
* keep expensive or baseline-sensitive checks separate from the starter gate.

This level should be manual or scheduled before it becomes a required PR check.

### Level 4 - Release Asset Gate

Status: deferred.

Candidate actions:

* build release-preview PDFs;
* build an author-kit zip;
* record asset hashes with `docs/RELEASE_ASSET_MANIFEST_TEMPLATE.md`; and
* attach assets to a GitHub release.

This level should not run on every pull request.

## Promotion Rules

Promote a planned gate only when:

* it passes on GitHub at least twice without source changes;
* failures are readable from the GitHub log;
* package installation is explicit enough for hosted MiKTeX;
* runtime is acceptable for ordinary pull requests;
* generated outputs remain artifacts or ignored build files; and
* the local checklist has a matching command.

## Branch Protection Rules

Do not add a new required status check immediately.

When Level 2 is stable, add it as a separate required status check instead of
folding it into `Starter documents`. Separate checks make failures easier to
understand:

```text
Starter documents
Release source checks
```

Keep admin bypass available while hosted LaTeX behavior is still being hardened.

## Phase 10F Boundary

Phase 10F creates no new GitHub Actions workflow, required status check,
release tag, generated asset, package version bump, or `l3build` adoption.

Checkpoint 10G adds the non-required Level 2 workflow. Checkpoint 10H records
the promotion checklist for making it required later.
