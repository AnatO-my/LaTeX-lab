# Phase 9 Checkpoint 9F - Dot-grid opt-in image path

## Scope

Checkpoint 9F modernizes the StudentNotes dot-grid path conservatively.

The existing TikZ dot-grid remains the default fallback. The checkpoint adds an
opt-in image/PDF background path and makes repeated `\usedotgrid` calls
harmless.

## Added

Phase 9F adds:

```text
tests/run_phase9f_dotgrid_modernization.ps1
tests/studentnotes_dotgrid_image_fallback.tex
docs/DOTGRID_MODERNIZATION.md
```

## Changed

`src/classes/studentnotes.cls` now provides:

```latex
\setdotgridbackgroundimage{<path>}
\usedotgrid
```

If an image/PDF path is configured and the file exists, StudentNotes places that
page-sized graphic as the background. If the file is missing, the class warns
and falls back to the original TikZ dot grid.

The existing `\usedotgrid` command is idempotent: calling it more than once does
not install repeated page backgrounds.

## Verification

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase9f_dotgrid_modernization.ps1
```

Result in this Codex shell:

```text
All Phase 9F source checks passed; run again in normal MiKTeX PowerShell for compile verification.
```

Result in the normal MiKTeX PowerShell environment:

```text
Phase 9F dot-grid modernization report written to build\phase9f-dotgrid-modernization\phase9f_dotgrid_modernization.md
Phase 9F dot-grid modernization JSON written to build\phase9f-dotgrid-modernization\phase9f_dotgrid_modernization.json
All Phase 9F dot-grid modernization checks passed.
```

The Phase 9E TikZ/dot-grid audit was rerun after this change:

```text
All Phase 9E TikZ/dot-grid audit checks passed with 0 warning(s) and 3 note(s).
```

The Phase 9C reliability guard was rerun after adding the 9F runner:

```text
PowerShell runners parsed: 22 / 22
findings: 0
failures: 0
```

## Preserved

Existing documents that only call `\usedotgrid` keep the TikZ fallback path.

The image/PDF method remains opt-in until measurements show it should become
the default and the asset packaging rule is agreed.
