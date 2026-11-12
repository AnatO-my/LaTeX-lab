# Phase 10 Checkpoint 10D - Release asset manifest template

## Summary

Checkpoint 10D adds a release-asset manifest template.

The checkpoint is source-only. It records how future downloadable PDFs and
author-kit zips should be listed, reviewed, and hashed, but it does not create a
tag, version bump, generated PDF, zip, GitHub release, or new CI workflow.

Phase 10D adds:

```text
docs/RELEASE_ASSET_MANIFEST_TEMPLATE.md
tests/run_phase10d_release_asset_manifest.ps1
PHASE10_CHECKPOINT_10D.md
```

It also links the manifest from the README and local release checklist.

## Asset Boundary

The manifest template is used only when a release needs downloadable assets.

The planned asset ids are:

* `starter-pdfs`;
* `starter-quiz-bank-pdf`;
* `starter-versioned-quiz-pdf`;
* `starter-student-notes-pdf`;
* `starter-engineering-notes-pdf`;
* `starter-science-notes-pdf`;
* `starter-workbook-module-pdf`;
* `starter-combined-workbook-pdf`; and
* `author-kit`.

Each included asset should name its source, output name, status, and `sha256`
hash in the release notes. Omitted assets should be recorded deliberately, not
left ambiguous.

## Verification

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase10d_release_asset_manifest.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase10c_local_release_checklist.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase9c_build_recipe_reliability.ps1
```

The runner writes ignored reports under:

```text
build/phase10d-release-asset-manifest/
```

Expected result after committing the 10D source changes:

```text
All Phase 10D release asset manifest checks passed with 0 warning(s) and 2 note(s).
```

The guard checks 11 required files, 12 required markers, and 9 planned release
asset ids.

The committed-state cross-checks also passed:

* Phase 10C local release checklist: 0 warnings and 0 failures;
* Phase 9C build-recipe reliability: 27 of 27 PowerShell runners parsed, with 0
  findings and 0 failures.

## Decision

Phase 10D establishes a manifest format for future release assets while keeping
release assets optional. The next Phase 10 checkpoint can evaluate a minimal
`l3build` proof or plan a broader CI release gate.
