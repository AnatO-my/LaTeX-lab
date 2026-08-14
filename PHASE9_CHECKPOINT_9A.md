# Phase 9 Checkpoint 9A - Measurement baseline

## Scope

Checkpoint 9A opens Phase 9: automation and performance.

This checkpoint adds a measurement runner and records the first build-measurement
boundary. It does not optimize classes, packages, examples, TikZ, dot-grid
backgrounds, or build recipes.

## Added

Phase 9A adds:

```text
tests/run_phase9a_measurement.ps1
docs/BUILD_MEASUREMENT_BASELINE.md
```

## Measurement Boundary

The default runner measures:

* the Phase 7C starter suite;
* the complete structured PHY104 quiz revision;
* the representative StudentNotes optics document;
* the representative OTEngineering notebook; and
* the combined vector workbook root.

It writes generated reports under:

```text
build/phase9a-measurement/
```

The generated reports stay out of ordinary source commits.

## First Local Attempt

Measurement command:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase9a_measurement.ps1
```

Result in this Codex shell:

```text
latexmk was not found on PATH.
```

The runner syntax was checked successfully, but this shell cannot see the local
MiKTeX tools. Run the measurement command in the normal MiKTeX PowerShell
environment to capture the first timing baseline.

First normal-environment feedback showed the representative `physicsquiz`
measurement compiled into an example-local nested `build/` folder because the
runner passed a relative `-outdir` while `.latexmkrc` changes into the source
document directory. The runner now converts measurement output directories to
absolute paths before calling `latexmk`.

Second normal-environment feedback showed build output entering the timing
result collection, which made the final `Seconds` total fail. The timing wrapper
now sends action output to the host display and returns only one timing record
per measured step.

## Preserved

Checkpoint 9A changes no author-facing document interfaces and no rendering
logic.

Optimization remains deferred until measurements identify a clear target.
