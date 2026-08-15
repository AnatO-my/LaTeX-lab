# Phase 9 Checkpoint 9G - Closure

## Scope

Checkpoint 9G closes Phase 9: automation and performance.

The phase established measurements, hygiene checks, build-recipe reliability,
starter timing, TikZ/dot-grid audit data, and one conservative performance-path
modernization.

## Completed

Phase 9 completed:

* baseline measurement for representative builds;
* generated-file hygiene reporting and ignore updates;
* build-recipe reliability checks;
* per-starter timing;
* TikZ and dot-grid source audit;
* StudentNotes image/PDF dot-grid opt-in path;
* idempotent `\usedotgrid`; and
* a final closeout guard.

## Verification

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase9g_phase_closeout.ps1
```

The closeout runner writes ignored reports under:

```text
build/phase9g-closeout/
```

Result:

```text
All Phase 9G closeout checks passed.
```

The first closeout report checked 21 required files and 11 required markers,
with 0 warnings and 0 failures.

The Phase 9C reliability guard was rerun after adding the 9G runner:

```text
PowerShell runners parsed: 23 / 23
findings: 0
failures: 0
```

## Preserved

Phase 9 keeps the existing TikZ dot grid as the default fallback.

The image/PDF dot-grid path is opt-in. It should become the default only after a
packaged background asset is measured and added cleanly to release or author-kit
rules.

## Carried Forward

Phase 10 can now focus on maintained-software practices:

* version policy;
* release notes and release assets;
* broader CI;
* a small regression-test strategy such as `l3build`; and
* the first protected pull-request trial.
