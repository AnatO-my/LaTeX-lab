# Changelog

All notable changes to OT Math will be documented here.

## 0.1.0 - 2026-08-31

- Created local-first repository scaffold.
- Added starter deterministic math engine.
- Added CLI placeholder.
- Hardened Phase 1 engine behavior with expand/factor operations, equation-style solve input,
  structured request dispatch, verification metadata, warnings, parser validation, and CLI
  output-mode coverage.
- Improved Phase 2 CLI workflow with `--no-ai`, `--quiet`, `--version`, command help,
  JSON coverage for every supported command, and documented exit codes.
- Improved Phase 2 CLI formatting with a `latex` command alias, clearer empty-answer
  text output, shell quoting docs, and text-output coverage for supported commands.
- Added opt-in Phase 2 CLI history with JSON Lines output, custom history paths, and
  tests proving history is disabled by default and skipped for failed requests.
- Added Phase 3 structured explanation steps, renderers, and the `otcalc explain`
  command for deterministic solve, simplify, and derivative explanations.
- Added Phase 4 optional AI adapter boundary with `none` and fake providers, provider
  output validation, prompt templates, and redaction helpers without live network calls.
- Added Phase 5 VS Code extension command bridge, command assembly tests, local-only
  settings, and manual QA documentation.
- Added Phase 6 LaTeX generated-snippet helpers, sample document, LaTeX docs, golden
  snippet tests, and optional TeX compile coverage.
- Added Phase 7 CLI configuration discovery, config inspection commands, environment
  overrides, local privacy defaults, and config-driven history behavior.
- Added Phase 8 CI workflow for Python lint/type/test/package build and VS Code
  extension npm tests, plus expanded release/versioning documentation.
- Added Phase 9 systems-of-equations domain with public API, CLI command, docs, and
  verification by substitution across every equation.
- Added Phase 10 beta-readiness docs for getting started, known limitations, community
  triage, and example gallery workflows.
- Added safe LaTeX document generation with `otcalc latex-build`, `\OTMathCompute`,
  and `\OTMathExplain` authoring macros.
- Added manual QA checklist for VS Code Extension Host and LaTeX PDF review.
- Added starter LaTeX-style input support for `otcalc latex-build` document requests.
- Added starter LaTeX variable normalization for common Greek symbols and simple
  subscripted variables.
- Added a LaTeX stress document for current hard cases and upcoming parser targets.
- Added VS Code LaTeX on-save refresh and document commands that preserve custom
  generated include paths.
- Added safe generated-include loading and CLI detection of declared generated include
  paths.
- Improved factorization to split complex factors such as `x**4 - 1`.
- Added starter SymPy-backed operations for summation, products, limits, and inequalities.
- Added starter numeric solving, descriptive statistics, and unit conversion domains.
- Added matrix operations for order, determinant, rank, trace, inverse, powers, transpose,
  conjugate, adjoint, RREF, solving, spaces, eigen data, diagonalization, and
  decompositions.
- Added styled LaTeX result blocks for generated document output.
- Polished the VS Code beta bridge with a supported-operation picker and stronger
  diagnostics, including a local CLI version probe.
- Added project phases and Codex phase prompts.
- Added documentation, governance files, templates, and integration placeholders.
