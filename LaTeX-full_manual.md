# LaTeX Lab Full Manual

## Purpose and Scope

This is the practical reference for the three connected local projects:

| Suite                   | Location                              | Role                                                                                                                 |
|-------------------------|---------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| LaTeX-lab               | This repository                       | Document classes, OT styling packages, starters, templates, build and release workflow.                              |
| OT Book                 | `src/classes/otbook.cls` in LaTeX-lab | A chaptered personal-book class built on LaTeX's native `book` class.                                                |
| OT Calculator / OT Math | Adjacent `Ot-Calculator` repository   | Local-first deterministic mathematics engine, CLI, Python API, VS Code bridge, and LaTeX pre-generation integration. |

The suites complement one another. LaTeX-lab owns how a document is structured
and styled. OT Math owns deterministic calculation, verification, explanation,
and generated LaTeX snippets. A normal LaTeX compilation does not execute OT
Math; calculation is intentionally a separate pre-generation step.

## Start Safely

Keep LaTeX-lab as the shared source of classes and packages. Create one project
folder per independent document or book. Do not copy generated `build/` output,
PDFs, logs, or auxiliary files into a new project.

For ordinary repository examples, build from the LaTeX-lab root:

```powershell
latexmk -pdf examples\otbook\starter_personal_book.tex
```

For an independent book, copy `templates/otbook-project/` into
`Current-projects/<book-name>/`, set `LATEX_LAB_ROOT` or edit its `.latexmkrc`,
then build its root file:

```powershell
$env:LATEX_LAB_ROOT = 'C:/Users/Ot/OneDrive/Documents/LaTeX/LaTeX-lab'
latexmk -pdf main.tex
```

That template puts logs and auxiliary files in `build/aux/`, and the PDF plus
SyncTeX file in `build/pdf/`. Edit `main.tex` and files under `chapters/`; do
not compile a chapter file on its own.

The supported baseline is Windows, MiKTeX, `latexmk`, and pdfLaTeX. The shared
OT packages require LaTeX2e 2022-06-01 or newer. LuaLaTeX and XeLaTeX may work,
but are not yet part of the regression-tested support claim.

## LaTeX-lab Components

### Classes: Choose the Document Shape First

| Class           | Best for                              | Base shape | Main capability                                                            |
|-----------------|---------------------------------------|------------|----------------------------------------------------------------------------|
| `otbook`        | Personal books, long notes, handbooks | `book`     | Native parts, chapters, front/main/back matter.                            |
| `otscience`     | Scientific notes and explanations     | `article`  | Semantic science boxes and OT math/physics helpers.                        |
| `studentnotes`  | Study notes and revision packs        | `article`  | Course metadata, theorem/formula tools, margin notes, arrows.              |
| `otengineering` | R&D or engineering notebooks          | `article`  | Project dashboard, decision/risk/experiment records, sketch placeholders.  |
| `physicsquiz`   | Tests, quiz banks, answer keys        | `article`  | Structured questions, versions, deterministic selection, shuffled choices. |

Use exactly one OT class with `\documentclass{...}`. Do not load another OT
class as a package. The classes deliberately share colour names and some box
names, so mixing class implementations is a collision risk.

### Shared Packages: The OT Building Blocks

| Package         | Provides                                                                                                                           |
|-----------------|------------------------------------------------------------------------------------------------------------------------------------|
| `otcore`        | One-inch margins, section styling helpers, page furniture, list defaults.                                                          |
| `ottheme`       | Shared OT palette: `OTBlue`, `OTPurple`, `OTGreen`, `OTTeal`, `OTOrange`, `OTRed`, `OTYellow`, `OTDark`, `OTMuted`, and `OTLight`. |
| `otboxes`       | `otscibox` and `otsciboxnosplit`, the advanced generic foundations behind semantic boxes.                                          |
| `otnotation`    | Vector, tensor, basis, calculus, delimiter, and semantic emphasis notation.                                                        |
| `otmath`        | Theorems and mathematical helper commands, including vector-calculus identities.                                                   |
| `ottensors`     | Tensor index and component notation helpers.                                                                                       |
| `otphysics`     | Mechanics, electromagnetism, thermodynamics, and relativity formula helpers.                                                       |
| `otcoordinates` | Cartesian/cylindrical/spherical coordinate, scale-factor, metric, gradient, divergence, and curl helpers.                          |
| `otpractice`    | Practice, recall, drill, and exam-question helpers.                                                                                |
| `otfigures`     | TikZ-based coordinate, vector, stress, and field figure helpers.                                                                   |
| `otcircuits`    | Electrical schematic helpers using `circuitikz` with OT styling.                                                                  |
| `otplots`       | Data and function plotting using `pgfplots` with OT styling and color cycles.                                                     |
| `otcode`        | Code listings and algorithm documentation with OT-branded syntax highlighting.                                                    |
| `otsymbols`    | Centralized symbol and nomenclature management with unique-key collision handling.                                                |
| `otprofiles`   | Multi-target build system (Student, Instructor, Print, Draft) with conditional content and color optimization.             |
| `otbib`        | Standardized research citations using `biblatex` and `biber` with OT-branded callouts.                                     |
| `otindex`      | Modern 3-column indexing for textbooks and laboratory handbooks.                                                           |
| `otforms`      | Interactive fillable PDF forms for engineering field reports and digital checklists.                                       |
| `otaccess`     | PDF accessibility metadata and structural tagging pilot for high-compliance documents.                                     |
| `otreproduce`  | Integration with **Ot-Calculator** for deterministic mathematics and data-driven documentation.                            |

Ordinary documents should use their class's semantic interfaces. Use the shared
packages directly only when making a companion package, a reusable wrapper, or
an intentionally custom class-level integration.

### OT Book Suite (`otbook` v0.2)

`otbook` is for material that genuinely needs chapters. Unlike `otscience`, it
uses LaTeX's normal `book` mechanics: `\part`, `\chapter`, `\frontmatter`,
`\mainmatter`, `\appendix`, `\backmatter`, and the table of contents retain
their native roles. Options are passed through to `book`:

```latex
\documentclass[12pt]{otbook}
```

The title metadata is:

```latex
\title{Title}
\booksubtitle{Optional subtitle}
\author{Author}
\bookedition{Draft edition}
\date{\today}
```

Render the OT title page with `\makeotbooktitle`. `\maketitle` still exists,
but does not render the OT subtitle or edition. Use this safe front-matter
sequence so PDF destination names remain unique:

```latex
\frontmatter
\hypersetup{pageanchor=false}
\makeotbooktitle
\makeotbookdedication{For the people who made this possible.} % Optional
\hypersetup{pageanchor=true}
\tableofcontents
```

Book-specific options and helpers:

| Interface                                 | Use                                                                                               |
|-------------------------------------------|---------------------------------------------------------------------------------------------------|
| `\documentclass[chaptertheorems]{otbook}` | Opts into chapter-based numbering for theorems and equations (e.g., 1.1 instead of 1.1.1).        |
| `\makeotbookdedication{<text>}`           | Creates an optional unnumbered dedication page.                                                   |
| `\otbookepigraph{<quote>}{<attribution>}` | Adds a compact right-aligned chapter quotation; no counter, contents entry, or forced page break. |
| `chapteroverview`                         | A breakable teal prose box for the context and destination of a chapter.                          |
| `chaptergoals`                            | A breakable blue box that owns an `itemize` list for chapter goals.                               |
| `reflectionbox`                           | A breakable orange box for a personal connection, caveat, or note to self.                        |
| `designrule`                              | A breakable purple box for engineering or design principles.                                      |
| `\otremark{<text>}`                       | A blue informative margin note.                                                                   |
| `\otcaveat{<text>}`                       | An orange warning or personal connection margin note.                                              |
| `\otsideinfo{<text>}`                     | A dark/muted reference or symbol explanation margin note.                                         |
| `\otpracticehint{<text>}`                 | A teal practice or recall cue margin note.                                                        |

Use an opening sequence such as:

```latex
\chapter{Foundations}
\otbookepigraph{The work begins by naming the question.}{Author}
\begin{chapteroverview}
  State what this chapter covers, what it deliberately excludes, and where it
  will take the reader.
\end{chapteroverview}
\begin{chaptergoals}
  \item Establish the core principle.
  \item Work one complete example.
\end{chaptergoals}
```

The semantic OT box families are also available: `definitionbox`, `theorembox`,
`lawbox`, `formulabox`, `derivationbox`, `examplebox`, `warningbox`,
`intuitionbox`, `summarybox`, and `experimentbox`. Each has an optional title
and a `nosplit` variant. Use breakable boxes for substantial
content and `nosplit` only for short material that must remain visually intact.

`otbook` conditionally loads the notation, math, tensor, physics, coordinates,
practice, and figures packages when they are available. Distribute the complete
`src/classes/` and `src/packages/` trees; copying `otbook.cls` alone is not a
complete installation. The class does not yet choose a bibliography backend,
index, glossary, print mode, or chapter-numbered theorem policy.

### Science and Student Notes

`otscience` provides the same ten semantic science box families and their
`nosplit` counterparts in an article-shaped document. It is the right choice
for a paper-like note where `\section` is the top-level structure. Its shared
packages make notation such as `\vect{v}`, `\ihat`, `\NewtonSecond`, and
`\curlgradzero{\phi}` available when the corresponding companion package is
present. `\qty` is deliberately restored to the `siunitx` meaning at document
start; use `\quantity` for the `physics` delimiter operation.

`studentnotes` adds an author-facing note title and metadata layer, semantic
note environments, theorem interfaces, named formula tools, margin-note
commands, `WithArrows` helpers, and vector helpers. Choose it when the document
is primarily a revision resource, teaching note, or annotated learning pack.
Its dedicated starter is `examples/studentnotes/starter_notes.tex`.

### Engineering Notebook Suite

`otengineering` is a practical record-keeping class. Define project metadata
with `\projectname`, `\projectid`, `\projectversion`, `\projectstatus`,
`\projectcategory`, `\projectstarted`, and `\projectupdated`, then render it
with `\makeotengtitle` or `\makeprojectdashboard`.

Its semantic environments are designed for thinking in public to your future
self: `idea`, `questionbox`, `decision`, `experiment`, `failure`, `discovery`,
`lesson`, `futurememo`, `thought`, `rabbithole`, `researchqueue`, `wisdom`,
`risk`, `assumption`, and `calculation`. Use `\calcfield{Label}{Value}` for a
calculation record, `\sketchbox[6cm]{Description}` for a visual placeholder,
and helpers such as `\entrydate`, `\context`, `\observation`, `\reason`,
`\tradeoff`, and `\nextstep` for repeatable field capture. Status labels range
from `\statusseed` through `\statusarchived`; rating helpers capture success,
confidence, and whether an idea is worth pursuing.

### Physics Quiz Suite

`physicsquiz` is the assessment engine. It separates primary output mode from
presentation mode, supports regular question markup and a structured question
bank, can produce answer keys and solutions, and provides deterministic
selection and choice shuffling. Its author-facing configuration includes course
and assessment metadata, instructions, question labels, answer-key material,
and version manifests.

The structured bank is the high-leverage interface: declare a `quizbank`, add
`quizquestion` records and optional `quizsolution` material, then select by
identifier, tags, seed, or version. This supports a single source of questions
that can produce student papers, answer keys, solutions, and teacher/reference
outputs without manually maintaining copies. Start with
`examples/physicsquiz/starter_quiz_bank.tex` or
`examples/physicsquiz/starter_versioned_quiz.tex` rather than a historical
course paper.

### Vector Workbook and Other Starters

The vector workbook has a standalone module starter and a combined-workbook
root. Its shared `00_common_setup.tex` owns the common arrangement; keep that
file beside the combined root when copying the pattern. LaTeX-lab also provides
true starters for science notes, engineering notes, student notes, and quizzes.
Use `docs/STARTER_INVENTORY.md` to distinguish current starters from larger
representative examples.

## OT Calculator / OT Math Suite

OT Math is a local-first, SymPy-backed deterministic calculator. It is not a
cloud service and does not require AI. The default provider is `none`, privacy
mode is `local`, and history is disabled unless explicitly enabled.

### What It Calculates

| Domain      | CLI operations                                                                                                                                                                                                                        |
|-------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Algebra     | `solve`, `simplify`, `expand`, `factor`                                                                                                                                                                                               |
| Calculus    | `diff`, `integrate`, `sum`, `product`, `limit`, `inequality`, `nsolve`                                                                                                                                                                |
| Systems     | `system` for symbolic equations separated by semicolons                                                                                                                                                                               |
| Statistics  | `mean`, `median`, `variance`, `stdev`                                                                                                                                                                                                 |
| Units       | `unit` for curated length, time, mass, force, energy, and power units                                                                                                                                                                 |
| Matrices    | `det`, `order`, `rank`, `trace`, `inverse`, `norm`, `cond`, `mpow`, `transpose`, `conjugate`, `adjoint`, `rref`, `msolve`, `nullspace`, `columnspace`, `rowspace`, `eigenvals`, `eigenvectors`, `diagonalize`, `lu`, `qr`, `cholesky` |
| Explanation | `explain` emits structured deterministic steps for a chosen operation                                                                                                                                                                 |

Typical CLI use:

```powershell
otcalc solve "x**2 - 5*x + 6 = 0"
otcalc system "x + y = 5; x - y = 1" --variable "x,y"
otcalc diff "sin(x)" --format latex
otcalc unit "10*meter/second" --variable "kilometer/hour"
otcalc rref "[[1, 2], [3, 4]]"
otcalc explain "x**2 - 5*x + 6 = 0" --operation solve --format latex
```

CLI input is engine syntax: powers use `**`, multiplication is explicit with
`*`, and expressions should be quoted. `solve` accepts an expression treated
as zero or a single equation with `=`. `nsolve` requires `--variable
"x,initial_guess"` and returns one converged solution near that initial guess.
`variance` and `stdev` use sample mode by default; pass `--variable population`
for population values. Matrix input uses literals such as `[[1, 2], [3, 4]]`;
matrix solving uses `A; b`.

Every calculation yields a structured `MathResult`: operation, input,
variable, answers, LaTeX, verification status, warnings, deterministic steps,
and metadata. JSON output preserves all of that data. Verification is operation
specific: solutions are substituted back, integrals are differentiated, and
simplify/expand/factor results are checked for expression equivalence.

The public Python API is `otmath`. Use `run_request(MathRequest(...))` for a
general integration or direct functions such as `solve_expression`,
`differentiate_expression`, `matrix_rref`, `solve_system`, and `convert_units`.

### Calculator Configuration and Privacy

Configuration is optional. Discovery order is `--config`, `OTMATH_CONFIG`, a
local `.otmath.json`, then the per-user configuration file. Available settings
include `provider`, `privacy_mode`, `history`, `history_file`, and `quiet`.
Only local mode and `provider: "none"` are implemented in the current scaffold.

Use `--history` only when you intentionally want successful `MathResult`
records written to a local JSON Lines file. AI provider interfaces exist as an
extension boundary, but deterministic engine execution remains authoritative.

### OT Math LaTeX Integration

The safe workflow is pre-generation. Put request markers in a trusted document,
run `otcalc latex-build` before LaTeX compilation, and let LaTeX only read the
generated include. There is no shell escape requirement.

```latex
\input{C:/Users/Ot/OneDrive/Documents/LaTeX/Ot-Calculator/integrations/latex/otmath.sty}
\OTMathGeneratedInput{generated/otmath-results.tex}

\OTMathCompute[input=latex]{roots}{solve}{x^{2} - 5x + 6 = 0}
\OTMathCompute[input=latex; variable=x,y]{system}{system}{x + y = 5; x - y = 1}
\OTMathExplain[input=latex; operation=differentiate]{derivative}{\frac{d}{dx}\left(\sin{x}\right)}
```

Then run:

```powershell
otcalc latex-build main.tex
latexmk -pdf main.tex
```

If the document declares `\OTMathGeneratedInput{generated/name.tex}`, the
builder writes to that path; otherwise it uses `generated/otmath-results.tex`
next to the root `.tex` file. `otcalc latex-build main.tex --compile` can run
the local LaTeX engine after generation. A normal `latexmk` command never
recalculates requests; it uses the most recently generated result file.

Key rendering helpers are `\OTMathInline`, `\OTMathResult`, `\OTMathEquation`,
`\OTMathUse{id}`, `\OTMathUsePlainResults`, `\OTMathUseStyledResults`,
`OTMathSteps`, and `\OTMathStep`. `\OTMathCompute` and `\OTMathExplain` are
markers that resolve through the generated include. When the 'include' is absent,
the document still compiles and shows placeholder warnings instead of silently
claiming a result.

With `input=latex`, OT Math accepts a documented starter subset of natural
LaTeX: powers, implicit multiplication, fractions, roots, common functions,
standard inverse trig functions, Greek and simple subscript variables,
derivatives, indefinite integrals, sums, products, limits, inequalities,
matrix environments, and `\pm`/`\mp` branch expansion. Unsupported syntax is
rejected rather than guessed. Complex aliases and elaborate subscript schemes
are deliberately outside the current adapter.

## Cross-Suite Superpowers

### 1. A Reproducible Calculated Book

Use `otbook` to hold the argument and OT Math to generate the calculations.
Keep requests in a chapter file, generate once from the project root, and build
normally. The result is a chapter-ed book whose formulas can be regenerated from
the original requests rather than copied by hand.

```latex
\chapter{Eigenvalue Methods}
\begin{chapteroverview}
  We compute the spectral data of a small matrix and interpret the result.
\end{chapteroverview}
\OTMathCompute[input=latex]{spectrum}{eigenvals}{
  \begin{bmatrix}2 & 0 \\ 0 & 3\end{bmatrix}}
\begin{reflectionbox}
  Explain what the computed eigenvalues mean in this particular problem.
\end{reflectionbox}
```

Use OT Math for exact computation and verification; use the book text for
assumptions, interpretation, units, derivation choices, and your own judgment.

### 2. One Calculation, Many Document Forms

Store a calculation request in a small `.tex` source and generate its result.
The same generated include can appear in a science note, an engineering
calculation record, a book chapter, or a quiz solution. Keep a separate
generated include per document root to avoid accidental reuse of a stale file.

### 3. Reusable Calculation and Formula Libraries

Yes, a book can draw selected formulas and results from a separate calculation
library. The essential distinction is between **source inclusion**, **content
reuse**, and **cross-references**:

| Need                                                | Best mechanism               | What it does                                                      |
|-----------------------------------------------------|------------------------------|-------------------------------------------------------------------|
| Display a complete small source file                | `\input{...}`                | Inserts all content in that file at the current location.         |
| Display one chosen authored formula                 | A reusable macro             | Loads a library once, then inserts only the chosen formula.       |
| Display one chosen generated OT Math result         | `\OTMathUse{<id>}`           | Selects one result from a generated include by request ID.        |
| Point to a formula already printed in the same book | `\eqref{...}` or `\ref{...}` | Inserts its number and a clickable link, not its formula content. |

Do not `\input` a complete standalone document that has its own
`\documentclass`, preamble, `\begin{document}`, and `\end{document}`. Instead,
separate the reusable definitions from any standalone catalogue that displays
them:

```text
calculations/
  fourier-formulas.tex             reusable declarations only
  fourier-formula-catalogue.tex    optional standalone review document
main.tex                           the book root
```

Example reusable formula library:

```latex
% calculations/fourier-formulas.tex
\newcommand{\FourierGaussian}{
  \mathcal{F}\{e^{-at^2}\} =
  \sqrt{\frac{\pi}{a}}e^{-\omega^2/(4a)}
}

\newcommand{\FourierShift}{
  \mathcal{F}\{f(t-t_0)\} = e^{-i\omega t_0}F(\omega)
}
```

Load the library once in the book root, after `\begin{document}` or in a
project-local preamble file:

```latex
\input{calculations/fourier-formulas}
```

Insert only a needed formula where it belongs in the narrative:

```latex
\begin{equation}
  \FourierGaussian
  \label{eq:fourier-gaussian}
\end{equation}

By Equation~\eqref{eq:fourier-gaussian}, the transform remains Gaussian.
```

Put `\label` at the location where a formula is actually numbered and printed.
Do not put a `\label` inside a reusable formula macro: using the macro twice
would create duplicate labels. `\eqref` creates a linked equation number; it
does not reinsert the formula body.

An optional catalogue can use the same library without duplicating formula
source:

```latex
% calculations/fourier-formula-catalogue.tex
\documentclass{otbook}
\begin{document}
\input{fourier-formulas}
\begin{equation}\FourierGaussian\end{equation}
\begin{equation}\FourierShift\end{equation}
\end{document}
```

For computer-generated results, use stable OT Math request IDs rather than
copying generated output. Declare all requests in the document's source, build
the generated include once, then select individual results where they are
useful:

```latex
\OTMathGeneratedInput{generated/otmath-results.tex}
\OTMathCompute[input=latex]{gaussian-transform}{integrate}{...}
\OTMathCompute[input=latex]{shift-theorem}{simplify}{...}

% Later, in the exact chapter or box where it belongs:
\OTMathUse{gaussian-transform}
```

This pattern lets one calculation source support a main book, a formula
catalogue, an engineering record, and a solution appendix. Keep IDs unique per
generated include, regenerate after changing a request, and use normal LaTeX
labels when the prose needs to link to a printed equation.

### 4. Reusable Diagram, Picture, and Plot Libraries

Diagrams follow the same source-of-truth principle as formulas, but the best
mechanism depends on the kind of visual. Use the source file to own the visual,
then selectively include the particular figure where the book needs it.

| Visual type                             | Recommended source                                      | Selective use in a book                                   |
|-----------------------------------------|---------------------------------------------------------|-----------------------------------------------------------|
| Native OT diagram                       | `otfigures` macro                                       | Call the specific macro in a `figure` environment.        |
| Custom TikZ figure                      | Small `.tex` file containing only `tikzpicture` content | `\input{figures/tikz/<name>}` inside the selected figure. |
| Photograph, scan, or existing image     | PNG, JPEG, or PDF asset under `figures/`                | `\includegraphics{<name>}` inside the selected figure.    |
| Expensive TikZ, circuit, or plot figure | Independently compiled tightly cropped PDF              | `\includegraphics{generated/<name>.pdf}`.                 |
| Data plot                               | Source data plus a project-local plot source            | Compile the selected plot to PDF, then include that PDF.  |

The existing `otfigures` package already supplies reusable native TikZ helpers:
`\cartesianaxes`, `\vectorfigure`, `\cylfigure`, `\sphfigure`,
`\stresselement`, and `\fieldgrid`. They are vector graphics, so they remain
sharp when a reader zooms the PDF and naturally share the document's OT palette
and mathematical fonts.

#### Standalone Figure Workflow

For a book with many complex figures, use the Standalone Figure Workflow to
pre-compile diagrams into PDFs. This speeds up the main document build and
ensures visual consistency.

1. Create a TikZ file using the `standalone` template:

   ```latex
   \documentclass[tikz,border=2mm]{standalone}
   \usepackage{ottheme}
   \begin{document}
   \begin{tikzpicture} ... \end{tikzpicture}
   \end{document}
   ```

2. Build all figures in a directory:

   ```powershell
   powershell -File scripts/build-figures.ps1 -SourceDir examples/figures -OutputDir build/figures
   ```

3. Include the generated PDF:

   ```latex
   \includegraphics{build/figures/my_figure.pdf}
   ```

For a custom reusable TikZ diagram, make the library file contain only the
picture itself, not a document preamble or a floating `figure` environment:

```latex
% figures/tikz/fourier-frequency-window.tex
\begin{tikzpicture}[>=Latex]
  \draw[->] (-3,0) -- (3,0) node[right] {$\omega$};
  \draw[OTBlue, thick] (-2,0) .. controls (-1,1.3) and (1,1.3) .. (2,0);
  \node[above] at (0,1.15) {frequency window};
\end{tikzpicture}
```

Use only that diagram in a selected chapter:

```latex
\begin{figure}[htbp]
  \centering
  \input{figures/tikz/fourier-frequency-window}
  \caption{A representative frequency window.}
  \label{fig:frequency-window}
\end{figure}

As shown in \cref{fig:frequency-window}, the window is centred at zero.
```

Put `\caption` and `\label` in the parent document, not inside a reusable
diagram file. A library picture can then appear more than once with different
captions and labels, without duplicate-label errors. As with formulas,
`\cref{fig:...}` creates a smart, clickable reference; it does not reinsert the
picture. `\input` reuses picture source, while `\includegraphics` reuses a
prebuilt visual asset.

The `otbook` project template already sets:

```latex
\graphicspath{{figures/}}
```

Thus, an ordinary asset can be selected by name:

```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.82\textwidth]{generated/bode-magnitude.pdf}
  \caption{Magnitude response generated from the documented model.}
  \label{fig:bode-magnitude}
\end{figure}
```

For heavy or slow figures, keep two files: a standalone root that compiles the
figure to a cropped PDF, and the source it imports. The main book then includes
only the finished PDF. Put generated PDFs under a project-local ignored folder
such as `figures/generated/` (add that path to the project's `.gitignore`) or
another explicit build output location; retain the TikZ, circuit, plot, script,
and data source in version control. This keeps book compilation quick while
preserving reproducibility.

```text
figures/
  tikz/
    filter-response.tex            reusable native source
  source/
    filter-response-standalone.tex compilation root for the asset
    response-data.csv              tracked data source
  generated/
    filter-response.pdf            ignored generated asset
```

For photographs and diagrams from external tools, prefer a legible vector PDF
when available. Use PNG for raster screenshots or pixel-based imagery; reserve
JPEG for photographs where file size matters. Keep the original editable source
beside the project when it is important to regenerate the visual. Give every
non-decorative figure a meaningful caption, label, and nearby explanatory text.

OT Math currently generates verified mathematical expressions and steps, not
plots. A sound hybrid workflow is to let OT Math generate equations or data,
then use a separate reproducible plotting source to make a PDF asset. Do not
claim that a visual is calculator-generated unless its plotting source and data
are preserved alongside it.

### 5. Engineering Decision Records With Evidence

Place calculator output inside an `otengineering` `calculation`, `decision`,
or `experiment` environment. Surround it with `\entrydate`, `\context`,
`\observation`, `\reason`, `\tradeoff`, and `\nextstep` author notes. This
keeps the numerical result, its design consequence, and its uncertainty in the
same durable record.

### 6. Quiz Banks With Verified Solution Material

Use `physicsquiz` to choose and format questions. Use OT Math offline while
authoring to check algebra, units, matrices, or calculus for solution drafts.
Put the reviewed reasoning in `quizsolution` material rather than asking a
student-facing LaTeX build to compute answers dynamically. Assessment content
should remain deliberate, versioned, and pedagogically checked.

### 7. A Personal Formula Atlas

Use `otbook` appendices for formula families, `otmath` for exact simplification
or unit conversions, `otphysics` and `otcoordinates` for semantic notation,
and `summarybox` for the final memory cue. This produces a reference that is
both computationally reproducible and readable without a terminal.

### 8. Centralized Nomenclature and Symbol Table

Use `otsymbols` to manage symbols across a book. Define symbols with unique
keys to handle collisions (e.g., density vs. resistivity both using $\rho$).

1. Define symbols in the preamble:

   ```latex
   \otdefinesymbol{density}{\rho}{Density}{kg/m^3}{Mass per unit volume.}
   \otdefinesymbol{resistivity}{\rho}{Resistivity}{\Omega\cdot m}{Electrical property.}
   ```

2. Use them in text: `\sym{density}` and `\sym{resistivity}`.
3. Print the table: `\printotnomenclature`.

### 9. Controlled Styling Without Forking a Class

For a single document, prefer the class's optional box titles and semantic
environments. For a repeated custom pattern, define a project-local environment
in the root document using the OT palette. Do not edit `otbook.cls` merely to
make one book's chapter look different. Reserve class changes for behaviour
that deserves to be shared by future books.

## Special Document Recipes and Tweaks

### Personal Book

Start from `templates/otbook-project/`. Put title, metadata, chapter order,
front/main/back matter, and `\graphicspath` in `main.tex`; put one `\chapter`
per file under `chapters/`. Use `\appendix` before `\backmatter` for lettered
appendices. Add a bibliography system only after choosing one deliberately;
none is enabled by default.

### Scientific Explanation or Lecture Note

Use `otscience` when chapters would be artificial. Structure with sections,
then alternate explanation with `definitionbox`, `intuitionbox`, `formulabox`,
`examplebox`, `warningbox`, and `summarybox`. Bring in OT Math generated output
for calculations that should remain reproducible, but write the conceptual
bridge yourself.

### Revision Pack

Use `studentnotes`. Keep metadata and title information at the top, use named
formula and theorem tools for material students must retrieve quickly, and use
margin notes sparingly for warnings or examination cues. The OT Math `latex`
or generated-result output is useful for checked worked examples, not as a
replacement for step-by-step teaching prose.

### Engineering Notebook or Design Log

Use `otengineering` and make one section per experiment, decision, or design
cycle. Record date, context, assumptions, calculations, result, confidence,
tradeoff, and next step. Use `\sketchbox` until a real figure is ready. When a
calculation matters, preserve the OT Math request near the generated result so
the number can be regenerated later.

### Structured Assessment

Use `physicsquiz`'s structured bank for any quiz that needs multiple variants,
selective topic coverage, shuffling, answer keys, or solution copies. Keep
stable IDs and tags meaningful. Test selection with a fixed seed before sharing
an assessment. Use a separate authoring pass to verify calculation-based
answers; do not silently change question values after a version has been used.

### Matrix, Statistics, Unit, or Calculus Handout

Use OT Math's domain-specific operation and request LaTeX mode. For matrices,
write `bmatrix` or `pmatrix` input inside `\OTMathCompute[input=latex]`; for
statistics, pass a comma-separated dataset; for units, set the target unit in
`variable`; for numerical solving, supply both variable and initial guess.
Pair every generated answer with a `summarybox` or `reflectionbox` that explains
what the result means and any domain restriction that matters.

### Releasing or Sharing a Source Snapshot

Use `scripts/new-author-kit.ps1` from LaTeX-lab. It creates a source-only kit
under ignored `build/author-kit/`, refuses a dirty working tree by default, and
accepts `-AllowDirty` only for an explicitly local snapshot. Add `-Zip` to
create a release asset. Before publishing, run the starter and book runners;
never commit ordinary generated PDFs, logs, or build folders as source.

## Limits and Good Judgment

OT Math is beta-track, not a complete computer algebra system. Numeric solving
is initial-guess sensitive and returns one nearby converged root. Step generation
is useful but rule-light for several advanced cases. Statistics cover finite
descriptive datasets; units use a curated vocabulary; matrix, systems, and
LaTeX input support are intentionally bounded. Inspect `verified`, `warnings`,
and the mathematical context before presenting a result as final.

LaTeX-lab is a document system, not an automatic publishing platform. It does
not currently prescribe citations, bibliographies, indices, glossaries, a print
edition workflow, or universal theorem numbering. Add those choices at the
project level only when the document genuinely needs them, and document the
choice beside the project source.

### 10. Engineering Design Log as a Database

The `otengineering` class collects decision and risk summaries in PDF registers.
Registers display the previous completed run; rebuild until pagination settles.

1. **Track Status**: Add a second optional bracket argument to `decision` or `risk` for status.

   ```latex
   \begin{decision}[Battery Type][Resolved]
      Using Li-Po for weight savings.
   \end{decision}
   ```

2. **Margin Markers**: Statuses like "Open" or "Critical" automatically create
   visual cues in the page margins.
3. **Generate Registries**: Print the full summary tables in the back matter:

   ```latex
   \printprojectdecisionlog
   \printprojectriskregister
   ```

### 11. Multi-Target Build Profiles

Use `otprofiles` to generate different versions of a document from a single
source.

1. **Set the Mode**: Pass options to the package or class.

   ```latex
   \usepackage[mode=student, print=true]{otprofiles}
   ```

2. **Conditional Content**: Use `\otifmode` for targeted text.

   ```latex
   \otifmode{instructor}{This hint is for teachers only.}
   ```

3. **Automatic Hiding**: In `student` mode, `workedsolution` environments
   are automatically suppressed.
4. **Print Optimization**: Set `print=true` to force grayscale and black links.

### 12. Reproducible Mathematics (Ot-Calculator)

Technical documents can pull results directly from the `Ot-Calculator` engine.

1. **Generate Snippets**: Use `otcalc` to process your `.tex` file.
2. **Load Results**: Use `\otloadsnippets{results.tex}`.
3. **Display Values**: Use `\otcompute{key}` to insert calculated math.

### 13. Interactive Engineering Forms

For digital field notes, explicitly load `\usepackage{otforms}` in the preamble to add fillable fields.

```latex
\otstartforms
\ottextfield{Temperature}{temp_field}
\otcheckbox{Safety Check}{chk_safe}
\otendforms
```

### 14. Case Study: The Spong Re-construction

A full-scale example of re-mapping a technical textbook into a personalized
operating manual. Located in `examples/spong_reconstruction/`. It demonstrates:
- **De-construction** of rotation matrices and Lagrangian dynamics.
- **Interpretation** using physical analogies (e.g., Virtual Spring-Dampers).
- **Re-construction** anchors for spaced retrieval.

## Candidate Upgrades Not Yet Implemented

The following are viable areas for future work. They are deliberately not
presented as current features. Existing equivalents are omitted: OT already has
TikZ and reusable `otfigures` macros, `hyperref` links, `cleveref` in the book
and science classes, `siunitx`, semantic boxes, StudentNotes margin notes, a
chapter-aware book header, and PhysicsQuiz output modes.

| Candidate                                      | Why it fits                                                                                                    | Scope and caution                                                                                                                                  |
|------------------------------------------------|----------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------|
| Bibliography, index, and nomenclature profiles | Helps textbooks and reference books manage citations, terms, and symbols.                                      | Choose one backend and build recipe only after deciding the desired author workflow.                                                               |
| Project build profiles                         | Could produce draft, instructor, student, or print variants from one source.                                   | Design a small explicit option interface; PhysicsQuiz already has its own output modes.                                                            |
| Draft watermark helper                         | Useful for review copies without hand-editing page content.                                                    | Prefer a project option so ordinary final PDFs are unchanged.                                                                                      |
| Stronger bookmark policy                       | The current hyper-navigation works; a policy could standardize PDF outline depth and fragile heading handling. | Audit all classes and actual readers before adding a dependency.                                                                                   |
| Accessibility / tagged-PDF pilot               | Worth exploring for inclusive, long-lived documents.                                                           | This is an engine and package compatibility project, not a one-line preamble change; prototype with representative books and screen-reader checks. |
| LuaLaTeX plus `fontspec` profile               | Opens OpenType typography and Lua scripting for selected book projects.                                        | Keep pdfLaTeX as the supported baseline until a separate engine-aware build/test path exists.                                                      |
| Interactive PDF forms                          | Useful for controlled worksheets, feedback forms, or fillable records.                                         | Reader support varies; do not use forms as the sole way to access essential content.                                                               |
| Data-driven report generation                  | Useful for certificates, invoices, and repeated reports.                                                       | Define data validation, privacy, and a stable CSV/JSON contract before choosing a package.                                                         |
| Code listings and algorithm support            | Useful for technical textbooks.                                                                                | Start with a shell-escape-free listing option; treat `minted` and executable code as opt-in security-sensitive workflows.                          |
| Python or simulation execution                 | Can produce reproducible plots and calculations.                                                               | Prefer OT Math pre-generation or explicit scripts first; do not enable executable document compilation for untrusted source.                       |

The strongest next candidates for this repository are the standalone figure
workflow, an opt-in `pgfplots` layer, a circuit-diagram module, and a deliberate
book theorem/equation-numbering policy. They build directly on the existing OT
figure, math, and book foundations without changing the dependable pdfLaTeX
baseline for every author.

## Verification Commands

```powershell
# LaTeX-lab starters
powershell -ExecutionPolicy Bypass -File tests\run_starter_tests.ps1

# otbook starter, smoke test, and copied-project template
powershell -ExecutionPolicy Bypass -File tests\run_otbook_tests.ps1

# Source-only author-kit generator guard
powershell -ExecutionPolicy Bypass -File tests\run_author_kit_tests.ps1

# OT Math, from Ot-Calculator
pytest
otcalc latex-build examples/latex/stress.tex --compile
```

## Source References

For exhaustive contracts, consult `docs/PUBLIC_INTERFACES.md` and
`docs/AUTHOR_WORKFLOW.md` in LaTeX-lab, and `docs/cli.md`, `docs/latex.md`,
`docs/api-engine.md`, `docs/configuration.md`, and `docs/known-limitations.md`
in `Ot-Calculator`. This manual is a consolidated operating guide; those source
documents remain the detailed authority for their respective projects.
