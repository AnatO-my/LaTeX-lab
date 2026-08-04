# Changelog

This file records significant changes to the LaTeX Workspace Learning and Class Refactoring Project.

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
