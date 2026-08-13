# Phase 7 Checkpoint 7J - Combined Workbook Starter

## Scope

Checkpoint 7J resolves the combined-workbook starter decision. It adds a tiny
combined workbook root and keeps the existing standalone module starter.

## Added

* `examples/vector-workbook/starter_combined_workbook.tex`
* `docs/COMBINED_WORKBOOK_STARTER_CHECKLIST.md`
* `PHASE7_CHECKPOINT_7J.md`

## Changed

* The starter runner now builds the combined workbook starter.
* Starter, author-kit, and release-PDF docs now include the combined starter.

## Outcome

The vector-workbook starter path now supports two author outcomes:

* build one standalone module; or
* build a small combined workbook root that imports modules.

## Verification

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```
