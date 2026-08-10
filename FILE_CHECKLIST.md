# File Checklist by Phase

Upload plain source files rather than screenshots wherever possible. Keep the folder structure intact. When a file imports or references another file, include that dependency too.

## Always include at the beginning of a new project chat

1. `MASTER_PROMPT.md`
2. Latest `PROJECT_STATE.md`
3. Latest `CHANGELOG.md`
4. A text file containing the project folder tree, for example:
   ```powershell
   tree /F /A > project-tree.txt
   ```
5. The current canonical versions of all classes and packages under discussion.
6. One small representative `.tex` document for each class.
7. The corresponding compiled PDF for visual comparison.
8. The `.log` file only when warnings or errors are being investigated.

Do not upload build clutter unless it is being diagnosed:
`.aux`, `.fls`, `.fdb_latexmk`, `.synctex.gz`, `.toc`, `.out`, `.bcf`, `.run.xml`.

---

## Phase 0 — Baseline audit

Required:

- `studentnotes.cls`
- `physicsquiz.cls`
- every other custom `.cls` or `.sty` used by the projects
- one representative `studentnotes` source `.tex`
- one representative `physicsquiz` source `.tex`
- compiled PDF for each representative source
- `00_main_combined_workbook.tex`
- `otscience.cls`
- `00_common_setup.tex`
- all files imported by the workbook:
  - `01_grad_div_curl_vector_fields.tex`
  - `02_coordinate_systems_tensor_operations.tex`
  - `03_index_delta_levicivita.tex`
  - `04_covariant_contravariant_metrics.tex`
  - `05_symmetric_skew_tensors_invariants.tex`
  - `06_complex_numbers_hyperbolic_functions.tex`
  - `07_final_mixed_practice_bank.tex`
- every image or data file referenced by those sources
- `project-tree.txt`
- current compiled workbook PDF
- any separate source used to create the ternary-computing PDF, if that document will also be refactored

Helpful:

- current `.vscode/settings.json`
- current `.latexmkrc`
- one clean compile log from each representative project
- a short note stating which outputs are considered visually correct

---

## Phase 1 — LaTeX Workshop

Required:

- `.vscode/settings.json`
- representative root `.tex`
- at least one child/imported `.tex`
- relevant `.cls` and `.sty`
- `.latexmkrc`, if present
- `project-tree.txt`

When troubleshooting:

- LaTeX Workshop build output copied as text
- relevant `.log`
- exact command shown in the build output
- output of:
  ```powershell
  where.exe pdflatex
  where.exe latexmk
  pdflatex --version
  latexmk --version
  ```

---

## Phase 2 — Semantic interfaces

Required:

- `studentnotes.cls`
- `physicsquiz.cls`
- every `.tex` file that currently uses:
  - `\choices`
  - `namedformula`
  - note boxes
  - theorem environments
  - answer-key environments
- compiled PDFs showing the current expected appearance

This is necessary to preserve compatibility and identify real usage patterns.

---

## Phase 3 — Multiple assessment outputs

Required:

- latest `physicsquiz.cls`
- a complete representative quiz source
- its current student PDF
- current answer key or solution source, if separate
- a short specification of desired outputs
- any institution/course branding assets

Helpful:

- at least 10 varied questions, including:
  - long options;
  - equations;
  - figures;
  - different numbers of options;
  - numerical solutions;
  - conceptual solutions.

---

## Phase 4 — Question bank

Required:

- latest `physicsquiz.cls`
- a representative set of 20–60 real questions
- current answer key
- current worked solutions
- desired metadata fields
- desired selection rules, such as topic mix or difficulty progression
- desired output examples

Do not begin with only the class file; the architecture must be tested against real question diversity.

---

## Phase 5 — Shared packages

Required:

- every custom `.cls` and `.sty`
- representative sources and PDFs for each class
- folder tree
- current public-interface inventory
- current dependency audit

Include any class such as `otscience.cls`; otherwise shared-code decisions will be incomplete.

Also required from Checkpoint 5A onwards:

- `tests/run_ot_phase5_tests.ps1` and `tests/check_ot_baseline.py`
- `tests/ot_baseline_manifest.json`
- `PHASE5_CHECKPOINT_5A.md` and any later `PHASE5_CHECKPOINT_5*.md`

Do not re-record the Phase 5 baseline in a new session. It was recorded against
unmodified sources; re-recording it after a change would silently bless that
change and destroy the evidence the phase depends on. Verify against the
committed manifest instead, and re-record only as a deliberate, documented step.

---

## Phase 6 — Modern programming

Required:

- latest class/package files
- public-interface inventory
- compatibility test documents
- examples of desired new key-value syntax
- minimum MiKTeX/LaTeX compatibility target, if important

---

## Phase 7 — Modular documents

Required:

- the complete source directory, not only the main file
- all custom classes and packages
- all imported module files
- all figures
- bibliography databases
- glossary/index source files
- current combined PDF
- at least one standalone module PDF
- folder tree
- compile instructions

For the current workbook, `00_main_combined_workbook.tex` alone is insufficient because it depends on `otscience.cls`, `00_common_setup.tex`, and seven module files.

---

## Phase 8 — Publishing tools

Files depend on the selected topic.

Bibliography:
- `.bib`
- citation-bearing `.tex`
- current PDF
- desired citation style

Graphics:
- current TikZ/CircuiTikZ/PGFPlots source
- source data files
- desired visual reference

Code:
- representative program files
- current listing setup
- output PDF

Glossaries:
- terminology/acronym list
- current source and class

---

## Phase 9 — Automation and performance

Required:

- full source tree
- `.vscode/settings.json`
- `.latexmkrc`
- any `arara` directives/configuration
- build log
- approximate clean-build time
- approximate incremental-build time
- files containing TikZ backgrounds or repeated graphics
- generated-file directory listing

For dot-grid optimisation, include a long representative `studentnotes` document, not only the class.

---

## Phase 10 — Testing and release discipline

Required:

- full custom class/package source tree
- current examples
- project folder tree
- current Git status or repository structure
- desired supported engines and document classes
- known compatibility requirements
- current version numbers
- current change log, if any

---

## Files that should be renamed before the long-term project begins

Use canonical names without download suffixes:

- `studentnotes(5).cls` → `studentnotes.cls`
- `physicsquiz(3).cls` → `physicsquiz.cls`

Keep the original files in a separate `baseline/` or backup directory before renaming.
