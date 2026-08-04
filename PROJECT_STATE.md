# PROJECT_STATE.md

## Project

LaTeX Workspace Learning and Class Refactoring Project

## Environment

* Operating system: Windows
* Editor: Visual Studio Code
* TeX distribution: MiKTeX 26.2
* pdfTeX: MiKTeX-pdfTeX 4.26
* Build tool: latexmk 4.88
* Local extension: LaTeX Workshop
* Overleaf Workshop use: deliberate online collaboration and multi-device access only
* Primary working copy: local project folder
* Repository root: `C:\Users\Ot\OneDrive\Documents\LaTeX\LaTeX-Lab`
* Primary Git branch: `main`

## Current phase

**Phase 1 — complete; Phase 2 ready to begin.**

The project-local LaTeX Workshop workflow has been configured and validated without changing any class, package, or example-document source.

The repository now has one canonical build configuration shared by VS Code and command-line builds. All representative class architectures, the modular workbook’s combined and standalone roots, controlled output directories, SyncTeX navigation, clean builds, automatic builds, linting, and explicit formatting have been tested successfully.

The next phase is:

**Phase 2 — Semantic and flexible document interfaces.**

## Phase 1 completed configuration

### Repository-level `.latexmkrc`

The repository-level `.latexmkrc` now:

* discovers classes under `src/classes`;
* discovers packages under `src/packages`;
* preserves MiKTeX’s standard input trees;
* builds directly with pdfLaTeX;
* enables SyncTeX;
* enables file-and-line error reporting;
* processes nested roots from their document directories; and
* supports both command-line and LaTeX Workshop builds.

The configuration assumes that `latexmk` is launched from the repository root before `$do_cd` changes into the selected document’s directory.

### Project-local LaTeX Workshop settings

`.vscode/settings.json` now:

* launches builds from the repository root;
* loads the repository `.latexmkrc`;
* writes generated files under `build/%RELATIVE_DIR%`;
* automatically builds LaTeX documents on save;
* displays the selected root file in the status bar;
* uses LaTeX Workshop’s internal PDF viewer;
* runs ChkTeX when a document is saved;
* uses `latexindent` for explicitly requested formatting;
* disables LaTeX formatting on save;
* disables automatic mathematical-delimiter rewriting; and
* disables automatic quotation rewriting.

## Phase 1 acceptance evidence

The following tests passed:

* project-local discovery of all four active classes;
* project-local discovery of all seven OT companion packages;
* `otengineering` representative build;
* `physicsquiz` representative build;
* `studentnotes` representative build;
* combined vector-workbook build;
* standalone vector-workbook module builds;
* correct root selection for combined and standalone documents;
* forward SyncTeX navigation;
* inverse SyncTeX navigation;
* inverse navigation from the combined PDF into an imported module;
* controlled output under the mirrored `build/` tree;
* command-line building through the repository `.latexmkrc`;
* LaTeX Workshop building through the same `.latexmkrc`;
* auxiliary-file cleaning and fresh rebuilding;
* automatic compilation on save;
* ChkTeX 1.7.9 linting; and
* explicit `latexindent` 4.0 formatting.

No `% !TeX root` directives were added. The workbook’s existing conditional architecture correctly supports both combined and standalone compilation.

## Immediate baseline-commit checks

Before creating the baseline commit:

1. Confirm that Git reports the correct repository root:

   ```powershell
   git rev-parse --show-toplevel
   ```

   Expected result:

   ```text
   C:/Users/Ot/OneDrive/Documents/LaTeX/LaTeX-Lab
   ```

2. Remove the accidental untracked file named:

   ```text
   tatus --short
   ```

3. Add the following audited logs to their appropriate example folders:

   * `examples/physicsquiz/PHY104_Exam revision.log`
   * `examples/vector-workbook/00_main_combined_workbook.log`

4. Add the root files:

   * `.gitignore`
   * `CHANGELOG.md`

5. Restage and validate the complete baseline:

   ```powershell
   git add --all
   git status --short
   git diff --cached --check
   git diff --cached --stat
   ```

6. Do not begin source corrections until the baseline commit and annotated tag have been created.

## Canonical repository structure

```text
LaTeX-Lab/
├── .gitignore
├── CHANGELOG.md
├── FILE_CHECKLIST.md
├── MASTER_PROMPT.md
├── PHASE_PROMPTS.md
├── PROJECT_STATE.md
├── ROADMAP.md
│
├── src/
│   ├── classes/
│   │   ├── otengineering.cls
│   │   ├── otscience.cls
│   │   ├── physicsquiz.cls
│   │   └── studentnotes.cls
│   │
│   ├── packages/
│   │   ├── otcoordinates.sty
│   │   ├── otfigures.sty
│   │   ├── otmath.sty
│   │   ├── otnotation.sty
│   │   ├── otphysics.sty
│   │   ├── otpractice.sty
│   │   └── ottensors.sty
│   │
│   └── legacy/
│       └── otscience.sty
│
├── examples/
│   ├── otengineering/
│   │   ├── test.tex
│   │   ├── test.pdf
│   │   └── test.log
│   │
│   ├── physicsquiz/
│   │   ├── PHY104_Exam revision.tex
│   │   ├── PHY104_Exam revision.pdf
│   │   └── PHY104_Exam revision.log
│   │
│   ├── studentnotes/
│   │   ├── Optics.tex
│   │   └── Optics.pdf
│   │
│   └── vector-workbook/
│       ├── 00_common_setup.tex
│       ├── 00_main_combined_workbook.tex
│       ├── 00_main_combined_workbook.pdf
│       ├── 00_main_combined_workbook.log
│       ├── 01_grad_div_curl_vector_fields.tex
│       ├── 01_grad_div_curl_vector_fields.pdf
│       ├── 02_coordinate_systems_tensor_operations.tex
│       ├── 02_coordinate_systems_tensor_operations.pdf
│       ├── 03_index_delta_levicivita.tex
│       ├── 03_index_delta_levicivita.pdf
│       ├── 04_covariant_contravariant_metrics.tex
│       ├── 04_covariant_contravariant_metrics.pdf
│       ├── 05_symmetric_skew_tensors_invariants.tex
│       ├── 05_symmetric_skew_tensors_invariants.pdf
│       ├── 06_complex_numbers_hyperbolic_functions.tex
│       ├── 06_complex_numbers_hyperbolic_functions.pdf
│       ├── 07_final_mixed_practice_bank.tex
│       └── 07_final_mixed_practice_bank.pdf
│
└── tests/
```

The `tests` directory is intentionally empty. Git will not track it until it contains a test file or placeholder.

## Canonical source files

### Classes

* `src/classes/studentnotes.cls`
* `src/classes/physicsquiz.cls`
* `src/classes/otengineering.cls`
* `src/classes/otscience.cls`

All four active classes have now been supplied and audited.

### Active OT packages

* `src/packages/otnotation.sty`
* `src/packages/otmath.sty`
* `src/packages/ottensors.sty`
* `src/packages/otphysics.sty`
* `src/packages/otcoordinates.sty`
* `src/packages/otpractice.sty`
* `src/packages/otfigures.sty`

These seven packages form the companion package system used by `otscience.cls` and the modular workbook.

They currently depend on colours, boxes, or other interfaces defined by `otscience.cls`. They must therefore be treated as ecosystem components rather than independently loadable general-purpose packages.

### Legacy source

* `src/legacy/otscience.sty`

This is the older monolithic version 0.1 implementation.

It overlaps with the newer version 0.2 `otscience.cls` and its seven companion packages. It is preserved for historical reference and must not be loaded alongside the active `otscience.cls` architecture.

## Representative projects

### `physicsquiz.cls`

Representative project:

* `PHY104_Exam revision.tex`
* `PHY104_Exam revision.pdf`
* `PHY104_Exam revision.log`

The audited build produced a readable 24-page examination-revision document without LaTeX warnings or overfull boxes.

One pagination defect remains: Question 60’s stem ends at the bottom of the left column while all five choices move to the top of the right column. This must become a later regression test.

### `studentnotes.cls`

Canonical representative project:

* `Optics.tex`
* `Optics.pdf`

The separate normal-modes project was also audited during Phase 0. Its historical log confirmed successful compilation and identified a small margin-note overflow. The `Optics` project is presently the representative example retained in the canonical repository.

### `otengineering.cls`

Representative project:

* `test.tex`
* `test.pdf`
* `test.log`

The audited build produced a four-page engineering notebook. The project dashboard fits correctly, and the log contains only one harmless underfull-box warning.

### `otscience.cls` and modular workbook

The workbook source set is complete.

It contains:

* the active class;
* all seven companion packages;
* `00_common_setup.tex`;
* the combined root document;
* all seven numbered modules;
* combined and standalone reference PDFs;
* the historical combined-build log.

The historical MiKTeX 26.2 build successfully loaded the class, all seven packages, the shared setup, and all seven modules. It produced the preserved 30-page combined PDF.

Because the files have now been placed in a canonical repository structure, local class and package search-path configuration will be addressed in Phase 1. Internal `\documentclass`, `\input`, and package paths must not be changed prematurely.

## Known current features

### `studentnotes.cls`

* `article` base class
* fixed A4 and 12-point configuration
* geometry and margin-note support
* `fancyhdr`
* custom section formatting
* optional TikZ dot-grid page background
* semantic `tcolorbox` note environments
* theorem, definition, and example environments
* custom formula counter
* `namedformula` environment
* margin-note helper commands
* `witharrows` helper commands
* matrix and vector helper commands

### `physicsquiz.cls`

* `article` base class
* pass-through class options
* configurable global quiz font size
* title metadata setters
* custom quiz title page
* constants box
* multi-column `quizquestions` environment
* fixed five-argument `\choices` command
* answer-key environment
* `siunitx` configuration
* custom colours and page styling

### `otengineering.cls`

* project metadata setters
* project dashboard and title commands
* semantic engineering and research boxes
* status labels
* confidence, success, and pursuit ratings
* calculation fields
* sketch boxes
* project tracking and decision-record helpers

### `otscience.cls`

* scientific-document page layout
* mathematical and physics package support
* breakable and non-splitting semantic boxes
* section and header styling
* scientific colour system
* conditional loading of the seven OT companion packages
* `hyperref` and `cleveref` support
* combined and standalone workbook architecture

## Agreed principles

* Preserve the existing visual identity unless redesign is explicitly approved.
* Learn the underlying concepts while refactoring.
* Make small, compilable changes.
* Preserve backward compatibility where reasonable.
* Do not replace MiKTeX without a concrete need.
* Keep local files as the primary working copy.
* Use Overleaf deliberately rather than as the sole source.
* Maintain explicit change and state records between sessions.
* Do not assume a build succeeded without checking the relevant log.
* Do not change unrelated parts of a class or package.
* Introduce new packages only when their benefit justifies their maintenance cost.
* Preserve representative outputs for visual and behavioural comparison.
* Record public-interface changes and migration requirements.

## Known issues to audit or correct later

These findings are recorded for controlled treatment in later phases. They must not be fixed before the Git baseline is secured.

### `studentnotes.cls`

* `witharrows` is loaded twice.
* The required argument of `namedformula` is currently ignored.
* The dot-grid background creates approximately 2,580 TikZ dots per page.
* Calling `\usedotgrid` more than once may install the background repeatedly.
* The class loads `marginnote` but primarily uses `\marginpar`.
* Narrow margin notes can stack words awkwardly.
* Several generic public environment names create future collision risks.

### `physicsquiz.cls`

* `\choices` requires exactly five arguments.
* Question content is coupled to a fixed vertical choice layout.
* Question stems and choices can separate across columns.
* Question 60 in the representative PDF demonstrates this pagination defect.
* Public commands and environments require formal documentation.
* Some dependencies may be broader than the class implementation requires.

### `otengineering.cls`

* A `tabularx` inside a `tcolorbox` uses `\textwidth`; `\linewidth` may be safer.
* Some loaded packages may support document content rather than class implementation.
* Several generic public names create namespace-collision risks.
* The representative log contains one harmless underfull-box warning.

### `otscience.cls` and workbook

* A long Section 4 heading requires approximately `25.16pt` of header height, while the setup specifies `13.6pt`.
* The historical workbook log records eleven overfull lines.
* The largest recorded overflow is approximately `28.74pt`.
* Mathematical spacing commands in subsection titles generate malformed PDF-bookmark warnings.
* Two `siunitx` settings are deprecated.
* The attempted `physics`–`siunitx` warning suppression is ineffective in the preserved log.
* `00_main_combined_workbook.tex` loads `silence` even though the class already loads it.
* Some subsection and module headings require editorial correction.
* `\CartToCyl` and `\CartToSph` use `\tan^{-1}(y/x)`, which loses quadrant information; a later implementation should use an `atan2` formulation.
* The companion packages currently depend on class-defined colours and box interfaces.
* The optional-loading arrangement can hide missing ecosystem dependencies.
* Combined and standalone builds require controlled regression testing after path configuration.

### General ecosystem issues

* Public namespaces are not formally documented.
* Minimum supported LaTeX version has not been chosen.
* Engine support has not been formally defined.
* No automated class regression suite exists.
* No `l3build` configuration exists.
* Package-version diagnostics are not automated.
* The preserved PDFs are untagged and contain limited document metadata.

## Decisions still required

* Minimum supported LaTeX kernel or release date
* Whether support is limited to pdfLaTeX or extended to LuaLaTeX and XeLaTeX
* Exact output modes required from `physicsquiz.cls`
* Whether assessment questions should use a lightweight custom architecture or `xsim`
* How much shared code should move into common OT packages
* Whether the modular workbook should retain its existing conditional structure or adopt `subfiles`
* Whether generated PDFs and selected logs should remain version-controlled after the baseline
* Naming and compatibility policy for public commands
* Accessibility target for future PDFs
* Release-versioning and tagging conventions

## Phase 2 entry point

Phase 2 will audit and improve semantic document interfaces without changing the established visual identity.

The priority interfaces are:

* the fixed five-argument `\choices` command in `physicsquiz.cls`;
* the currently unused required argument of `namedformula` in `studentnotes.cls`;
* labels and cross-references;
* theorem and semantic-box interfaces; and
* documentation of public commands and environments.

Phase 2 must inspect every representative source that currently uses `\choices`, `namedformula`, theorem environments, note boxes, or answer-key environments before changing their definitions.

Compatibility with current documents must be preserved where practical. Existing syntax should remain available through compatibility definitions until a deliberate migration is approved.

Multiple assessment-output modes, question-bank metadata, and large architectural changes do not belong in Phase 2.

## Session handover log

### Session 0 — Project definition

* Established the staged learning and refactoring plan.
* Confirmed that MiKTeX, pdfTeX, latexmk, and LaTeX Workshop are working.
* Established local project folders as the primary working copy.
* Agreed to preserve visual identity and backward compatibility.
* No source files were modified.

### Session 1 — Initial Phase 0 audit

* Inspected the four classes, supplied documents, modules, and reference PDFs.
* Inventoried the public commands and environments.
* Audited direct package dependencies.
* Identified missing shared setup, companion packages, and diagram fragments.
* Recorded layout, performance, namespace, and interface risks.
* Confirmed that historical PDFs demonstrated successful earlier builds.
* No source files were modified.

### Session 2 — Phase 0 evidence completion

* Inspected all seven OT companion packages.
* Inspected `00_common_setup.tex`.
* Confirmed that the workbook source set is complete.
* Distinguished the active `otscience.cls` architecture from the legacy `otscience.sty`.
* Inspected representative `physicsquiz` and `otengineering` projects, PDFs, and logs.
* Confirmed the successful 30-page workbook build from its historical log.
* Recorded the workbook warnings and the Question 60 column-splitting defect.
* No source files were modified.

### Session 3 — Repository preparation

* Corrected an initially misplaced Git repository that had been created above the intended project root.
* Established `LaTeX-Lab` as the dedicated repository root.
* Reorganised the copied sources into `src/classes`, `src/packages`, and `src/legacy`.
* Established one example folder for each active class architecture.
* Preserved the reference PDFs and available diagnostic logs.
* Staged 41 project files for inspection.
* Identified the accidental untracked file `tatus --short`.
* Identified the two audited logs that must be added before the baseline commit.
* Prepared the repository for final validation, the initial baseline commit, and an annotated Phase 0 tag.

## Next action

Commit the Phase 1 configuration and governance files while excluding the separate modification to `examples/studentnotes/Optics.tex`.

After the Phase 1 commit and tag are verified, begin Phase 2 by auditing the real uses of:

* `\choices`;
* `namedformula`;
* theorem environments;
* semantic note boxes; and
* answer-key environments.

Do not change their definitions until the usage inventory and compatibility requirements have been established.