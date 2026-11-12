# Engineering registry compatibility checkpoint

Date: 2026-09-28. Scope: repairs to the existing engineering class and forms package before creating ot-projects.sty. No new project package is introduced.

## Supported author syntax
The original title-only syntax remains valid, including bodies beginning with a command or a braced group:

    \begin{decision}[Optional title]
      Decision text.
    \end{decision}

Status is now a second OPTIONAL bracket argument:

    \begin{decision}[Battery Type][Resolved]
      Using Li-Po for weight savings.
    \end{decision}

The same syntax applies to risk. To use the default title with a status, supply the default title explicitly. An omitted/empty status produces no margin marker and is printed as "Not specified" in the register.

The unreleased local form \begin{decision}[Title]{Status} must be changed to \begin{decision}[Title][Status]. Treating a braced group as an optional status would steal a valid legacy body, so automatic compatibility with that ambiguous local syntax is deliberately avoided. The local example and manual have been migrated.

## Register lifecycle
Decision/risk lists use the previous completed run. They can be printed before or after records and printed multiple times. Each entry is written once from inside its box; the page value is evaluated at shipout. The class reads completed files before opening new output streams and flushes pending pages before closing them.

Build until registers and references settle (normally at least two runs; front-matter pagination can take more). Removing records needs another run to clear stale displayed entries. An empty register prints an explicit message. Do not treat a first-pass PDF as the final report.

The .decisions and .risks files are generated TeX sidecars; distribute sources and rebuild, rather than treating them as authoritative project data. Titles/status may use ordinary text and robust formatting commands. These registers are summaries, not a general-purpose database.

## Explicit optional dependencies
otengineering uses its declared core dependencies. It does not auto-load otprofiles or otforms based on file availability. Documents requesting these features must load them explicitly, for example:

    \documentclass{otengineering}
    \usepackage[mode=draft,print=true]{otprofiles}
    \usepackage{otforms}

Tested baseline: local otengineering v0.3 (2026-09-28), otforms v0.2 (2026-09-28), otcore/ottheme v0.2, optional local otprofiles v0.3, MiKTeX pdfTeX 4.26 / MiKTeX 26.2. This checkpoint does not claim LuaLaTeX validation.

## Forms
The documented interface is \otchoicefield{label}{name}{choices}, e.g.:

    \otchoicefield{Assigned Site}{site_choice}{Site A,Site B,Site C}

All form helpers preserve literal field identifiers, including underscores. Use plain literal identifiers rather than LaTeX formatting/macros for names. The multiline field uses the current line width and avoids paragraph indentation. Forms remain interactive; use a PDF viewer with AcroForm support.

## Regression checks
Prerequisites: Python with pypdf, and an installed pdfLaTeX with the repository's TeX dependencies. Existing MiKTeX packages are used; no new TeX installation is required.

Run from PowerShell:

    ./tests/run_engineering_tests.ps1 -PdfLatex pdflatex -Python python

Or just check forms:

    ./tests/run_forms_tests.ps1 -PdfLatex pdflatex -Python python

Both accept explicit executable paths and an optional OutputDirectory. By default a new build directory is created so stale artifacts cannot mask failure. The driver stops on compilation failure, limits each compiler call, and checks convergence rather than counting file existence.

Coverage: legacy command/word/group bodies, front/back and repeated registers, moved boxes and actual page numbers, multi-page records, entry deletion, empty registers, formatted titles/status, existing starter and compatibility examples, explicit companion loading, dropdown label/options, field identifiers and PDF widget names. Visual review includes headers, page-boundary boxes, continued records and interactive forms.

The fixed header bounds long section headings to prevent overlap with the notebook title. Project-dashboard tables use available line width.

## Next step
After this prerequisite checkpoint, design ot-projects.sty as an additive package for requirements, BOM/costs, personnel, stages and test traceability. Do not duplicate the existing decision/risk/assumption/lesson interfaces.

