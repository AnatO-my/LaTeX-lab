# Generated File Hygiene

## Purpose

This guide records the Phase 9B generated-file boundary.

The project already separates source from generated output: ordinary build
products belong under `build/` or match ignored LaTeX auxiliary extensions.
Phase 9B makes that boundary measurable before any cleanup or automation is
tightened.

## Hygiene Command

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase9b_generated_hygiene.ps1
```

For a stricter local check that fails when visible generated-looking files are
present:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase9b_generated_hygiene.ps1 -FailOnVisibleGenerated
```

## What It Reports

The runner reports:

* tracked generated-looking files;
* visible untracked generated-looking files;
* ignored generated files;
* ignored output grouped by top directory;
* ignored output grouped by extension; and
* the current `build/` file count and byte size.

Detailed generated reports are written under:

```text
build/phase9b-generated-hygiene/
```

Those reports are ignored build artifacts and should not be committed as
ordinary source.

## Current Policy

Tracked generated-looking files are not automatically wrong. The repository
still has intentional Phase 0 representative PDFs and logs that act as visual
or historical baselines.

Visible untracked generated-looking files should be treated as cleanup
candidates unless a checkpoint explicitly records them as intentional.

Checkpoint 9B ignores the common local-only generated leftovers:

```text
indent.log
__pycache__/
*.py[cod]
```

After that ignore update, the Phase 9B hygiene runner reported zero visible
untracked generated-looking files.

Ignored generated files under `build/` are normal, but a large or stale `build/`
tree can make performance measurements harder to compare. Clean only when the
checkpoint calls for a fresh-build measurement.

## Repository Hygiene Update (September 2026)

Checkpoint records now live in `PHASE CHECKPOINTS/`. All 61 relocated files
match their original Git contents. The Phase 9 closeout and Phase 10 release
checks resolve the records from that directory.

The shared ignore rules also cover:

* LaTeX logs, `xsim` state, and busy SyncTeX files;
* compiled PDFs under `examples/` and `tests/`;
* nested `build/` directories, including copied project-template builds;
* PDF export directories under `output/`; and
* PDF rendering scratch files under `tmp/pdfs/`.

`output/tex/` contains document sources and is deliberately not ignored.
PDFs elsewhere remain eligible for tracking, for example source figures or
release assets. Use `git add -f <path>` only for an intentional PDF fixture
inside an ignored location. Existing tracked PDF/log baselines stay tracked.

Personal portfolio media in this checkout use `.git/info/exclude`, keeping
machine-specific exclusions out of the shared project rules. Ignore rules do
not delete files, move them, or change compiler output locations. Continue
using the documented build recipes to direct new output into `build/`.

The copyable book project at `templates/otbook-project/` uses a local
`.latexmkrc` to keep its generated files inside the project: PDFs and SyncTeX
files go to `build/pdf/`, while logs and auxiliaries go to `build/aux/`. When
that folder is copied into `Current-projects/` or another author workspace,
the same rule keeps the manuscript root focused on source files.

## Cleanup Rule

Do not delete generated outputs as part of ordinary hygiene reporting.

When cleanup is needed, confirm the target first and prefer removing a specific
generated folder, such as `build/phase9a-measurement/`, rather than sweeping the
whole repository.
