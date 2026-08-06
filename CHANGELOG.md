# Changelog

This file records significant changes to the LaTeX Workspace Learning and Class Refactoring Project.

## Phase 3 — One source, multiple assessment outputs

**Completed: 6 August 2026**

### Added

- Added mutually exclusive `full`, `student`, `teacher`, `solutions`, and
  `answerkey` primary output modes to `physicsquiz.cls`.
- Added five semantic section gates: `quizquestioncontent`,
  `quizanswerkeycontent`, `quizsolutioncontent`, `quizteachercontent`, and
  `quizreferencecontent`.
- Added independent `colour` and `print` presentation modes, with `color` as an
  alias for `colour`.
- Added `\quizversion{<label>}` for visible version metadata.
- Added the display-only `\quizmarks{<value>}` and
  `\quizdifficulty{<label>}` question hooks.
- Added a shared synthetic assessment fixture and separate drivers for every
  primary output mode.
- Added colour/print matrix tests, Version A/B tests, option-state assertions,
  and deliberate conflict tests.
- Added `tests/check_physicsquiz_output_modes.py` for exact semantic-marker
  verification.
- Added `tests/run_physicsquiz_phase3d_tests.ps1` as the repository-local
  Phase 3 verification runner.

### Changed

- Preserved `full,colour` as the no-option default.
- Continued forwarding non-`physicsquiz` options such as `12pt` and `a4paper`
  to `article`.
- Mapped the public quiz palette to high-contrast greys in `print` mode and
  hid hyperlink decoration.
- Extended the title page and running header to show version metadata only
  when supplied.
- Defined marks as visible in `full`, `student`, and `teacher` outputs.
- Defined difficulty as visible in `full` and `teacher` outputs.
- Documented the new Phase 3 public interfaces and their compatibility
  boundaries.

### Preserved

- Preserved the existing metadata commands, `quizquestions`, `choiceoptions`,
  legacy five-argument `\choices`, `answerkey`, and public colour names.
- Preserved the established default visual output.
- Left the representative 60-question quiz source unchanged and requiring no
  immediate migration.
- Kept answer-key contents manually authored; automatic answer collection was
  not introduced.
- Preserved and excluded the independent modification to
  `examples/studentnotes/Optics.tex`.

### Verified

- Verified all 21 positive Phase 3D drivers in the repository-local MiKTeX
  environment.
- Verified all ten semantic colour/print combinations against the exact content
  matrix.
- Verified that both conflicting-primary-mode and conflicting-presentation-mode
  tests fail with their intended class errors.
- Verified default and explicit colour state, the `color` alias, and explicit
  print state.
- Verified Version A and Version B output.
- Verified marks and difficulty visibility in every primary mode.
- Verified pass-through article options.
- Verified positive logs without LaTeX warnings, overfull boxes, or underfull
  boxes.
- Verified the unchanged Phase 2 choices compatibility output.
- Verified the representative quiz's accepted 23-page default rendering, with
  Question 60 and all five choices together.

### Deferred

- Structured question records and question-bank storage.
- Automatic answer-key generation and mark-total calculation.
- Question selection, filtering, reordering, randomisation, and choice shuffling.
- Version-dependent question assignment.
- Comparison of a lightweight custom architecture with `xsim`.
- Migration of the representative 60-question quiz.

## Phase 2 — Semantic and flexible document interfaces

**Completed: 5 August 2026**

### Added

- Added the semantic `choiceoptions` environment to `physicsquiz.cls`.
- Added support for an arbitrary number of alphabetically labelled options.
- Added `tests/physicsquiz_choices_compatibility.tex`.
- Added repository-level class discovery to `.latexmkrc`.
- Added `\formularef` for references matching visible named-formula tags.
- Added `tests/studentnotes_namedformula_compatibility.tex`.
- Added `docs/PUBLIC_INTERFACES.md`, documenting the supported interfaces of all four active classes.
- Added `tests/otengineering_helpers_smoke.tex`.
- Added `tests/studentnotes_helpers_smoke.tex`.

### Changed

- Reimplemented the five-argument `\choices` command as a backward-compatible wrapper around `choiceoptions`.
- Replaced the unbreakable options table with a semantic list-based interface.
- Retained the required `namedformula` title as reference metadata.
- Enabled descriptive formula-title references through `\nameref`.
- Preserved the existing hidden-title appearance and environment syntax.
- Documented stable author interfaces, advanced ecosystem hooks, implementation boundaries, defaults, compatibility guarantees, and namespace risks.
- Added explicit `\autoref` names for definitions and examples where required.
- Reduced the fixed `Remember:` margin-note label slightly so that it fits within the established margin width.
- Replaced the ineffective `silence`-based `physics`–`siunitx` warning filter with the native message redirection.
- Corrected the shared workbook setup and all seven modules without changing their intended mathematical content or visual identity.

### Fixed

- Fixed the Question 60 layout defect in the representative physics quiz.
- Prevented the complete option block from overlapping content in the following column.
- Fixed the `\remembernote` label overflow detected by the StudentNotes helper test.
- Fixed the workbook header-height warning.
- Fixed the recorded overfull lines in the combined workbook.
- Fixed malformed PDF-bookmark warnings caused by mathematical formatting in headings.
- Replaced deprecated `siunitx` settings.
- Removed redundant warning-suppression configuration.

### Verified

- Verified all 60 existing legacy `\choices` calls without source migration.
- Verified four-option, five-option, and six-option questions.
- Verified mathematical and prose options.
- Verified the representative quiz using the controlled `build/` output.
- Confirmed that the answer-key table remains correct.
- Confirmed that `examples/studentnotes/Optics.tex` remains separate from Phase 2.
- Verified `F<section>.<formula>` numbering.
- Verified formula-counter resets between sections.
- Verified `\formularef` output.
- Verified descriptive-title references through `\nameref`.
- Verified that formula titles remain visually hidden.
- Verified that the final build contains no unresolved references.
- Verified independent numbering and section-based resets for `theorem`, `definition`, and `example`.
- Verified headed and unheaded theorem rendering.
- Verified `\label`, `\ref`, `\nameref`, and `\autoref` behaviour.
- Verified the established appearance of `quicknote`, `personalnote`, and `importantnote`.
- Verified intact note-box rendering at page boundaries.
- Confirmed that the existing theorem and note-box definitions require no changes.
- Verified the documented public-interface declarations against the canonical class sources.
- Verified OTEngineering metadata, dashboard, sketch, status, rating, field, and theme helpers.
- Verified StudentNotes metadata, dotted background, margin-note, `WithArrows`, vector, and theme helpers.
- Confirmed that both helper smoke-test logs contain no matching warnings or errors.
- Visually confirmed both helper-test PDFs.
- Verified the corrected combined vector workbook with a clean build.

### Deferred

- Changes to the `answerkey` environment.
- Multiple assessment-output modes and question-bank metadata.

## Phase 1 — LaTeX Workshop workflow

**Completed: 4 August 2026**

### Added

- Added a repository-level `.latexmkrc`.
- Added project-local LaTeX Workshop settings in `.vscode/settings.json`.
- Added project-local discovery paths for classes under `src/classes`.
- Added project-local discovery paths for packages under `src/packages`.
- Added a controlled and mirrored `build/` output structure.
- Added `tests/otscience_boxes_compatibility.tex`.
- Added `tests/otengineering_boxes_compatibility.tex`.

### Configured

- Configured `latexmk` to build directly with pdfLaTeX.
- Configured SyncTeX generation and file-and-line diagnostics.
- Configured nested root documents to build from their own directories.
- Configured automatic compilation when a LaTeX source is saved.
- Configured ChkTeX linting on save.
- Configured `latexindent` as the explicit LaTeX formatter.
- Disabled automatic formatting on save for LaTeX documents.
- Disabled automatic mathematical-delimiter and quotation rewriting.
- Retained LaTeX Workshop’s internal PDF viewer.

### Verified

- Verified command-line builds from PowerShell.
- Verified LaTeX Workshop builds using the shared `.latexmkrc`.
- Verified controlled output directories for nested example projects.
- Verified combined and standalone compilation of the modular vector workbook.
- Verified standalone builds for all four active class architectures.
- Verified forward and inverse SyncTeX navigation.
- Verified clean rebuilding through LaTeX Workshop.
- Verified automatic compilation on save.
- Verified ChkTeX 1.7.9 integration.
- Verified `latexindent` 4.0 integration.
- Confirmed that `% !TeX root` directives are unnecessary for the existing dual-root workbook architecture.
- Verified all breakable and non-splitting `otscience` semantic-box interfaces.
- Verified default and custom semantic-box titles.
- Verified established box colours and visual appearance.
- Verified clean splitting of breakable boxes across pages.
- Verified intact page-boundary movement of `nosplit` boxes.
- Verified compatibility with the fallback definitions in `00_common_setup.tex`.
- Verified the `practicebox` and `practiceboxnosplit` workbook wrappers.
- Verified successful standalone and combined vector-workbook builds.
- Confirmed that the existing `otscience` box definitions require no changes.
- Verified the generic `otbox` interface and all fifteen semantic wrappers.
- Verified default and custom semantic-box titles.
- Verified established colours and visual appearance.
- Verified the `calculation` environment and `\calcfield` command.
- Verified intact page-boundary movement of short boxes.
- Verified clean continuation of long breakable boxes across pages.
- Verified the representative `otengineering` notebook build.
- Confirmed that the existing box definitions require no changes.

### Preserved

- No class, package, or example-document source was changed as part of Phase 1.
- Existing visual output and document interfaces were preserved.
- The separate modification to `examples/studentnotes/Optics.tex` was excluded from Phase 1.

## Phase 0 — Baseline audit and safety

### Established

- Established the canonical repository structure.
- Inventoried the four active classes and seven OT companion packages.
- Preserved representative sources, PDFs, and diagnostic logs.
- Audited public interfaces, dependencies, known warnings, and layout defects.
- Created the initial Git baseline.
- Tagged the baseline as `phase-0-baseline`.
