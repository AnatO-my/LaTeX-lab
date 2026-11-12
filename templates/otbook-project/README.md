# Personal Book Project

Copy this whole folder for each new book. Keep LaTeX-lab as the shared class
and package source, and edit your book content in the copied project.

## Files

```text
personal-book/
  .latexmkrc
  .gitignore
  main.tex
  chapters/
    01-introduction.tex
  figures/
  bibliography/
  build/                  (created by latexmk; ignored by Git)
    aux/
    pdf/
      main.pdf
```

`main.tex` owns the title, chapter order, and front/main/back matter. Each
chapter file contains only chapter content, without a document preamble or
`\begin{document}`. Add chapters with further `\input{chapters/<name>}` lines
before `\backmatter`. Numbered appendices also go before `\backmatter`.

Use `\makeotbookdedication{...}` in the commented location in `main.tex`,
before PDF page anchors are enabled. In a chapter file,
`\otbookepigraph{<quotation>}{<attribution>}` can frame a chapter and
`chapteroverview` can state its purpose before `chaptergoals`.

`figures/` is on the graphic search path. `bibliography/` is reserved for your
reference files; no bibliography package, backend, or citation style is
enabled yet. The `.gitkeep` files preserve empty source folders in Git.

## Connect to LaTeX-lab

Use MiKTeX with `latexmk` and pdfLaTeX available in your shell. The OT class
and its packages stay in LaTeX-lab; copying only `otbook.cls` is insufficient.

Inside LaTeX-lab's `templates/otbook-project/`, the default `../..` pointer
works. After copying the folder to `Current-projects/personal-book/`, edit
this line in the copied `.latexmkrc` to use your actual LaTeX-lab path:

```perl
my $latex_lab = $ENV{'LATEX_LAB_ROOT'} || 'C:/path/to/LaTeX-lab';
```

Use forward slashes in that Perl path. Alternatively, set the environment
variable in PowerShell before building, without editing the file:

```powershell
$env:LATEX_LAB_ROOT = 'C:/path/to/LaTeX-lab'
```

The environment variable takes precedence. This PowerShell assignment lasts
for the current shell; setting the path in `.latexmkrc` persists with the
project. The configuration reports a clear error if the selected folder does
not contain the expected class and package directories.

## Build

Open a shell in this project's folder, beside `main.tex`, and run:

```powershell
latexmk -pdf main.tex
```

Open `build/pdf/main.pdf`. Auxiliary files go under `build/aux/`; the PDF and
its SyncTeX file go under `build/pdf/`. Always build `main.tex`, not an
individual chapter. When testing the template inside LaTeX-lab, enter this
folder first so latexmk reads this configuration rather than the repo's.

To remove auxiliary build files while keeping the PDF:

```powershell
latexmk -c main.tex
```

To remove the PDF and generated build files as well:

```powershell
latexmk -C main.tex
```

The template temporarily disables PDF page anchors for its title and optional
dedication pages, then turns them on for the contents. Keep that sequence to
avoid duplicate title-page destinations.

The class loads its OT companion packages when available. Its semantic boxes
are unnumbered; `otmath` keeps its section-based theorem counters. Consult
LaTeX-lab's `docs/PUBLIC_INTERFACES.md` for the current book interface.

Keep one project folder per book. Record the LaTeX-lab commit used for a
finished edition, since later changes to the shared styling can affect builds.
Copy source files when starting the next project, leaving any existing
`build/` folder behind.
