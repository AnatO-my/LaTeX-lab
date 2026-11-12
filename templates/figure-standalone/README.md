# Standalone Figure Template

This template allows you to create TikZ figures that compile into perfectly cropped PDFs.

## How to use

1. Copy `figure_template.tex` to your project's `figures/` directory.
2. Rename it (e.g., `vector_diagram.tex`).
3. Add your TikZ code between `\begin{document}` and `\end{document}`.
4. Run the build script:
   ```powershell
   powershell -File scripts/build-figures.ps1 -SourceDir path/to/figures
   ```
5. Include the resulting PDF in your main document:
   ```latex
   \includegraphics{build/figures/vector_diagram.pdf}
   ```

## Benefits

- **Speed:** Only recompile the figure when it changes.
- **Consistency:** Uses the shared `ottheme` for colors.
- **Portability:** The resulting PDF is a standalone vector asset.
