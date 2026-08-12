# Phase 5 Checkpoint 5B — Shared OT theme

## Scope

Checkpoint 5B extracts the shared OT colour palette and hyperlink policy into
`src/packages/ottheme.sty`.

It changes palette ownership, not visual design. The accepted colour values stay
the same: `otscience` receives the shared `OTLight=#F9FAFB`, while
`otengineering` loads the shared palette and then deliberately restores its
documented `OTLight=#F3F4F6` value.

## Change

New package:

```text
src/packages/ottheme.sty
```

Updated consumers:

* `src/classes/otscience.cls` now loads `ottheme` instead of defining the OT
  palette and hyperlink policy inline.
* `src/classes/otengineering.cls` now loads `ottheme` and re-declares only its
  divergent `OTLight`.
* `src/packages/otnotation.sty`, `src/packages/otmath.sty`, and
  `src/packages/otfigures.sty` now load `ottheme` directly, so their use of
  `OT...` colours no longer relies on `otscience.cls` having been loaded first.
* `src/packages/otmath.sty` now also loads the `tcolorbox` libraries required by
  its own boxed environments, so `identitybox` and `proofbox` compile outside an
  OT class.
* `tests/check_ot_baseline.py` now tolerates only the known volatile rendered
  date strings when comparing text hashes, after a cross-day rebuild proved the
  5A baseline was too sensitive to `\today` and `\DTMtoday`.
* `tests/ot_theme_package_smoke.tex` and `tests/run_ot_phase5_tests.ps1` add a
  compile-only smoke test for the three newly independent theme-using packages.
* `tests/powershell_log_helpers.ps1` retries `Select-String` log reads in the
  PowerShell runners, after the untouched-side guard hit a transient Windows file
  lock on a freshly written physicsquiz log.

## Acceptance contract

* The two palette probes still emit 10 science colours and 8 engineering
  colours.
* The OT rendering baseline is unchanged apart from weak PDF byte-size warnings.
* `otpractice_standalone` remains an expected failure with
  `Environment otscibox undefined`; the box cycle is intentionally left for
  Checkpoint 5C.
* The new theme-package smoke emits `OT5B-SMOKE:OTNOTATION`,
  `OT5B-SMOKE:OTMATH`, and `OT5B-SMOKE:OTFIGURES`.
* The accepted Phase 4I/4J guard still passes.

## Run

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_ot_phase5_tests.ps1
```

Expected ending:

```text
PASS Checkpoint 5B standalone theme-package smoke.
PASS expected failure: otpractice_standalone
All OT Phase 5 tests passed.
```

Verified ending on 12 August 2026:

```text
PASS expected failure: otpractice_standalone
All OT Phase 5 tests passed.
```

## Later Resolution

Checkpoint 5C moves the base science box environments into `otboxes.sty` and
turns `otpractice_standalone` from an expected failure into a positive document.
