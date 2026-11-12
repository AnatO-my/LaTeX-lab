# Author Workbook Manual Checkpoint

## Included

Created `examples/manual/ot_author_workbook_manual.tex` as a source-derived author workbook for the active LaTeX-lab class and package surface.

The manual includes:

* start-here decision guide for new authors;
* class comparison table for `physicsquiz`, `studentnotes`, `otscience`, and `otengineering`;
* package comparison table for `otcore`, `ottheme`, `otboxes`, `otmath`, `otnotation`, `ottensors`, `otphysics`, `otcoordinates`, `otpractice`, and `otfigures`;
* dependency catalog for every active `.cls` and `.sty` file requested;
* required versus conditional package-load distinction;
* author-facing feature tables with minimal usage examples and source line references;
* internal/shared-package caution section;
* legacy appendix for `src/legacy/otscience.sty`, marked not for new documents;
* ambiguous/internal/unsafe review section; and
* source-reference appendix with inspected files and line-reference method.

## Excluded

No existing class or package behavior was changed.

No generated PDF, log, auxiliary, or `build/` output is added as source. The intended PDF output path is:

```text
build/manual/ot_author_workbook_manual.pdf
```

MiKTeX package mappings are marked unconfirmed in the manual because `mpm`, `initexmf`, and `latexmk` were not visible on this Codex shell's `PATH` during the inspection pass. The manual records package names exactly as loaded in source and notes the project-state evidence for `xsim`, `siunitx`, and the hosted `amscls`/`amsthm` gap.

## Still needs review

The following interfaces are documented but should not be promoted as ordinary author workflow without maintainer review:

* `physicsquiz` assertion helpers: `\quizbankassert`, `\quizselectionassert`, `\quizshuffleassert`, and `\quizversionassert`;
* `physicsquiz` uppercase metadata storage macros such as `\QuizTitle`;
* `studentnotes` internal dot-grid macros with `\studentnotes@...` names;
* generic macro names that can collide with other packages, including `\mat`, `\unit`, `\position`, and `\velocity`;
* `otcoordinates` transform helpers that use `\tan^{-1}(y/x)` rather than documenting quadrant-safe `atan2` semantics; and
* all `src/legacy/otscience.sty` interfaces, which are historical only.

## Verification

Added `tests/run_manual_author_reference_guard.ps1`. The guard checks:

* manual source exists;
* this checkpoint exists;
* required manual sections are present;
* every requested active and legacy source file is named;
* source references of the form `{src/...}{line}` point to existing files and existing nonblank lines; and
* checkpoint markers are present.

The requested LaTeX build command is:

```powershell
latexmk -pdf -interaction=nonstopmode -halt-on-error "-outdir=build\manual" examples\manual\ot_author_workbook_manual.tex
```

If `latexmk` is unavailable on `PATH`, run the command again in the normal MiKTeX PowerShell environment recorded in `PROJECT_STATE.md`.

## Generated-file hygiene

The manual source and guard are source files. The generated PDF, logs, auxiliaries, and any build reports belong under ignored `build/` output and should remain out of source control unless explicitly approved.
