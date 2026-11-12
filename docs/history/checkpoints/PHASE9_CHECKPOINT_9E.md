# Phase 9 Checkpoint 9E - TikZ and dot-grid audit

## Scope

Checkpoint 9E audits TikZ and dot-grid structures.

This checkpoint does not optimize rendering and does not alter document output.
It records the current source-level drawing surface before any future
modernization decision.

## Added

Phase 9E adds:

```text
tests/run_phase9e_tikz_dotgrid_audit.ps1
docs/TIKZ_DOTGRID_AUDIT.md
```

## Audit Boundary

The runner inventories:

* `studentnotes` dot-grid markers;
* the optional `\usedotgrid` public command;
* the representative Optics example's default grid-disabled state;
* the helper smoke test's dot-grid coverage;
* reusable `otfigures` TikZ macro definitions; and
* TikZ package loads, library loads, `tikzpicture` environments, and public
  figure macro uses across source, examples, and tests.

## Verification

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase9e_tikz_dotgrid_audit.ps1
```

The audit writes generated reports under:

```text
build/phase9e-tikz-dotgrid-audit/
```

Result:

```text
All Phase 9E TikZ/dot-grid audit checks passed with 0 warning(s) and 3 note(s).
```

The Phase 9C reliability guard was rerun after adding the 9E audit script:

```text
PowerShell runners parsed: 21 / 21
findings: 0
failures: 0
```

## Dot-Grid Baseline

The current dot-grid estimate is:

```text
43 x positions by 60 y positions = 2,580 dots per page
```

The grid is optional in normal examples and covered once in the helper smoke
test.

## TikZ Inventory Result

The first audit found:

| Area | Result |
| --- | --- |
| `studentnotes.cls` | loads TikZ, two TikZ libraries, and one dot-grid `tikzpicture` |
| `otfigures.sty` | defines six reusable TikZ figure macros |
| `examples\studentnotes\Optics.tex` | contains two local `tikzpicture` diagrams |
| `tests\ot_theme_package_smoke.tex` | exercises `\vectorfigure` once |

## Preserved

Checkpoint 9E changes no author-facing document interfaces, rendering logic, or
build recipes.

The next decision point is whether to add a guarded, opt-in dot-grid
modernization or leave the current optional behavior unchanged.
