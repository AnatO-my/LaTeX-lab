# Phase 7 Checkpoint 7H - Release PDF Checklist

## Scope

Checkpoint 7H records the manual checklist for creating optional release preview
PDFs. It does not create PDFs, attach release assets, or change source rendering.

## Added

* `docs/RELEASE_PDF_CHECKLIST.md`
* `PHASE7_CHECKPOINT_7H.md`

## Outcome

The release-PDF boundary is now explicit:

* preview PDFs are optional;
* PDFs are generated from committed starter sources;
* the Phase 7C starter runner is the build source;
* each preview PDF requires visual review; and
* PDFs are attached to GitHub releases rather than committed as ordinary source.

## Verification

This checkpoint is documentation-only. Verification:

```powershell
git diff --check
git status --short --branch
```
