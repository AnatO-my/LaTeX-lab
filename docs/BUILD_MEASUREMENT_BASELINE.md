# Build Measurement Baseline

## Purpose

This document records the Phase 9A measurement boundary.

Phase 9 should improve reliability, speed, or reproducibility only after the
project can describe what currently happens during normal builds.

## Measurement Command

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase9a_measurement.ps1
```

For a faster starter-only check:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase9a_measurement.ps1 -StartersOnly
```

## What It Measures

The default measurement run builds:

* the complete Phase 7C starter suite;
* the complete structured PHY104 quiz revision;
* the representative StudentNotes optics document;
* the representative OTEngineering notebook; and
* the combined vector workbook root.

The command also records the generated-file inventory under `build/` before and
after the run.

## Generated Reports

The detailed reports are generated under:

```text
build/phase9a-measurement/
```

Those reports are intentionally ignored build artifacts. They should not be
committed as ordinary source.

The measurement runner passes absolute output paths to `latexmk`. This matters
because the repository `.latexmkrc` builds each root document from its own
folder.

The runner prints build output while keeping the timing result list clean, so
the final total is calculated only from measurement records.

## Optimization Rule

Phase 9 changes should be measurement-led.

Do not optimize a class, package, TikZ component, dot-grid background, or build
recipe unless a measurement or repeated failure shows a clear reason.

## First Baseline

The first default run should be recorded in `PHASE9_CHECKPOINT_9A.md` after the
measurement command completes locally.

If the command reports `latexmk was not found on PATH`, run it from the normal
MiKTeX PowerShell environment rather than the restricted Codex shell.
