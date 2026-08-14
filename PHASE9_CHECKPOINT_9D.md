# Phase 9 Checkpoint 9D - Starter-suite timing breakdown

## Scope

Checkpoint 9D adds individual starter timing.

Phase 9A showed the starter suite as the largest measured chunk. This checkpoint
breaks that suite down by starter without changing document behavior or
optimizing rendering.

## Added

Phase 9D adds:

```text
tests/run_phase9d_starter_timing.ps1
docs/STARTER_SUITE_TIMING.md
```

## Timing Boundary

The runner times each copyable starter independently and preserves the Phase 7C
marker checks.

It writes reports under:

```text
build/phase9d-starter-timing/
```

The generated reports are ignored artifacts.

## TikZ And Dot-Grid Carry-Forward

Phase 9D keeps TikZ and dot-grid work deferred.

Phase 9E should audit TikZ-heavy and dot-grid-related structures after the
starter timing split is known.

## Verification

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase9d_starter_timing.ps1
```

This Codex shell may not see `latexmk` on `PATH`; use the normal MiKTeX
PowerShell environment for the timing run.

Result in this Codex shell:

```text
PowerShell syntax OK
latexmk was not found on PATH.
```

The runner is ready for the normal MiKTeX PowerShell timing run.

## Preserved

Checkpoint 9D changes no author-facing document interfaces, rendering logic, or
build recipes.
