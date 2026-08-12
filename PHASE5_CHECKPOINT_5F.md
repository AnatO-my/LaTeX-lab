# Phase 5 Checkpoint 5F - Governance closure

## Scope

Checkpoint 5F closes Phase 5 without another behavioural extraction.

The implemented Phase 5 architecture is:

* `ottheme.sty` owns the shared OT palette and hyperlink colour policy;
* `otboxes.sty` owns `otscibox` and `otsciboxnosplit`;
* `otcore.sty` owns shared OT class-support setup and page-furniture helpers.

## Version and support policy

The three new Phase 5 packages declare semantic package version `v0.2` in their
`\ProvidesPackage` lines and require:

```latex
\NeedsTeXFormat{LaTeX2e}[2022-06-01]
```

The supported engine remains pdfLaTeX. LuaLaTeX and XeLaTeX are expected to work
but are not claimed until the runners test them directly.

## Phase 5 boundary decision

`physicsquiz.cls` is not modified in Checkpoint 5F. The earlier semantic-version
idea for that class belongs with Phase 6 or a dedicated `physicsquiz` governance
checkpoint, because Phase 5 deliberately changed only the OT shared-design side
and used the Phase 4 suites as an untouched-side guard.

This keeps the closure aligned with the evidence: Phase 5 validates OT shared
packages, not a new public contract for `physicsquiz.cls`.

## Generated PDF policy

Generated PDFs, logs and auxiliary files remain build artifacts, not the source
of truth for Phase 5. The accepted evidence is:

* the source fixtures;
* `tests/ot_baseline_manifest.json`;
* the rendered-text, page-count and diagnostic checks in
  `tests/check_ot_baseline.py`; and
* the standalone package smokes for `ottheme`, `otboxes`, `otpractice`, and
  `otcore`.

Tracked Phase 0 reference artifacts that already exist are not deleted in this
checkpoint, but new generated outputs should not be added as Phase 5 source.

## Acceptance

Checkpoint 5F is accepted when:

1. the new packages carry the agreed kernel floor;
2. `docs/PUBLIC_INTERFACES.md` records the shared package support boundary;
3. `CHANGELOG.md` and `PROJECT_STATE.md` mark Phase 5 complete; and
4. the focused package smokes for `ottheme`, `otboxes`, and `otcore` still
   compile and emit their expected markers.

A final full Phase 5 runner pass is still the strongest end-to-end confirmation
before committing or tagging the phase.

## Verification

The focused verification for the 5F source change passed on 12 August 2026:

* direct MiKTeX `latexmk` smoke checks for `ot_theme_package_smoke.tex`,
  `ot_boxes_package_smoke.tex`, and `ot_core_package_smoke.tex`;
* expected smoke markers were present:
  `OT5B-SMOKE:OTNOTATION`, `OT5B-SMOKE:OTMATH`, `OT5B-SMOKE:OTFIGURES`,
  `OT5C-SMOKE:OTBOXES`, and `OT5E-SMOKE:OTCORE`;
* PowerShell parser checks passed for `run_ot_phase5_tests.ps1` and
  `powershell_log_helpers.ps1`;
* Python syntax compilation passed for `check_ot_baseline.py` using Python 3.13;
* `git diff --check` reported no whitespace errors, only existing CRLF
  normalization warnings.

The full Phase 5 runner passed after Checkpoint 5E. It was attempted again from
this Codex tool path after 5F, but the command exceeded the tool timeout before
returning output. A final normal-shell run of `tests\run_ot_phase5_tests.ps1`
is still recommended before committing or tagging the phase.

## Carry-forward

Phase 6 may decide whether to add a public semantic version macro to
`physicsquiz.cls`, and may retire or quarantine the duplicate legacy quiz once
the visual review of the versioned structured paper is complete.
