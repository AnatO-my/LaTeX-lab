# Phase 5 Checkpoint 5D - Theme and box cleanup closure

## Scope

Checkpoint 5D audits the cleanup space left after Checkpoints 5B and 5C.

The original 5D item was for `otengineering.cls` to adopt `ottheme.sty` while
preserving its darker `OTLight=#F3F4F6` background. That work was completed
early in Checkpoint 5B, where both OT classes moved onto `ottheme`.

## Decision

No additional source extraction is required for 5D.

The structural cycle is already gone:

* `otnotation`, `otmath`, and `otfigures` load `ottheme` directly.
* `otboxes` owns `otscibox` and `otsciboxnosplit`.
* `otpractice` loads `otboxes` directly.
* `otpractice_standalone` is now a positive test.

The remaining duplication between `otscience.cls` and `otengineering.cls` is
page furniture and package setup, which belongs to the optional `otcore.sty`
checkpoint rather than to theme or box cleanup.

## Change

No class or package behavior changes.

Checkpoint 5D only updates project records and stale comments so they point to
the already-completed 5B and 5C work.

## Acceptance contract

* Checkpoint 5B remains the owner of the shared theme extraction.
* Checkpoint 5C remains the owner of the shared box extraction.
* `tests/run_ot_phase5_tests.ps1` no longer describes the `OTLight` override as
  deferred work.
* The next architectural decision is whether to implement optional `otcore.sty`.

## Verification

No full LaTeX rebuild is required for this no-op source checkpoint. The latest
full Phase 5 command after 5C passed with:

```text
All OT Phase 5 tests passed.
```
