# Phase 5 Checkpoint 5E - Shared OT core helpers

## Scope

Checkpoint 5E introduces `src/packages/otcore.sty` for the small amount of
shared setup and page furniture used by `otscience.cls` and `otengineering.cls`.

It does not merge the two class identities. The classes still provide their own
header text, section spacing, subsubsection colour, box systems, metadata, and
semantic environments.

## Change

New package:

```text
src/packages/otcore.sty
```

`otcore.sty` loads the common class-setup packages:

* `geometry` with `margin=1in`;
* `titlesec`;
* `fancyhdr`;
* `enumitem`;
* `tabularx`;
* `array`; and
* `datetime2`.

It also provides class-facing helpers:

* `\otcorelistdefaults`;
* `\otcorepagestyle{<left head>}{<right head>}{<rule width>}`; and
* `\otcoresectionstyles{<label separation>}{<subsubsection colour>}`.

Updated consumers:

* `src/classes/otscience.cls` now loads `otcore` and calls the helpers with its
  established science values.
* `src/classes/otengineering.cls` now loads `otcore` and calls the helpers with
  its established engineering values.
* `tests/ot_core_package_smoke.tex` loads `ottheme` and `otcore`, exercises all
  three helper commands, and emits `OT5E-SMOKE:OTCORE`.
* `tests/run_ot_phase5_tests.ps1` builds the 5E smoke document and checks its
  marker.

## Acceptance contract

* Existing OT representative documents remain baseline-stable.
* `ot_core_package_smoke` emits `OT5E-SMOKE:OTCORE`.
* `otscience.cls` keeps its science headers, `0.3pt` header rule, `0.75em`
  section label separation, and purple subsubsection headings.
* `otengineering.cls` keeps its engineering headers, `0.4pt` header rule, `1em`
  section label separation, and muted subsubsection headings.
* The accepted Phase 4I/4J guard still passes.

## Run

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_ot_phase5_tests.ps1
```

Expected ending:

```text
PASS Checkpoint 5B standalone theme-package smoke.
PASS Checkpoint 5C standalone box-package smoke.
PASS Checkpoint 5C standalone practice-package smoke.
PASS Checkpoint 5E standalone core-package smoke.
All OT Phase 5 tests passed.
```

Direct verification on 12 August 2026:

```text
OT5E-SMOKE:OTCORE
```

The 5E core smoke, `otscience` box compatibility fixture, and `otengineering`
box compatibility fixture compiled successfully in MiKTeX.

Full checkpoint verification on 12 August 2026:

```text
All OT Phase 5 tests passed.
```

## Deferred

Checkpoint 5F closed governance: public-interface finalization, phase notes,
package support policy, generated-output policy, and the remaining
`physicsquiz.cls` semantic version decision. That decision stays aligned with
the Phase 5 boundary: Phase 5 changes the OT shared design system, while
`physicsquiz.cls` is protected by the chained guard.
