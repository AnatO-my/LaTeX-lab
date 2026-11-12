---
name: latex-build-logs
description: Diagnose LaTeX compilation failures and warnings from compiler or latexmk logs, then propose or implement focused fixes when authorized.
---

# LaTeX Build Logs

Use this skill when a user provides LaTeX, XeLaTeX, LuaLaTeX, BibTeX/Biber, or `latexmk` build output, asks why a LaTeX build failed, or wants help reducing actionable warnings. Do not use it merely to write or restyle LaTeX.

## Diagnose from evidence

1. Establish the build command, engine, output directory, working directory, and main `.tex` file when the available output does not make them clear. Preserve the project's existing recipe and engine unless changing one is the evidenced fix. If no recipe exists, prefer `latexmk` because it manages dependency passes; request `-file-line-error` output when source locations are missing.
2. Read the complete relevant log or the tail around the failure. Search for fatal markers such as `!`, `Emergency stop`, `Fatal error`, `Package ... Error`, `Undefined control sequence`, and `File ... not found`.
3. Identify the **first actionable error**, following included-file paths and `l.<number>` locations back to the source. Later errors are often cascading symptoms.
4. Separate results into:
   - build-stopping errors;
   - warnings that affect output or reproducibility (for example unresolved references/citations, missing fonts, overfull boxes that visibly damage layout, or rerun notices that persist after the required passes);
   - informational/noise messages.

When an error snippet lacks enough context, request the surrounding log lines or inspect the actual log and referenced source if they are in scope. Never invent an error cause from a warning alone.

## Fix safely

- Explain the error, its source location, and the smallest reliable repair before editing.
- Do not modify files unless the user asked for a fix or otherwise authorized source changes. Respect repository instructions and local build conventions.
- Prefer a focused source or dependency correction over suppressing diagnostics globally. Do not hide errors with `-interaction=nonstopmode`, blanket warning suppression, or speculative package additions.
- Treat generated files (`.aux`, `.bbl`, `.bcf`, `.run.xml`, `.toc`, `.out`, and similar) as rebuild artifacts: do not hand-edit them. Recommend an appropriate clean rebuild only when auxiliary state is plausibly stale and the source/configuration is sound.
- For citations and bibliographies, distinguish BibTeX from Biber based on the build configuration and log. Explain required multi-pass work only when the project is not already using `latexmk`; do not recommend switching backend or engine without evidence.
- After an authorized change, rerun the same build (or inspect its fresh log) and report whether the original first error is gone plus any remaining actionable diagnostics.

## Response shape

Lead with the current build status. For each actionable item, give: the log evidence/location, likely cause, exact fix or next check, and whether it requires a rebuild. Keep routine package chatter and harmless rerun notices out of the main diagnosis unless they prevent completion.

