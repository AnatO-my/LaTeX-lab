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

**Phase 2 — Semantic and flexible document interfaces — completed on 5 August 2026.**

Phase 2 established and verified the public-interface baseline for all four active classes. It introduced the flexible `physicsquiz` choices interface, completed the `studentnotes` named-formula reference interface, regression-tested the established semantic environments, documented stable and advanced interfaces, and verified the remaining helper commands.

The final Phase 2 checkpoint includes the public-interface reference, two helper smoke tests, the validated `\remembernote` correction, residual class diagnostics corrections, and the verified vector-workbook source corrections.

The independent working-tree modification to `examples/studentnotes/Optics.tex` remains outside the Phase 2 checkpoint and must stay unstaged.

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

## Repository checkpoint status

* The audited Phase 0 baseline has been committed and tagged as `phase-0-baseline`.
* The Phase 1 workflow configuration has been committed and verified.
* The earlier Phase 2 semantic-interface compatibility checkpoints have been committed.
* The final Phase 2 public-interface and helper-verification checkpoint has been completed and verified.
* Generated PDFs, logs, and other build artefacts remain excluded from the source-focused checkpoint.
* `examples/studentnotes/Optics.tex` remains an independent modification and is excluded from the checkpoint.

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
    └── physicsquiz_choices_compatibility.tex
```

The `tests` directory now contains the first isolated compatibility test. Its generated files belong under `build/tests/` and must not be committed from the source directory.

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

The audited baseline build produced a readable 24-page examination-revision document without LaTeX warnings or overfull boxes.

The Phase 2 refactor replaced the unbreakable choices table with a semantic list-based interface. The representative quiz was rebuilt successfully, and Question 60’s five options now remain together in one column without overlapping the following column.

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

The canonical repository structure is now supported by the shared Phase 1 class and package search-path configuration. Internal `\documentclass`, `\input`, and package paths remain unchanged.

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
* flexible `choiceoptions` environment with alphabetical labels
* backward-compatible five-argument `\choices` wrapper
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

These remaining findings are recorded for controlled treatment in the appropriate later checkpoints. They must not be mixed into the current `physicsquiz` choices-interface checkpoint.

### `studentnotes.cls`

* `witharrows` is loaded twice.
* The dot-grid background creates approximately 2,580 TikZ dots per page.
* Calling `\usedotgrid` more than once may install the background repeatedly.
* The class loads `marginnote` but primarily uses `\marginpar`.
* Narrow margin notes can stack words awkwardly.
* Several generic public environment names create future collision risks.

### `physicsquiz.cls`

* The public `choiceoptions` and legacy `\choices` interfaces require formal documentation.
* Wider compatibility testing is still needed for exceptionally long options, displayed mathematics, and future assessment layouts.
* Question stems and choice blocks may still require a deliberate keep-together policy for edge cases beyond the representative quiz.
* Some dependencies may be broader than the class implementation requires.

### `otengineering.cls`

* A `tabularx` inside a `tcolorbox` uses `\textwidth`; `\linewidth` may be safer.
* Some loaded packages may support document content rather than class implementation.
* Several generic public names create namespace-collision risks.
* The representative log contains one harmless underfull-box warning.

### `otscience.cls` and workbook

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

## Phase 2 status

Phase 2 is complete. It audited, documented, and improved semantic document interfaces without changing the established visual identity.

A read-only usage and compatibility audit has been completed for:

* `\choices`;
* `namedformula`;
* theorem environments;
* semantic note boxes; and
* the `answerkey` environment.

### Completed work

* Confirmed 60 legacy `\choices` calls in the representative physics quiz.
* Confirmed that the representative answer key contains a 12-row, five-column `booktabs` table.
* Confirmed exactly 13 `namedformula` calls across the complete normal-modes source set.
* Added the semantic `choiceoptions` environment to `physicsquiz.cls`.
* Allowed an arbitrary number of alphabetically labelled multiple-choice options.
* Preserved the legacy five-argument `\choices{...}{...}{...}{...}{...}` syntax through a compatibility wrapper.
* Added `tests/physicsquiz_choices_compatibility.tex`.
* Reinforced repository class discovery in `.latexmkrc` for command-line and test builds.
* Verified the legacy five-option interface.
* Verified four-option and six-option uses of `choiceoptions`.
* Verified prose choices and display-style mathematical choices.
* Rebuilt the representative 60-question physics quiz through the controlled `build/` output tree.
* Confirmed that Question 60’s options remain together in one column without overlapping the following column.
* Confirmed that the existing answer-key table remains visually correct.

### OTScience semantic-box compatibility checkpoint

* Added `tests/otscience_boxes_compatibility.tex`.
* Verified all ten breakable semantic-box interfaces.
* Verified all ten corresponding `nosplit` interfaces.
* Verified default and custom box titles.
* Verified established colours and visual appearance.
* Verified clean page splitting for breakable boxes.
* Verified intact page-boundary movement for non-splitting boxes.
* Verified that `00_common_setup.tex` loads without redefining class interfaces.
* Verified the `practicebox` and `practiceboxnosplit` workbook wrappers.
* Rebuilt the standalone and combined vector workbooks successfully.
* Confirmed that the existing interfaces require no class-level changes.

### OTEngineering semantic-box compatibility checkpoint

* Added `tests/otengineering_boxes_compatibility.tex`.
* Verified the generic `otbox` interface.
* Verified all fifteen semantic wrapper environments.
* Verified default and custom titles.
* Verified established colours and visual styling.
* Verified the `calculation` environment and `\calcfield` command.
* Verified that short boxes move intact at page boundaries.
* Verified that long breakable boxes continue cleanly across pages.
* Verified complete frames, footer clearance, and absence of clipping or overlap.
* Rebuilt the representative engineering notebook successfully.
* Confirmed that the existing interfaces require no class-level changes.

### Named-formula interface checkpoint

* Preserved the existing `namedformula` environment syntax and visual appearance.
* Preserved section-based numbering in the form `F<section>.<formula>`.
* Preserved formula-counter resets at each section.
* Added `\formularef{<label>}` for references matching the visible formula tag.
* Retained each required descriptive title as reference metadata.
* Enabled descriptive-title references through `\nameref`.
* Kept descriptive titles visually hidden by default.
* Added `tests/studentnotes_namedformula_compatibility.tex`.
* Verified tags `F1.1`, `F1.2`, and `F2.1`.
* Verified section-based counter resetting.
* Verified `\formularef` and `\nameref` output.
* Confirmed that no undefined references remain after rebuilding.
* Made no changes to representative note sources.

### Studentnotes theorem and note-box checkpoint

* Added `tests/studentnotes_theorem_notes_compatibility.tex`.
* Verified independent numbering of `theorem`, `definition`, and `example`.
* Verified section-based counter resets.
* Verified headed and unheaded theorem rendering.
* Verified `\label`, `\ref`, `\nameref`, and `\autoref`.
* Verified the established appearance of `quicknote`, `personalnote`, and `importantnote`.
* Verified that all three note boxes remain intact at page boundaries.
* Confirmed that the existing interfaces require no class-level changes.
* Made no changes to representative note sources.

### Compatibility decisions

* Existing documents using the five-argument `\choices` command require no migration.
* The new `choiceoptions` environment is additive.
* The legacy `\choices` command delegates to the new semantic interface.
* The `answerkey` environment remains unchanged.
* Multiple assessment-output modes, question-bank metadata, and large architectural changes remain outside Phase 2.
* The separate working-tree modification to `examples/studentnotes/Optics.tex` remains outside Phase 2.

### Public-interface documentation checkpoint

* Added `docs/PUBLIC_INTERFACES.md`.
* Documented the supported interfaces of all four active classes.
* Distinguished stable author interfaces, advanced ecosystem hooks, package-owned commands, and internal implementation details.
* Recorded syntax, arguments, defaults, representative examples, compatibility guarantees, and namespace risks.
* Verified the documentation against canonical class sources and existing regression evidence.

### Helper-interface verification checkpoint

* Added `tests/otengineering_helpers_smoke.tex`.
* Verified project metadata, dashboards, sketch helpers, status labels, ratings, field helpers, and theme colours.
* Added `tests/studentnotes_helpers_smoke.tex`.
* Verified metadata, title output, dotted background, margin-note helpers, arrow annotations, the two-component vector helper, and theme colours.
* Corrected the fixed `Remember:` label overflow without changing the public command or margin geometry.
* Confirmed clean logs and correct visual output for both helper tests.

### Phase 2 completion

The stable public-interface baseline is now documented and regression-supported. Further architectural changes, new assessment modes, namespace migrations, or companion-package redesign belong to later phases.

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

### Session 4 — Phase 1 LaTeX Workshop workflow

* Added and verified the shared repository-level `.latexmkrc` workflow.
* Added and verified project-local LaTeX Workshop settings.
* Established the mirrored `build/` output structure.
* Verified all four active class architectures.
* Verified combined and standalone vector-workbook builds.
* Verified forward and inverse SyncTeX navigation.
* Verified clean rebuilding, automatic compilation, ChkTeX, and explicit `latexindent` formatting.
* Preserved and excluded the independent modification to `examples/studentnotes/Optics.tex`.

### Session 5 — Phase 2 choices interface

* Completed the usage and compatibility audit of `\choices`, `namedformula`, theorem environments, semantic note boxes, and the `answerkey` environment.
* Confirmed 60 legacy `\choices` calls in the representative physics quiz.
* Confirmed exactly 13 `namedformula` uses in the complete normal-modes source set.
* Identified the unbreakable legacy choices table as the cause of the Question 60 column-overlap defect.
* Added the flexible `choiceoptions` environment.
* Preserved the five-argument `\choices` command as a compatibility wrapper.
* Added a compatibility test covering four-, five-, and six-option questions.
* Reinforced repository class discovery in `.latexmkrc`.
* Verified the compatibility test and representative physics quiz using the controlled `build/` output tree.
* Confirmed that Question 60 now renders without column overlap.
* Left the `answerkey` environment unchanged.
* Preserved and excluded the independent modification to `examples/studentnotes/Optics.tex`.

### Session 6 — Phase 2 named-formula interface

* Audited the existing `namedformula` interface and its confirmed call sites.
* Preserved the required descriptive argument and existing environment syntax.
* Preserved `F<section>.<formula>` numbering and section-based resets.
* Made the descriptive title available to `\nameref` without displaying it.
* Added the `\formularef` command for references matching visible formula tags.
* Added an isolated compatibility test.
* Verified formula numbering, section resets, descriptive-title references, and the absence of unresolved references.
* Left all representative note sources unchanged.
* Preserved and excluded the independent modification to `examples/studentnotes/Optics.tex`.

### Session 7 — Studentnotes theorem and note-box compatibility

* Added an isolated regression test for the existing theorem and note-box interfaces.
* Verified independent theorem, definition, and example counters.
* Verified section-based counter resets and optional headings.
* Verified numeric, automatic, and descriptive cross-references.
* Verified the ordinary appearance of all three semantic note boxes.
* Verified intact rendering at page boundaries.
* Confirmed that no change to `studentnotes.cls` is required.
* Preserved and excluded the independent modification to `examples/studentnotes/Optics.tex`.

### Session 8 — OTScience semantic-box compatibility

* Added isolated regression coverage for all twenty `otscience` semantic-box interfaces.
* Verified default and custom titles.
* Verified breakable and non-splitting pagination behaviour.
* Verified the workbook compatibility layer and practice-box wrappers.
* Rebuilt the standalone and combined vector workbooks successfully.
* Confirmed that no change to `otscience.cls` is required.
* Preserved and excluded the independent modification to `examples/studentnotes/Optics.tex`.

### Session 9 — OTEngineering semantic-box compatibility

* Added regression coverage for the generic `otbox` interface and all fifteen semantic wrappers.
* Verified default and custom titles, colours, and calculation helpers.
* Strengthened the original pagination probes after they proved insufficient.
* Verified intact movement of short boxes and clean splitting of long boxes.
* Rebuilt the representative engineering notebook successfully.
* Confirmed that no change to `otengineering.cls` is required.
* Preserved and excluded the independent modification to `examples/studentnotes/Optics.tex`.

### Session 10 — Public-interface baseline and helper verification

* Documented the supported public interfaces of all four active classes.
* Classified stable author interfaces, advanced hooks, internal details, and package-owned commands.
* Added helper smoke tests for OTEngineering and StudentNotes.
* Detected and corrected the small `\remembernote` label overflow.
* Verified both helper tests with clean logs and visual inspection.
* Completed the residual class and vector-workbook diagnostic corrections.
* Confirmed a clean combined-workbook build.
* Completed Phase 2.

## Next action

Create and verify the final Phase 2 checkpoint commit while excluding:

* `examples/studentnotes/Optics.tex`;
* generated PDFs;
* logs; and
* other build artefacts.

After the checkpoint is verified, begin the next phase defined in `ROADMAP.md`.