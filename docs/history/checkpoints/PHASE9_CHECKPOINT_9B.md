# Phase 9 Checkpoint 9B - Generated-file hygiene

## Scope

Checkpoint 9B adds generated-file hygiene reporting.

This checkpoint does not delete generated files. It records what is tracked,
visible, ignored, and already under `build/` so later performance work has a
cleaner source/output boundary.

## Added

Phase 9B adds:

```text
tests/run_phase9b_generated_hygiene.ps1
docs/GENERATED_FILE_HYGIENE.md
```

## Hygiene Boundary

The runner reports:

* tracked generated-looking files;
* visible untracked generated-looking files;
* ignored generated files;
* ignored output by top directory;
* ignored output by extension; and
* current `build/` file count and byte size.

Reports are generated under:

```text
build/phase9b-generated-hygiene/
```

The generated reports are ignored artifacts.

## First Local Result

The first hygiene run found:

| Item | Count |
| --- | ---: |
| tracked generated-looking files | 14 |
| visible untracked generated-looking files | 3 |
| ignored generated files | 1292 |
| `build/` files | 1104 |
| `build/` bytes | 48322129 |

Visible generated-looking files were:

```text
examples/physicsquiz/indent.log
tests/__pycache__/check_ot_baseline.cpython-312.pyc
tests/__pycache__/check_ot_baseline.cpython-313.pyc
```

Checkpoint 9B updates `.gitignore` to ignore `indent.log`, `__pycache__/`, and
`*.py[cod]`, so those generated leftovers no longer clutter ordinary status.

After the ignore update, the hygiene runner reported:

| Item | Count |
| --- | ---: |
| tracked generated-looking files | 14 |
| visible untracked generated-looking files | 0 |
| ignored generated files | 1297 |
| `build/` files | 1106 |
| `build/` bytes | 48330481 |

## Expected Local Notes

The current working tree may still show local-only items that should remain
unstaged:

* `.vscode/settings.json`;
* `src/classes/physicsquiz.cls`;
* `AGENTS.md`;
* ignored `examples/physicsquiz/indent.log`; and
* ignored `tests/__pycache__/`.

The hygiene runner should report generated-looking visible leftovers rather than
delete them automatically.

## Verification

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase9b_generated_hygiene.ps1
```

Result after the ignore update:

```text
All Phase 9B generated-file hygiene checks completed.
```

Use `-FailOnVisibleGenerated` only when the working tree is expected to be free
of visible generated leftovers.

## Preserved

Checkpoint 9B changes no author-facing document interfaces, rendering logic, or
build recipes.

Cleanup and stricter enforcement remain deferred until the reported hygiene
state is reviewed.
