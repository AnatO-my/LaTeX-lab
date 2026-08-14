# Starter Suite Timing

## Purpose

This guide records the Phase 9D starter-suite timing boundary.

Phase 9A showed the full starter suite was the largest measured chunk. Phase 9D
breaks that suite into individual starter timings before any optimization work.

## Timing Command

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase9d_starter_timing.ps1
```

For a forced `latexmk` rebuild:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase9d_starter_timing.ps1 -Force
```

The default command follows the normal starter-build behavior. The forced mode
is useful only when a checkpoint explicitly asks for a fresh timing comparison.

## What It Measures

The runner times:

* physicsquiz bank starter;
* physicsquiz versioned starter;
* StudentNotes starter;
* OTEngineering starter;
* OTScience starter;
* vector-workbook module starter; and
* vector-workbook combined starter.

It also preserves the same marker checks used by the Phase 7C starter runner.

## Generated Reports

Detailed reports are written under:

```text
build/phase9d-starter-timing/
```

Those reports are ignored build artifacts.

## TikZ And Dot-Grid Carry-Forward

Phase 9D does not optimize TikZ or dot-grid rendering.

It labels likely later audit areas so Phase 9E can focus on TikZ-heavy and
dot-grid-related structures with starter timing data already available.

## First Local Attempt

The runner passed PowerShell syntax checking in the Codex shell, but that shell
could not see `latexmk` on `PATH`. Capture the timing table in the normal MiKTeX
PowerShell environment.
