# Tests

Run everything (each suite in its own process, summary at the end):

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_all_tests.ps1
powershell -ExecutionPolicy Bypass -File tests\run_all_tests.ps1 -List
powershell -ExecutionPolicy Bypass -File tests\run_all_tests.ps1 -Only starters,otbook
```

Run from the repository root, in a MiKTeX PowerShell where `latexmk` and
`py -3`/`python` are on `PATH`.

## Suites

| Suite (`-Only` name) | Runner | Checks |
| --- | --- | --- |
| `release-policy` | `run_release_policy_guard.ps1` | Release documents, templates, workflow boundaries, `\Provides` lines (also run by CI) |
| `build-recipe` | `run_build_recipe_guard.ps1` | `.latexmkrc`, ignore rules and build-script reliability markers (also run by CI) |
| `generated-files` | `run_generated_file_guard.ps1` | Generated files outside `build/` (`-FailOnVisibleGenerated` to fail instead of warn) |
| `manual-references` | `run_manual_author_reference_guard.ps1` | Author manual sections and `\src{file}{line}` references |
| `starters` | `run_starter_tests.ps1` | Every copyable starter document (also run by CI) |
| `physicsquiz` | `run_physicsquiz_tests.ps1` | All `physicsquiz` regressions (see below) |
| `ot-baseline` | `run_ot_baseline_tests.ps1` | OT documents against `ot_baseline_manifest.json` (`-Record` to re-record after an intended visual change) |
| `ot-contracts` | `run_ot_contract_tests.ps1` | Architecture contracts: box ownership, `minimal`, link policy, layout, notation names, interface inventory |
| `otbook` | `run_otbook_tests.ps1` | Book starter, class smoke test, project template |
| `engineering`, `eee-report`, `projects`, `forms` | `run_engineering_tests.ps1`, … | `otengineering` and its packages |
| `access`, `bib-index`, `circuits`, `code`, `margin-notes`, `nomenclature`, `plots`, `profiles`, `repro`, `theorem-policy`, `standalone-figures`, `dotgrid` | `run_<feature>_tests.ps1` | One companion package or feature each |
| `lualatex` | `run_lualatex_tests.ps1` | LuaLaTeX build path |
| `spong-repro` | `run_spong_repro.ps1` | The Spong reconstruction example |
| `author-kit` | `run_author_kit_tests.ps1` | Author-kit generation |

`run_build_measurement.ps1` is a timing report, not a test; run it on demand.

## physicsquiz internal steps

`run_physicsquiz_tests.ps1` runs two chains; each script calls the one
before it:

* `run_physicsquiz_phase4ij_tests.ps1` → `4g` → `4f` → `4e` → `4d` → `4c` → `3d`
* `run_phase6f_tests.ps1` → `6e` → `6d` → `6c` → `6b` → `6a`

Run a single step only while iterating on that phase. The Phase 6A–6E steps
write under `tests/build/` (latexmk changes into `tests/` before building);
that folder is git-ignored.

## Fixtures and checkers

* `*.tex` here are fixtures: `physicsquiz_*` (118) for the `physicsquiz`
  steps, `ot_*`/`otscience_*`/`otbook_*`/`otemphasis_*`/`otlayout_*`/`otaccess_*`
  for the OT suites, `studentnotes_*` and `otengineering_*` for those classes.
* `check_*.py` are the Python checkers the runners call.
* `powershell_log_helpers.ps1` is shared by several runners.

## Retired runners

`tests/history/` keeps checkpoint-era runners that are no longer run; see
`tests/history/README.md`.
