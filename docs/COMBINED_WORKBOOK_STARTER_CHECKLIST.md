# Combined Workbook Starter Checklist

## Purpose

This checklist records the Phase 7 decision for the vector-workbook starter
shape. A standalone module starter is useful, but a tiny combined root makes the
multi-part workbook outcome visible to authors.

## Decision

Keep both starters:

* `examples/vector-workbook/starter_module.tex` for one workbook part that can
  build by itself; and
* `examples/vector-workbook/starter_combined_workbook.tex` for a small root file
  that imports one or more modules.

This preserves the existing workbook architecture: modules remain independently
buildable, and the combined root imports them by setting `\OTCOMBINED`.

## Author Outcome

An author can now start from:

* a single standalone workbook lesson; or
* a combined workbook that gathers lessons into one PDF.

## Verification

Both starters are included in the starter runner:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

The combined starter is accepted when it builds a PDF and emits the
`OT7J-STARTER:VECTOR-WORKBOOK-COMBINED` marker.
