# Build Recipe Reliability

## Purpose

This guide records the Phase 9C build-recipe reliability boundary.

Phase 9A measured build time. Phase 9B measured generated-file hygiene. Phase 9C
checks that the local scripts and hosted starter workflow still follow the
assumptions those measurements depend on.

## Reliability Command

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase9c_build_recipe_reliability.ps1
```

The command does not build LaTeX documents. It is a structural audit of scripts,
paths, and recipe markers.

## What It Checks

The runner checks:

* every PowerShell runner under `tests/` parses successfully;
* `.latexmkrc` keeps the repository-root, `TEXINPUTS`, `pdfLaTeX`, `do_cd`, and
  diagnostic settings expected by the project;
* `.gitignore` keeps the generated-output patterns established in Phase 9B;
* the Phase 9A measurement runner keeps absolute measurement output paths;
* the Phase 9A timing wrapper keeps build output out of timing data;
* the Phase 9B hygiene runner keeps its visible/generated/ignored inventory
  checks;
* the Phase 7C starter runner resolves output paths from the repository root;
  and
* the hosted starter workflow keeps the retrying MiKTeX setup and starter check.

## Generated Reports

Detailed reports are written under:

```text
build/phase9c-build-recipe/
```

Those reports are ignored build artifacts.

## First Result

The first Phase 9C run passed:

| Item | Count |
| --- | ---: |
| PowerShell runners parsed | 19 / 19 |
| `latexmk` references inventoried | 75 |
| findings | 0 |
| failures | 0 |

## Current Rule

Do not rewrite historical runners just because they use slightly different
styles. Phase 9C is a reliability guard, not a formatting campaign.

When a runner fails because of a path, shell, or output-flow assumption, add the
assumption to this guard after fixing it.
