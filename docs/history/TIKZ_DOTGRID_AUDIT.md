# TikZ And Dot-Grid Audit

## Purpose

This guide records the Phase 9E TikZ and dot-grid audit boundary.

Phase 9E does not optimize rendering. It identifies which existing structures
could deserve later optimization, using the current source layout as the point
of comparison.

## Audit Command

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase9e_tikz_dotgrid_audit.ps1
```

## What It Checks

The runner checks:

* the `studentnotes` dot-grid public command and implementation markers;
* whether the representative Optics example keeps the grid disabled by default;
* whether the helper smoke test still exercises `\usedotgrid`;
* reusable TikZ figure macro definitions in `otfigures.sty`; and
* TikZ package loads, library loads, `tikzpicture` environments, and public
  figure macro uses across `src/`, `examples/`, and `tests/`.

## Dot-Grid Baseline

The current `studentnotes` grid draws a page background using nested TikZ loops:

```text
43 x positions by 60 y positions = 2,580 dots per page
```

The grid remains optional. The representative Optics example keeps
`\usedotgrid` commented, while `tests\studentnotes_helpers_smoke.tex` exercises
the command once.

## Generated Reports

Detailed reports are written under:

```text
build/phase9e-tikz-dotgrid-audit/
```

Those reports are ignored build artifacts.

## Optimization Boundary

Possible future work should be checked separately before implementation:

* make repeated `\usedotgrid` calls idempotent;
* replace the many-dot page background with a lighter rendering strategy; or
* defer changes if timing reports show the current optional grid is not a real
  cost for normal author workflows.
