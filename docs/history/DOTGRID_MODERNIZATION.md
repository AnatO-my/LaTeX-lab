# Dot-Grid Modernization

## Purpose

This guide records the Phase 9F dot-grid modernization boundary.

The goal is to keep the existing StudentNotes author workflow intact while
making the dot-grid background safer and ready for a lighter image/PDF option.

## Existing Author Command

The existing command still works:

```latex
\usedotgrid
```

It enables the dotted page background. If no image/PDF background path is
configured, StudentNotes uses the original TikZ-drawn grid.

Repeated calls are now harmless. Calling `\usedotgrid` more than once does not
install multiple page backgrounds.

## Opt-In Image/PDF Background

Authors can opt into a prebuilt image or PDF background:

```latex
\setdotgridbackgroundimage{assets/dot-grid-a4.pdf}
\usedotgrid
```

The file path is resolved the same way LaTeX resolves ordinary graphics paths.
If the file is missing, StudentNotes warns and falls back to the original TikZ
dot grid instead of failing the document.

## Current Default

The TikZ grid remains the default fallback.

The image/PDF method is not the default yet. It should become the default only
after timing measurements show a clear benefit and the author-kit packaging
rules include the background asset cleanly.

## Verification Command

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase9f_dotgrid_modernization.ps1
```

In a normal MiKTeX PowerShell environment, the runner compiles:

* the existing `studentnotes_helpers_smoke.tex` fixture; and
* the new image-path fallback fixture.

The normal MiKTeX PowerShell run passed:

```text
All Phase 9F dot-grid modernization checks passed.
```

In this Codex shell, `latexmk` is not visible on `PATH`, so the runner checks
the source contract but skips compile verification here.
