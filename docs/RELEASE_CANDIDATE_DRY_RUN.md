# Release Candidate Dry Run

## Purpose

This guide defines the first source-only release-candidate rehearsal.

The dry run proves that the release checklist, release notes template, source
guards, CI gates, and asset-manifest template fit together before the project
publishes a real GitHub release.

## Candidate Label

Use a rehearsal label, not a real release tag:

```text
v0.1.0-rc-dry-run
```

Do not create this as a Git tag.

## Candidate Source

The candidate source should be:

* a committed branch or `main` state;
* clean apart from known local-only files;
* after the `Starter documents` GitHub check has passed;
* after the non-required `Release source checks` workflow has passed; and
* before any generated release asset is attached.

## Dry-Run Commands

Run source checks:

```powershell
git diff --check
powershell -ExecutionPolicy Bypass -File tests\run_phase10a_release_policy.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase10b_release_notes_template.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase10c_local_release_checklist.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase10d_release_asset_manifest.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase10e_l3build_pilot.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase10f_ci_release_gate_plan.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase10gh_release_source_checks.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase10ij_release_candidate.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase9c_build_recipe_reliability.ps1
```

Run the starter build in the normal MiKTeX PowerShell environment:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

## Draft Release Notes

Draft notes from:

```text
docs/RELEASE_NOTES_TEMPLATE.md
```

Record:

* candidate label;
* source commit;
* release type as `preview`;
* checks run;
* public-interface status;
* asset status;
* known limitations; and
* whether admin bypass was used in the PR history.

## Asset Decision

Use:

```text
docs/RELEASE_ASSET_MANIFEST_TEMPLATE.md
```

For the first dry run, mark assets as `omitted` unless preview PDFs or an author
kit are intentionally prepared.

Generated PDFs, zips, logs, auxiliaries, and `build/` outputs remain out of
ordinary source commits.

## Go / No-Go Questions

Before a real release:

* Did `Starter documents` pass on GitHub?
* Did `Release source checks` pass on GitHub?
* Are release notes complete?
* Is the asset manifest complete, even if assets are omitted?
* Are known local-only files excluded from source?
* Are public-interface changes recorded?
* Is a repository label such as `v0.1.0` appropriate?

## Phase 10J Boundary

Phase 10J creates no Git tag, GitHub release, release asset, generated PDF,
author-kit zip, class/package version bump, or branch-protection change.

The next implementation checkpoint can perform the dry run after the current
pull request has passed hosted checks.
