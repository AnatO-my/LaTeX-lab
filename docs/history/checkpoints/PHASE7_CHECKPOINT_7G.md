# Phase 7 Checkpoint 7G - Author Kit Build Checklist

## Scope

Checkpoint 7G records the manual checklist for producing a future source-derived
author kit. It does not create a zip, add generated outputs, or automate
packaging.

## Added

* `docs/AUTHOR_KIT_BUILD_CHECKLIST.md`
* `PHASE7_CHECKPOINT_7G.md`

## Outcome

The author-kit path now has three layers:

* `docs/AUTHOR_KIT_MANIFEST.md` defines what belongs in the kit;
* `docs/AUTHOR_KIT_BUILD_CHECKLIST.md` defines how to assemble and verify it;
  and
* `docs/RELEASE_READINESS.md` defines when the kit should be shared.

## Verification

This checkpoint is documentation-only. Verification:

```powershell
git diff --check
git status --short --branch
```
