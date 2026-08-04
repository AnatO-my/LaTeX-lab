# Changelog

This file records significant changes to the LaTeX Workspace Learning and Class Refactoring Project.

## Phase 2 — Semantic and flexible document interfaces

**In progress: 4 August 2026**

### Added

- Added the semantic `choiceoptions` environment to `physicsquiz.cls`.
- Added support for an arbitrary number of alphabetically labelled options.
- Added `tests/physicsquiz_choices_compatibility.tex`.
- Added repository-level class discovery to `.latexmkrc`.
- Added `\formularef` for references matching visible named-formula tags.
- Added `tests/studentnotes_namedformula_compatibility.tex`.

### Changed

- Reimplemented the five-argument `\choices` command as a backward-compatible wrapper around `choiceoptions`.
- Replaced the unbreakable options table with a semantic list-based interface.
- Retained the required `namedformula` title as reference metadata.
- Enabled descriptive formula-title references through `\nameref`.
- Preserved the existing hidden-title appearance and environment syntax.

### Fixed

- Fixed the Question 60 layout defect in the representative physics quiz.
- Prevented the complete option block from overlapping content in the following column.

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
