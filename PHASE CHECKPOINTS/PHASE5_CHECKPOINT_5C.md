# Phase 5 Checkpoint 5C - Shared OT boxes

## Scope

Checkpoint 5C extracts the generic science box foundations into
`src/packages/otboxes.sty`.

It changes ownership, not visual design. The accepted `otscibox` and
`otsciboxnosplit` settings stay the same, including colours, padding, border
weight, corner radius, and page-space requests.

## Change

New package:

```text
src/packages/otboxes.sty
```

Updated consumers:

* `src/classes/otscience.cls` now loads `otboxes` and keeps the semantic science
  wrappers such as `definitionbox`, `formulabox`, and `warningbox`.
* `src/packages/otpractice.sty` now loads `otboxes` directly, so its practice
  wrappers no longer depend on `otscience.cls`.
* `tests/ot_boxes_package_smoke.tex` directly loads `otboxes` and exercises both
  `otscibox` and `otsciboxnosplit`.
* `tests/otpractice_standalone.tex` is now a positive standalone package smoke
  instead of an expected-failure cycle witness.
* `tests/run_ot_phase5_tests.ps1` builds both 5C smoke documents and checks
  their log markers.

## Acceptance contract

* The OT rendering baseline is unchanged apart from weak PDF byte-size warnings.
* `ot_boxes_package_smoke` emits `OT5C-SMOKE:OTBOXES`.
* `otpractice_standalone` compiles successfully and emits
  `OT5C-SMOKE:OTPRACTICE`.
* `otpractice_standalone` no longer appears in the expected-failure list.
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
All OT Phase 5 tests passed.
```

Direct smoke verification on 12 August 2026:

```text
OT5C-SMOKE:OTBOXES
OT5C-SMOKE:OTPRACTICE
```

Full checkpoint verification on 12 August 2026:

```text
All OT Phase 5 tests passed.
```

## Next

Checkpoint 5D closes the reserved theme and box cleanup stage. If no further
cleanup is required there, the next architectural checkpoint is `otcore.sty`.
