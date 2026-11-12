# Phase 8 Checkpoint 8H - Source-derived author kit

## Scope

Checkpoint 8H prepares the first source-derived author kit.

This checkpoint does not commit the kit folder or zip. The kit remains an
ignored generated release asset under `build/` until it is attached manually to
a GitHub release or shared privately.

## Source

The author kit was prepared from:

```text
de87e4b
```

The kit follows `docs/AUTHOR_KIT_MANIFEST.md`.

## Local artifacts

Kit folder:

```text
build/author-kit/latex-lab-author-kit-2026-08-13/
```

Zip:

```text
build/author-kit/latex-lab-author-kit-2026-08-13.zip
```

The zip size is `56899` bytes.

SHA256:

```text
093855b8fbfd9fd2313cd49f674e5c00ffb26bc3faa6f0b499b6d6f16219fe60
```

## Included

The first kit includes:

* repository overview and contribution guide;
* author workflow, starter inventory, and public interface docs;
* `.latexmkrc`;
* `src/classes/`;
* `src/packages/`;
* all seven starter documents;
* `examples/vector-workbook/00_common_setup.tex`;
* `tests/run_phase7c_starter_tests.ps1`; and
* `tests/powershell_log_helpers.ps1`.

Optional reference examples were not included in this first lightweight kit.

## Verification

The kit was verified from its own root with:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

The starter runner passed.

After verification, generated kit-local `build/` outputs were removed before the
zip was created.

The final kit folder and zip were scanned for excluded items:

* no `build/`;
* no `.git/`;
* no `tests/__pycache__/`;
* no `examples/physicsquiz/indent.log`; and
* no `AGENTS.md`.
