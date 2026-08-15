# Phase 9 Checkpoint 9C - Build recipe reliability

## Scope

Checkpoint 9C adds a build-recipe reliability guard.

This checkpoint does not build documents and does not optimize performance. It
audits the scripts and recipe assumptions that make later measurements
trustworthy.

## Added

Phase 9C adds:

```text
tests/run_phase9c_build_recipe_reliability.ps1
docs/BUILD_RECIPE_RELIABILITY.md
```

## Reliability Boundary

The runner verifies:

* PowerShell syntax for every test runner;
* key `.latexmkrc` settings;
* generated-output ignore patterns;
* Phase 9A absolute output-path and clean timing-result safeguards;
* Phase 9B hygiene inventory safeguards;
* Phase 7C starter output path discipline; and
* hosted starter workflow retry and artifact markers.

## Generated Reports

The runner writes reports under:

```text
build/phase9c-build-recipe/
```

The generated reports are ignored artifacts.

## Verification

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase9c_build_recipe_reliability.ps1
```

Result:

```text
All Phase 9C build-recipe reliability checks passed.
```

The first reliability report recorded:

| Item | Count |
| --- | ---: |
| PowerShell runners parsed | 19 / 19 |
| `latexmk` references inventoried | 75 |
| findings | 0 |
| failures | 0 |

## Preserved

Checkpoint 9C changes no author-facing document interfaces, rendering logic, or
build output.

Historical runners are not reformatted or rewritten. The guard records the
reliability assumptions that matter for Phase 9 measurement work.
