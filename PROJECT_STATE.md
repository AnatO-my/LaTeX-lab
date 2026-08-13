# PROJECT_STATE.md

## Project

LaTeX Workspace Learning and Class Refactoring Project

## Environment

* Operating system: Windows
* Editor: Visual Studio Code
* TeX distribution: MiKTeX 26.2
* pdfTeX: MiKTeX-pdfTeX 4.26
* Build tool: latexmk 4.88
* Local extension: LaTeX Workshop
* Overleaf Workshop use: deliberate online collaboration and multi-device access only
* Primary working copy: local project folder
* Repository root: `C:\Users\Ot\OneDrive\Documents\LaTeX\LaTeX-Lab`
* Primary Git branch: `main`
* Additional required MiKTeX packages: `xsim`, `siunitx`
* Python is required to run the Phase 3 and Phase 4 checkers (`py -3` or `python`)

## Current phase

**Phase 7 — Local author workflow and distribution readiness — in progress.
Checkpoint 7A opened on 13 August 2026. Checkpoints 7B through 7F implemented
on 13 August 2026.**

Phase 7 makes the repository easier to use, share, and collaborate on without
depending on chat context. Checkpoint 7A adds the first user-facing `README.md`,
opens `docs/AUTHOR_WORKFLOW.md`, and records GitHub collaboration as a real
Phase 7 workstream. Checkpoint 7B inventories starters versus representative
examples and adds a concrete GitHub collaboration checklist. Checkpoint 7C adds
the missing small starters and a fast starter-only runner. Checkpoint 7D adds
the first GitHub collaboration packaging files. Checkpoint 7E records the first
release and author-kit boundary. Checkpoint 7F records the final manual GitHub
push checklist.

**Phase 6 — Modern LaTeX interface programming — completed on 13 August
2026.**

Phase 6 uses a conservative modernization model: preserve existing author-facing
structures unless a modern LaTeX change improves safety, maintainability,
validation, or local usability. Checkpoint 6A opened the phase with an isolated
learning scaffold and no production class or package behaviour changes.
Checkpoint 6B adds public `physicsquiz.cls` version and structured-interface
capability markers. Checkpoint 6C adds a source-level namespace guard for the
existing `physicsquiz.cls` modern-code boundary. Checkpoint 6D resolves marks
decimal validation so both `0.5` and `.5` work. Checkpoint 6E improves
structured-bank author messages and adds a copyable starter quiz-bank document.
Checkpoint 6F closes the carried versioned-paper review guard with generated
Version A/B builds and log-level answer-key/solution alignment checks.
Checkpoint 6G closes the phase governance without production code changes.
Full detail is in the "Phase 6 status" section below.

**Phase 5 — Shared OT design system — completed on 12 August 2026.**

Phase 5 audited duplication across the four classes and the seven companion
packages and implemented a minimal shared-package architecture. Checkpoint 5F
closed the phase governance: the three new shared packages carry the agreed
LaTeX kernel floor, the public-interface record names the support boundary,
generated outputs remain build artifacts, and the `physicsquiz.cls`
semantic-version item is carried forward into Phase 6.

**Phase 4 — Question-bank architecture — completed on 9 August 2026.**

Checkpoints 4A to 4J. Every item that Phase 3 deferred into the question-bank
layer has been delivered: structured records, automatic answer keys and mark
totals, deterministic selection and filtering and reordering, seeded
randomisation, the `xsim` comparison, the sixty-question migration, choice
shuffling, and version-dependent question assignment.

Phase 4 gave `physicsquiz.cls` a structured question-record layer on top of the
Phase 3 output-selection layer. A question is now declared once, carrying its
metadata, stem, choices, and worked solution; the booklet, answer key, topic
report, worked solutions, and mark totals are all derived from that single
record. Deterministic and seeded-random selection sit between declaration and
rendering.

The architecture decision was made in favour of an `xsim`-backed storage engine
behind a `physicsquiz`-owned author syntax. Raw `xsim` syntax is an
implementation detail rather than an author interface.

The complete 60-question representative quiz has been migrated into the
structured interface as `examples/physicsquiz/banks/phy104_full_question_bank.tex`,
totalling 120 marks. The legacy `examples/physicsquiz/PHY104_Exam revision.tex`
remains in place, unchanged, as the fidelity baseline. It has not been replaced
or deleted.

The no-option default remains the established full-colour document, and every
Phase 2 and Phase 3 interface remains valid. Existing manual quizzes require no
migration.

The independent working-tree modification to `examples/studentnotes/Optics.tex`
remains outside every Phase 4 checkpoint and must stay unstaged.

### Repository-level `.latexmkrc`

The repository-level `.latexmkrc` now:

* discovers classes under `src/classes`;
* discovers packages under `src/packages`;
* preserves MiKTeX's standard input trees;
* builds directly with pdfLaTeX;
* enables SyncTeX;
* enables file-and-line error reporting;
* processes nested roots from their document directories; and
* supports both command-line and LaTeX Workshop builds.

The configuration assumes that `latexmk` is launched from the repository root before `$do_cd` changes into the selected document's directory.

### Project-local LaTeX Workshop settings

`.vscode/settings.json` now:

* launches builds from the repository root;
* loads the repository `.latexmkrc`;
* writes generated files under `build/%RELATIVE_DIR%`;
* automatically builds LaTeX documents on save;
* displays the selected root file in the status bar;
* uses LaTeX Workshop's internal PDF viewer;
* runs ChkTeX when a document is saved;
* uses `latexindent` for explicitly requested formatting;
* disables LaTeX formatting on save;
* disables automatic mathematical-delimiter rewriting; and
* disables automatic quotation rewriting.

## Phase 1 acceptance evidence

The following tests passed:

* project-local discovery of all four active classes;
* project-local discovery of all seven OT companion packages;
* `otengineering` representative build;
* `physicsquiz` representative build;
* `studentnotes` representative build;
* combined vector-workbook build;
* standalone vector-workbook module builds;
* correct root selection for combined and standalone documents;
* forward SyncTeX navigation;
* inverse SyncTeX navigation;
* inverse navigation from the combined PDF into an imported module;
* controlled output under the mirrored `build/` tree;
* command-line building through the repository `.latexmkrc`;
* LaTeX Workshop building through the same `.latexmkrc`;
* auxiliary-file cleaning and fresh rebuilding;
* automatic compilation on save;
* ChkTeX 1.7.9 linting; and
* explicit `latexindent` 4.0 formatting.

No `% !TeX root` directives were added. The workbook's existing conditional architecture correctly supports both combined and standalone compilation.

## Repository checkpoint status

* The audited Phase 0 baseline has been committed and tagged as `phase-0-baseline`.
* The Phase 1 workflow configuration has been committed and verified.
* The earlier Phase 2 semantic-interface compatibility checkpoints have been committed.
* The final Phase 2 public-interface and helper-verification checkpoint has been completed and verified.
* Phase 2 was committed on `main` as `e045765` — `Complete Phase 2 public-interface baseline`.
* Phase 3A established the assessment-output architecture contract.
* Phase 3B added and verified mutually exclusive primary output modes.
* Phase 3C added semantic content gates and a shared synthetic assessment fixture.
* Phase 3D added colour/print presentation, version metadata, marks, difficulty,
  and the repository-local PowerShell verification runner.
* Phase 3E updated the public-interface, changelog, and project-state records.
* Phase 3 was committed on `main` as `485bed4` — `Complete Phase 3 assessment output modes`.
* Phase 4A compared a lightweight custom question record with `xsim` as a
  read-only architecture study. It produced no checkpoint note in the repository
  and is recorded only in the session transcript.
* Phase 4B proved an `xsim`-backed facade as a test-only `.sty` over four real
  questions, without changing the production class.
* Phase 4C promoted the facade into `src/classes/physicsquiz.cls` as the
  production structured-question interface.
* Phase 4D separated declaration, deterministic selection, and rendering.
* Phase 4E added seeded reproducible random selection.
* Phase 4C, 4D, and 4E were committed on `main` as `3a58586` —
  `Add structured physics question bank and selection`.
* Phase 4F migrated a twelve-record audit pilot and was committed on `main` as
  `f7afd1e` — `Add PHY104 structured migration pilot`.
* Phase 4G migrated the complete sixty-record bank. Its runner passed locally on
  6 August 2026 and was committed on `main` as `19e816b` — `Migrate the complete
  PHY104 question bank`. The governance records followed as `5dc4a0b`.
* Phase 4H restored the constants box in the generated booklet after the Phase 4G
  visual review found it missing.
* Phase 4I added seeded option shuffling and Phase 4J added the version
  manifest. They were designed and verified together, because a manifest entry
  carries its own shuffle seed.
* Generated PDFs, logs, and other build artefacts remain excluded from the
  source-focused checkpoints.
* `examples/physicsquiz/PHY104_Exam revision.pdf` and its `.log` are tracked from
  the Phase 0 baseline and have been regenerated during verification. They are
  deliberately left unstaged.
* `examples/studentnotes/Optics.tex` remains an independent modification and is
  excluded from every Phase 3 and Phase 4 checkpoint.

## Canonical repository structure

```text
LaTeX-Lab/
├── .gitignore
├── .latexmkrc
├── CHANGELOG.md
├── FILE_CHECKLIST.md
├── MASTER_PROMPT.md
├── PHASE_PROMPTS.md
├── PROJECT_STATE.md
├── ROADMAP.md
├── PHASE3_CHECKPOINT_3B.md … PHASE3_CHECKPOINT_3E.md
├── PHASE4_CHECKPOINT_4B.md … PHASE4_CHECKPOINT_4G.md
│
├── .vscode/
│   └── settings.json
│
├── docs/
│   └── PUBLIC_INTERFACES.md
│
├── src/
│   ├── classes/
│   │   ├── otengineering.cls
│   │   ├── otscience.cls
│   │   ├── physicsquiz.cls
│   │   └── studentnotes.cls
│   │
│   ├── packages/
│   │   ├── otcoordinates.sty
│   │   ├── otfigures.sty
│   │   ├── otmath.sty
│   │   ├── otnotation.sty
│   │   ├── otphysics.sty
│   │   ├── otpractice.sty
│   │   └── ottensors.sty
│   │
│   └── legacy/
│       └── otscience.sty
│
├── examples/
│   ├── otengineering/
│   │   └── test.tex (+ preserved test.pdf, test.log)
│   │
│   ├── physicsquiz/
│   │   ├── PHY104_Exam revision.tex        ← legacy fidelity baseline
│   │   ├── PHY104_migration_pilot.tex
│   │   ├── PHY104_structured_revision.tex
│   │   └── banks/
│   │       ├── phy104_migration_pilot_bank.tex
│   │       └── phy104_full_question_bank.tex
│   │
│   ├── studentnotes/
│   │   └── Optics.tex (+ preserved Optics.pdf)
│   │
│   └── vector-workbook/
│       ├── 00_common_setup.tex
│       ├── 00_main_combined_workbook.tex
│       └── 01_… through 07_… module sources (+ preserved PDFs)
│
├── tests/
│   ├── compatibility and helper fixtures (Phase 2)
│   ├── physicsquiz output-mode and presentation drivers (Phase 3)
│   ├── physicsquiz_xsim_* drivers (Phase 4C)
│   ├── physicsquiz_selection_* drivers (Phase 4D)
│   ├── physicsquiz_random_* drivers (Phase 4E)
│   ├── physicsquiz_migration_pilot_* drivers (Phase 4F)
│   ├── physicsquiz_full_migration_* drivers (Phase 4G)
│   ├── check_physicsquiz_output_modes.py
│   ├── check_physicsquiz_xsim_facade.py
│   ├── check_physicsquiz_selection.py
│   ├── check_physicsquiz_random_selection.py
│   ├── check_physicsquiz_migration_pilot.py
│   ├── check_physicsquiz_full_migration.py
│   ├── run_physicsquiz_phase3d/4c/4d/4e/4f/4g/4ij_tests.ps1
│   ├── check_ot_baseline.py                (Phase 5A)
│   ├── ot_baseline_manifest.json           (Phase 5A)
│   ├── ot_palette_probe_*.tex              (Phase 5A)
│   ├── otpractice_standalone.tex           (Phase 5A cycle witness)
│   └── run_ot_phase5_tests.ps1             (Phase 5A)
│
└── build/                                  ← generated, git-ignored
```

Generated files belong under the mirrored `build/` tree and must not be
committed from the source directories. Some Phase 2 auxiliary files still sit
loose in `tests/`; they are git-ignored by extension but could be cleaned.

## Canonical source files

### Classes

* `src/classes/studentnotes.cls`
* `src/classes/physicsquiz.cls`
* `src/classes/otengineering.cls`
* `src/classes/otscience.cls`

All four active classes have now been supplied and audited.

### Active OT packages

* `src/packages/otnotation.sty`
* `src/packages/otmath.sty`
* `src/packages/ottensors.sty`
* `src/packages/otphysics.sty`
* `src/packages/otcoordinates.sty`
* `src/packages/otpractice.sty`
* `src/packages/otfigures.sty`

These seven packages form the companion package system used by `otscience.cls` and the modular workbook.

Phase 5 has also introduced shared infrastructure packages:

* `src/packages/ottheme.sty`
* `src/packages/otboxes.sty`
* `src/packages/otcore.sty`

Four of the seven — `otnotation`, `otmath`, `otpractice` and `otfigures` —
depended on colours defined by `otscience.cls`, and `otpractice` also depended
on its `otscibox` environment. Checkpoint 5B moved the colour dependency to
`ottheme.sty` for `otnotation`, `otmath`, and `otfigures`. Checkpoint 5C moves
the box dependency to `otboxes.sty` for `otpractice`.

`ottensors`, `otphysics` and `otcoordinates` are already self-contained and
independently loadable today.

Before Checkpoint 5C, the remaining dependency was a use-time rather than a
load-time cycle: `otpractice`'s back-reference resolved when a document used a
practice box, not when the package loaded. Checkpoint 5C removes that remaining
cycle and turns `tests/otpractice_standalone.tex` into a positive smoke test.

### Legacy source

* `src/legacy/otscience.sty`

This is the older monolithic version 0.1 implementation. It overlaps with the newer version 0.2 `otscience.cls` and its seven companion packages. It is preserved for historical reference and must not be loaded alongside the active `otscience.cls` architecture.

## Representative projects

### `physicsquiz.cls`

Legacy fidelity baseline:

* `PHY104_Exam revision.tex`
* `PHY104_Exam revision.pdf`
* `PHY104_Exam revision.log`

The audited baseline build produced a readable 24-page examination-revision
document without LaTeX warnings or overfull boxes. The Phase 2 refactor replaced
the unbreakable choices table with a semantic list-based interface and the
document settled at the accepted 23-page default rendering, with Question 60's
five options together in one column. That 23-page output remained
pixel-identical through Phases 3 and 4.

Structured counterparts:

* `PHY104_structured_revision.tex` — the complete 60-record, 120-mark structured
  example. It compiles cleanly at 25 pages: a table of contents and three
  20-question answer-key bands account for the difference from the legacy
  document.
* `PHY104_migration_pilot.tex` — the twelve-record audit pilot covering every
  topic-by-difficulty combination.

The legacy and structured sources currently describe the same 60 questions. That
duplication is deliberate for the acceptance period and ends when the legacy
source is retired.

### `studentnotes.cls`

Canonical representative project:

* `Optics.tex`
* `Optics.pdf`

The separate normal-modes project was also audited during Phase 0. Its historical log confirmed successful compilation and identified a small margin-note overflow. The `Optics` project is presently the representative example retained in the canonical repository.

### `otengineering.cls`

Representative project:

* `test.tex`
* `test.pdf`
* `test.log`

The audited build produced a four-page engineering notebook. The project dashboard fits correctly, and the log contains only one harmless underfull-box warning.

### `otscience.cls` and modular workbook

The workbook source set is complete. It contains the active class, all seven companion packages, `00_common_setup.tex`, the combined root document, all seven numbered modules, combined and standalone reference PDFs, and the historical combined-build log.

The historical MiKTeX 26.2 build successfully loaded the class, all seven packages, the shared setup, and all seven modules. It produced the preserved 30-page combined PDF.

The canonical repository structure is now supported by the shared Phase 1 class and package search-path configuration. Internal `\documentclass`, `\input`, and package paths remain unchanged.

## Known current features

### `studentnotes.cls`

* `article` base class
* fixed A4 and 12-point configuration
* geometry and margin-note support
* `fancyhdr`
* custom section formatting
* optional TikZ dot-grid page background
* semantic `tcolorbox` note environments
* theorem, definition, and example environments
* custom formula counter
* `namedformula` environment
* margin-note helper commands
* `witharrows` helper commands
* matrix and vector helper commands

### `physicsquiz.cls`

* `article` base class
* pass-through article options
* mutually exclusive `full`, `student`, `teacher`, `solutions`, and `answerkey` primary modes
* independent `colour`/`print` presentation modes, with `color` as an alias
* semantic gates for questions, answer keys, solutions, teacher notes, and references
* configurable global quiz font size
* title metadata setters
* visible version metadata
* optional display-only marks and difficulty labels
* custom quiz title page
* constants box
* multi-column `quizquestions` environment, supporting one column as well as the
  established two-column default
* flexible `choiceoptions` environment with alphabetical labels
* backward-compatible five-argument `\choices` wrapper
* manual `answerkey` environment
* `siunitx` configuration
* custom colours and page styling
* **structured question records** — `quizbank`, `quizquestion`, `quizsolution`,
  and the `quizquestionbank` compatibility wrapper
* **metadata validation** — required `id`, `topic`, `difficulty`, `marks`,
  `correct`, `tags`; optional `outcome`; descriptive class errors for malformed,
  missing, duplicate, orphaned, and non-adjacent input
* **deterministic selection** — `\quizselectids`, `\quizselect`,
  `\quizselectall`, `\quizclearselection`
* **seeded reproducible random selection** — `\quizselectrandom`, using a
  class-owned Park-Miller generator published as `park-miller-v1`
* **generated output** — `\printquizquestions`, `\printquizanswerkey`,
  `\printquiztopicreport`, `\printquizsolutions`, `\printquizteacherreport`
* **regression assertions** — `\quizbankassert`, `\quizselectionassert`
* `xsim` as the storage engine, and `expl3` programming internally

### `otengineering.cls`

* project metadata setters
* project dashboard and title commands
* semantic engineering and research boxes
* status labels
* confidence, success, and pursuit ratings
* calculation fields
* sketch boxes
* project tracking and decision-record helpers

### `otscience.cls`

* scientific-document page layout
* mathematical and physics package support
* breakable and non-splitting semantic boxes
* section and header styling
* scientific colour system
* conditional loading of the seven OT companion packages
* `hyperref` and `cleveref` support
* combined and standalone workbook architecture

## Agreed principles

* Preserve the existing visual identity unless redesign is explicitly approved.
* Learn the underlying concepts while refactoring.
* Make small, compilable changes.
* Preserve backward compatibility where reasonable.
* Do not replace MiKTeX without a concrete need.
* Keep local files as the primary working copy.
* Use Overleaf deliberately rather than as the sole source.
* Maintain explicit change and state records between sessions.
* Do not assume a build succeeded without checking the relevant log.
* Do not change unrelated parts of a class or package.
* Introduce new packages only when their benefit justifies their maintenance cost.
* Preserve representative outputs for visual and behavioural comparison.
* Record public-interface changes and migration requirements.

## Known issues to audit or correct later

### `studentnotes.cls`

* `witharrows` is loaded twice.
* The dot-grid background creates approximately 2,580 TikZ dots per page.
* Calling `\usedotgrid` more than once may install the background repeatedly.
* The class loads `marginnote` but primarily uses `\marginpar`.
* Narrow margin notes can stack words awkwardly.
* Several generic public environment names create future collision risks.

### `physicsquiz.cls`

* `\printquizanswerkey` does not paginate a long generated key. A 60-entry key is
  taller than one page, so the complete structured example prints three
  20-question band keys instead.
* Selection is document-global state. A semantic gate that changes the selection
  leaves that change in place for later gates, so a document must re-select
  deliberately after filtering inside a gate.
* `quizquestionbank` clears the current selection before printing. Mixing it with
  explicit selection commands in one document discards the earlier selection.
* Changing the `park-miller-v1` algorithm would be a documented compatibility
  break, because existing seeds would stop reproducing their selections.
* The structured bank and the legacy quiz describe the same 60 questions. The
  duplication persists until the legacy source is retired.
* The class now requires `xsim`. A machine without it cannot compile structured
  documents; the Phase 4 runners fail early and explain this.
* Checkpoint 6B adds public version and capability markers, so a document can
  test for the presence of the structured interface without parsing the
  `\ProvidesClass` date string.
* Option shuffling supports the five-option `\choices` interface only; a
  `choiceoptions` record raises a class error under shuffling.
* No option can be pinned to a fixed position, so a bank containing
  none-of-the-above style options must not be shuffled. The PHY104 bank has none.
* Producing a full set of versioned papers means one compile per version label.
* The class now mixes traditional LaTeX and `expl3` code. This anticipated
  Phase 6 rather than following it, and the mixture should be reviewed for
  consistency when Phase 6 begins.
* Wider compatibility testing is still needed for exceptionally long options,
  displayed mathematics, and future assessment layouts.
* Some dependencies may be broader than the class implementation requires.

### `otengineering.cls`

* A `tabularx` inside a `tcolorbox` uses `\textwidth`; `\linewidth` may be safer.
* Some loaded packages may support document content rather than class implementation.
* Several generic public names create namespace-collision risks.
* The representative log contains one harmless underfull-box warning.

### `otscience.cls` and workbook

* `\CartToCyl` and `\CartToSph` use `\tan^{-1}(y/x)`, which loses quadrant information; a later implementation should use an `atan2` formulation.
* The companion packages currently depend on class-defined colours and box interfaces.
* The optional-loading arrangement can hide missing ecosystem dependencies.
* Combined and standalone builds require controlled regression testing after path configuration.

### General ecosystem issues

* Public namespaces are not formally documented.
* Minimum supported LaTeX version has not been chosen.
* Engine support has not been formally defined.
* No `l3build` configuration exists.
* Package-version diagnostics are not automated.
* The preserved PDFs are untagged and contain limited document metadata.
* A regression suite now exists for `physicsquiz` only. The other three classes
  have compatibility fixtures but no runner.
* Some Phase 2 auxiliary files remain loose in `tests/` rather than under
  `build/`.

## Decisions resolved during Phase 4

* **Lightweight custom architecture or `xsim`:** resolved in favour of an
  `xsim`-backed storage engine behind a `physicsquiz`-owned author syntax.
* **The Phase 4 question-record interface and metadata validation policy:**
  fixed at Checkpoint 4C and documented in `docs/PUBLIC_INTERFACES.md`.

## Decisions still required

* Whether the modular workbook should retain its existing conditional structure or adopt `subfiles`
* Naming and compatibility policy for public commands
* Accessibility target for future PDFs

## Decisions resolved at the start of Phase 5

* **Minimum supported LaTeX kernel:** 2022-06-01, to be written into each new
  package as `\NeedsTeXFormat{LaTeX2e}[2022-06-01]`. It guarantees the modern
  hook management system and stable `expl3` in the kernel, both of which
  `physicsquiz.cls` already relies on, and is comfortably older than MiKTeX 26.2.
* **Engine support:** pdfLaTeX is supported. LuaLaTeX and XeLaTeX are expected to
  work but are untested. Widening the claim later means adding engine loops to
  the runners rather than changing code, because `park-miller-v1` was written to
  avoid engine random primitives.
* **How much shared code moves into common OT packages:** three packages —
  `ottheme.sty`, `otboxes.sty` and `otcore.sty`. A fourth, `otmath`, was
  rejected: the name is already held by a live companion package, and there is no
  identical maths code to justify it.
* **Semantic version for `physicsquiz.cls`:** resolved at Checkpoint 6B. The
  class now declares `v0.1` and exposes `\physicsquizclassversion`,
  `\physicsquizstructuredinterfaceversion`, and
  `\physicsquizstructuredinterfaceid`.
* **Namespace discipline for the current `physicsquiz.cls` `expl3` layer:**
  resolved at Checkpoint 6C. Project-local internal functions and variables are
  guarded under the `__pq` module, while public wrappers remain the supported
  author-facing surface.
* **Structured marks decimal syntax:** resolved at Checkpoint 6D. Structured
  question metadata and marks filters accept positive integers, whole-number
  decimals such as `1.5`, leading-zero fractional decimals such as `0.5`, and
  leading-dot fractional decimals such as `.5`.
* **Structured quiz-bank author usability:** improved at Checkpoint 6E. The
  class keeps the existing syntax but gives more concrete help for common
  metadata mistakes, and `examples/physicsquiz/starter_quiz_bank.tex` is now a
  copyable local starting point.
* **Retiring the legacy `PHY104_Exam revision.tex`:** at the start of Phase 6.
  Phase 5 never touches `physicsquiz.cls`, so the legacy quiz costs nothing and
  remains independent evidence that the untouched side is untouched.
* **Whether generated example PDFs stay version-controlled:** resolved at
  Checkpoint 5F. Generated PDFs, logs and auxiliary files remain build artifacts;
  Phase 5 evidence is the source fixtures, baseline manifest, checker output,
  and package smokes.

## Phase 6 status

Phase 6 is complete. It taught and selectively applied modern LaTeX interface
programming: `\NewDocumentCommand`, argument specifications, key-value
configuration, selected `expl3` data structures, robust messages, and namespace
discipline.

The phase follows the conservative modernization model. Existing author-facing
structures remain valid unless a change produces a practical gain in safety,
maintainability, validation, or local usability. Meaningful conservation
decisions should be checked with the user unless changing the preserved structure
would force a broad breakage audit for little reward.

### Checkpoint 6A — conservative modernization opening

Checkpoint 6A changes no production class or package behaviour. It adds:

* `PHASE6_CHECKPOINT_6A.md`;
* `tests/phase6_modern_interface_examples.tex`, an isolated learning scaffold
  for `\NewDocumentCommand`, optional arguments, `expl3` keys, token lists,
  booleans, and named messages; and
* `tests/run_phase6a_tests.ps1`, a runner for that scaffold.

PowerShell parser checks passed for the runner, and the Phase 6A runner passed
in the normal MiKTeX environment with `All Phase 6A tests passed.`

The first production candidates remain explicit decisions for later checkpoints:

1. whether the traditional class-option layer should stay as-is or move to a
   modern key layer;
2. whether the current five-option-only shuffling contract should remain;
3. whether shuffled `choiceoptions` records should stay unsupported; and
4. what long-term role the legacy PHY104 source should have.

### Checkpoint 6B — physicsquiz capability marker

Checkpoint 6B adds the first production Phase 6 change. `physicsquiz.cls` now
declares `v0.1` in `\ProvidesClass` and exposes three public expandable markers:

* `\physicsquizclassversion`, currently `0.1`;
* `\physicsquizstructuredinterfaceversion`, currently `1`; and
* `\physicsquizstructuredinterfaceid`, currently `physicsquiz-structured-v1`.

These markers let documents and tests check for the structured quiz interface
without parsing the class date string. The change is additive and does not alter
rendering, selection, shuffling, metadata validation, or class options.

Checkpoint 6B deliberately preserves the traditional class-option layer, the
current version-manifest syntax, five-option-only shuffling through `\choices`,
the `choiceoptions` shuffling guard, and existing metadata validation behaviour.
Changing any of those would require a broader compatibility audit and remains a
later design decision.

Before 6B began, `src/classes/physicsquiz.cls` already had a large unstaged
formatting diff plus a small non-whitespace marks-regex change. Checkpoint 6B
does not resolve or revert that pre-existing change.

PowerShell parser checks passed for the 6A and 6B runners, and the Phase 6B
runner passed in the normal MiKTeX environment with
`All Phase 6B tests passed.` The established Phase 4I/4J regression guard also
passed after the 6B production marker change:
`PASS expected failure: physicsquiz_version_already_active` followed by
`All Phase 4I/4J tests passed.`

### Checkpoint 6C - physicsquiz namespace discipline

Checkpoint 6C adds a source-level guard for the current `physicsquiz.cls`
modern-code boundary. It checks that:

* the class has one bounded `expl3` region;
* project-local internal functions and variables use the `__pq` module;
* public wrappers declared with modern document-command interfaces match the
  known supported surface;
* internal key families remain limited to `physicsquiz / question` and
  `physicsquiz / selection`;
* the legacy `\pqchoiceoptionsguard` bridge remains exactly one internal bridge;
  and
* the Phase 6B capability markers remain declared.

6C preserves existing author syntax and makes no intentional production
behaviour change. The pre-existing dirty formatting and marks-regex change in
`src/classes/physicsquiz.cls` remains outside this checkpoint.

PowerShell parser checks passed for `tests/run_phase6c_tests.ps1`, and the Phase
6C runner passed with `All Phase 6C tests passed.`

### Checkpoint 6D - marks decimal validation

Checkpoint 6D resolves the carried dirty marks-regex question. It keeps the
previously accepted leading-zero decimal form, such as `0.5`, and also accepts
the shorthand leading-dot form, such as `.5`.

Structured question metadata and marks filters now accept:

* integers, such as `1`;
* whole-number decimals, such as `1.5`;
* leading-zero fractional decimals, such as `0.5`; and
* leading-dot fractional decimals, such as `.5`.

Zero and zero-equivalent decimals, such as `0`, `0.0`, and `.0`, remain invalid.
This is a narrow validation improvement and does not change rendering,
selection order, shuffling, class options, question-bank storage, or version
manifests.

PowerShell parser checks passed for `tests/run_phase6d_tests.ps1`, and the Phase
6D runner passed with `All Phase 6D tests passed.`

### Checkpoint 6E - physicsquiz author usability pass

Checkpoint 6E combines the planned error-message cleanup and structured
interface usability pass. It improves what a local author sees while creating or
debugging a quiz bank, without changing the public quiz syntax.

The class now gives more concrete help for common metadata mistakes:

* missing required question metadata;
* malformed stable IDs;
* duplicate stable IDs;
* invalid marks values;
* invalid correct-option labels;
* invalid difficulty filters;
* invalid marks filters;
* empty metadata filters;
* filters that match no questions; and
* invalid random count or seed values.

The messages include copyable examples such as `id=waves-001`, `marks=0.5`,
`marks=.5`, `\quizselectall`, and `\quizselect[topic=waves]`. The same failure
paths emit `PQ6E-HINT:*` log markers so nonstop local builds still leave a plain
diagnostic trail.

`examples/physicsquiz/starter_quiz_bank.tex` is now a minimal structured
quiz-bank starter document. It demonstrates title metadata, two question
records, adjacent solution records, integer and fractional marks, tags, an
optional outcome, and generated questions, answer key, and solutions.

6E preserves the existing author syntax. No options, commands, environments,
selection behaviour, shuffling behaviour, record storage, or rendering defaults
are changed.

PowerShell parser checks passed for `tests/run_phase6e_tests.ps1`, and the Phase
6E runner passed with `All Phase 6E tests passed.`

### Checkpoint 6F - versioned-paper review guard

Checkpoint 6F closes the Phase 4 carry-forward item for the representative
versioned PHY104 paper. It keeps the authored example untouched during
verification by generating temporary Version A and Version B copies under
`build/tests/phase6f_versioned`.

The 6F runner proves that:

* both generated papers compile from the same source structure;
* the intended version recipe is activated for each paper;
* each generated paper selects 30 records;
* Version A and Version B differ in selected question set;
* Version A and Version B differ in option permutations;
* answer-key markers agree with the answer printed in generated solution
  headings; and
* the generated PDFs differ in byte size as a weak rendered-output signal.

`physicsquiz.cls` now emits `PQ6F-SOLUTION-ANSWER:<id>=<letter>` while rendering
worked solutions. This is a log-level test marker for the already-rendered
solution heading answer and does not alter author syntax, selection, shuffling,
or PDF layout.

PowerShell parser checks passed for `tests/run_phase6f_tests.ps1`, and the Phase
6F runner passed with `All Phase 6F tests passed.`

### Checkpoint 6G - closure and governance

Checkpoint 6G closes Phase 6 with no production class or package changes.

The phase delivered practical modernization where it improved safety,
diagnostics, source discipline, and local author usability:

* a modern-interface learning scaffold;
* public `physicsquiz.cls` capability markers;
* a namespace guard for the modern-code boundary;
* improved marks decimal validation;
* clearer structured-bank author errors;
* a copyable starter quiz-bank document; and
* a generated versioned-paper review guard.

The phase deliberately preserved the traditional class-option layer, the
structured quiz-bank author syntax, the five-option `\choices` shuffling
contract, the `choiceoptions` shuffling guard, the version-manifest syntax, the
`__pq` internal namespace, and the established visual-output expectations.

Class-option modernization remains possible, but it is carried forward only as
an optional compatibility review because it touches the oldest author-facing
entry point.

## Phase 7 status

Phase 7 is in progress. It focuses on local author workflow, starter templates,
repository hygiene, distribution readiness, and collaboration.

### Checkpoint 7A - workflow and collaboration opening

Checkpoint 7A is documentation-only. It adds:

* `README.md`, the first user-facing repository landing page;
* `docs/AUTHOR_WORKFLOW.md`, covering local setup, starter choices, build
  commands, Git hygiene, and GitHub collaboration; and
* `PHASE7_CHECKPOINT_7A.md`.

The GitHub collaboration question is accepted as part of Phase 7. Before the
repository is pushed for collaborators, the project should decide repository
visibility, branch policy, pull-request expectations, artifact policy, issue
labels, release boundaries, and collaborator setup requirements.

The recommended first shape is private GitHub collaboration, feature branches,
pull requests once more than one person edits, source-only commits by default,
and `README.md` plus `docs/AUTHOR_WORKFLOW.md` as the onboarding path.

### Checkpoint 7B - starter inventory and GitHub checklist

Checkpoint 7B is documentation-only. It adds:

* `docs/STARTER_INVENTORY.md`, separating true copyable starters from
  representative examples;
* `docs/GITHUB_COLLABORATION.md`, recording the private-first collaboration
  checklist; and
* `PHASE7_CHECKPOINT_7B.md`.

The starter inventory confirms that larger course-shaped documents should stay
as representative examples rather than blank starting points.

### Checkpoint 7C - copyable starter set

Checkpoint 7C adds a small starter for each major author outcome:

* structured quiz bank;
* versioned quiz paper;
* student study notes;
* engineering project notebook;
* science notes document; and
* standalone vector-workbook module.

It also adds `tests/run_phase7c_starter_tests.ps1`, which builds only the starter
documents and checks their log markers. This gives authors a fast confidence
check without running the historical regression suites.

### Checkpoint 7D - collaboration packaging

Checkpoint 7D adds the first GitHub-ready collaboration files:

* `CONTRIBUTING.md`;
* `.github/PULL_REQUEST_TEMPLATE.md`;
* issue templates for bugs, starter/example requests, and workflow questions;
  and
* `PHASE7_CHECKPOINT_7D.md`.

This checkpoint prepares the repository for private-first GitHub collaboration
without pushing to GitHub, adding CI, or changing class/package behaviour.

### Checkpoint 7E - release readiness boundary

Checkpoint 7E records how the project should first be shared:

* use the source repository as the first release vehicle;
* keep generated PDFs/logs out of ordinary commits;
* attach optional preview PDFs to GitHub releases later;
* derive any author kit from `docs/AUTHOR_KIT_MANIFEST.md`; and
* use the Phase 7C starter runner as the first author-kit verification command.

It adds `docs/RELEASE_READINESS.md`, `docs/AUTHOR_KIT_MANIFEST.md`, and
`PHASE7_CHECKPOINT_7E.md`.

### Checkpoint 7F - GitHub push checklist

Checkpoint 7F adds `docs/GITHUB_PUSH_CHECKLIST.md`, a step-by-step manual
runbook for:

* confirming local readiness;
* creating a private GitHub repository;
* adding the `origin` remote;
* pushing `main`;
* inspecting the rendered README, contribution guide, issue templates, and pull
  request template; and
* giving first collaborators the correct starter and workflow links.

It does not push to GitHub, install a GitHub plugin, or add CI.

## Phase 2 status

Phase 2 is complete. It audited, documented, and improved semantic document
interfaces without changing the established visual identity. A read-only usage
and compatibility audit was completed for `\choices`, `namedformula`, the theorem
environments, the semantic note boxes, and the `answerkey` environment.

Its checkpoints delivered the semantic `choiceoptions` environment with the
five-argument `\choices` compatibility wrapper; `\formularef` and hidden
descriptive titles for `namedformula`; isolated regression coverage for the
`studentnotes` theorem and note-box interfaces, all twenty `otscience`
semantic-box interfaces, and the generic `otbox` plus fifteen `otengineering`
wrappers; `docs/PUBLIC_INTERFACES.md`; and helper smoke tests for
`otengineering` and `studentnotes`, which detected and led to the correction of
the `\remembernote` label overflow. Question 60's column-overlap defect was fixed
and the representative quiz settled at 23 pages.

Full checkpoint detail is preserved in `CHANGELOG.md` under Phase 2.

## Phase 3 status

Phase 3 is complete. It added an additive output-control layer to
`physicsquiz.cls` without creating a question bank or changing the representative
quiz source.

### Output and presentation architecture

* `full` is the default primary mode.
* `student`, `teacher`, `solutions`, and `answerkey` are the alternative primary
  modes.
* Primary modes are mutually exclusive and conflicting selections produce a
  descriptive class error.
* `colour` is the default presentation mode; `color` is an alias.
* `print` is orthogonal to the primary mode and maps the established public
  palette to economical, high-contrast greys.
* Conflicting presentation selections produce a descriptive class error.
* Article options not owned by `physicsquiz` continue to pass through to
  `article`.

### Semantic rendering boundary

The class provides `quizquestioncontent`, `quizanswerkeycontent`,
`quizsolutioncontent`, `quizteachercontent`, and `quizreferencecontent`. These
gates select complete authored blocks according to the primary mode. In Phase 3
they did not store question records, collect correct answers, calculate totals,
or perform question selection. Phase 4 added those capabilities as separate
commands that are placed *inside* the gates; the gates themselves are unchanged.

### Metadata and labels

* `\quizversion{<label>}` displays version metadata on the title and running
  header.
* Version metadata is display-only and does not assign questions to versions.
* `\quizmarks{<value>}` appears in full, student, and teacher outputs when used.
* `\quizdifficulty{<label>}` appears in full and teacher outputs when used.
* Marks and difficulty remain presentation hooks, distinct from the structured
  `marks` and `difficulty` record keys added in Phase 4.

### Acceptance evidence

* All 21 positive Phase 3D test drivers passed in the repository-local MiKTeX
  environment.
* All ten semantic colour/print combinations produced the exact expected marker
  sets.
* Both deliberate conflict drivers failed with their intended class errors.
* Positive logs contained no LaTeX warnings, overfull boxes, or underfull boxes.
* Version A/B output, marks, difficulty, colour, print, and the `color` alias were
  verified.
* The representative quiz retained the accepted 23-page default rendering and
  kept Question 60 with all five choices.

### Phase 4 boundary as set by Phase 3

Phase 3 required Phase 4 to begin with a read-only comparison of a lightweight
custom question record and `xsim`, followed by a small structured proof of
concept, and forbade migrating the representative quiz until the proof of concept
compiled and the architecture was reviewed. That boundary was honoured:
Checkpoint 4A compared the options, 4B proved the facade on four questions
without touching the production class, 4C promoted it only after review, and the
full migration waited until 4G.

`07_final_mixed_practice_bank.tex` belongs to the separate `otscience` workbook
ecosystem and was correctly not treated as a `physicsquiz` question-bank
precedent.

## Phase 4 status

Phase 4 is complete. It separated question storage, selection, and rendering, and
migrated the complete representative quiz into the structured interface.

### Architecture

Three stages, each with its own commands:

1. **Declaration.** `quizbank` declares records without rendering. Each record is
   a `quizquestion` with required `id`, `topic`, `difficulty`, `marks`, `correct`,
   and `tags` keys and an optional `outcome`, followed immediately by exactly one
   `quizsolution`.
2. **Selection.** `\quizselectids`, `\quizselect`, `\quizselectall`,
   `\quizselectrandom`, and `\quizclearselection` build an ordered selection.
   Selection commands append without duplicating, and preserve a record's first
   selected position.
3. **Rendering.** `\printquizquestions`, `\printquizanswerkey`,
   `\printquiztopicreport`, `\printquizsolutions`, and `\printquizteacherreport`
   consume only the current selection, in selection order, so booklet, key,
   solution, report, and mark totals always agree.

`quizquestionbank` remains as a declare-select-print wrapper so Checkpoint 4C
documents need no rewrite.

### Validation

Descriptive class errors cover missing required keys; stable IDs outside
lowercase letters, digits, and single hyphens; duplicate IDs; non-positive or
malformed marks; invalid correct-option labels; orphan, duplicate, and
non-adjacent solutions; unknown IDs; empty ID lists; empty selections; empty or
invalid metadata filters; filters matching nothing; invalid random counts and
seeds; and candidate pools too small for a requested count.

### Reproducibility contract

The same declared bank, declaration order, existing selection state, metadata
filter, count, and seed produce the same ordered stable IDs. The implementation
uses a class-owned Park-Miller generator with Schrage's overflow-safe update,
rejection sampling, and a Fisher-Yates permutation, and depends on no clock, job
name, engine random primitive, or ambient random state. The algorithm marker is
`park-miller-v1`. Different seeds may coincide by chance.

### The migrated bank

`examples/physicsquiz/banks/phy104_full_question_bank.tex` holds all 60 records
in original declaration order, totalling 120 marks. Stable IDs retain the
original question numbers, for example `phy104-osc-001`, `phy104-nm-026`,
`phy104-wave-053`, `phy104-opt-060`. The metadata scheme is:

| Original range | Difficulty | Marks per question |
| --- | --- | ---: |
| 1--20 | foundation | 1 |
| 21--40 | applied | 2 |
| 41--60 | challenge | 3 |

Each repeated five-question block maps to oscillations, normal modes, waves and
sound, or optics. Every record also carries question-specific tags and a learning
outcome. Every record preserves the original stem, all five choices in order, the
correct answer, and the complete worked reasoning after the legacy topic label
was moved into metadata.

### Acceptance evidence

* Checkpoint 4B stored four real questions, derived the answer sequence C, B, B,
  E, and totalled 8 marks without changing the production class.
* Checkpoint 4C passed five output modes, one-column and optional-outcome
  fixtures, and ten deliberate validation failures.
* Checkpoint 4D passed ten positive selection drivers, reordered IDs in all five
  output modes, topic, difficulty, marks and match-all tag filters, append,
  de-duplication, clearing, select-all, and seven deliberate failures.
* Checkpoint 4E passed ten positive drivers, same-seed reproducibility, a
  different-seed comparison, filtered and append selection, and seven deliberate
  failures.
* Checkpoint 4F verified all twelve pilot records against the legacy source.
* Checkpoint 4G verified all 60 stems, all 300 choices, all 60 answers, all 60
  worked solutions, record order, stable IDs, topic, difficulty and mark
  metadata, tags, and outcomes against the legacy source; complete
  declaration-order selection; three 20-question difficulty bands; deliberately
  reordered ID selection; combined topic-and-difficulty filtering; tag filtering
  across bands; reproducible 12-question random selection under seed 104;
  answer-key and solution alignment; and the 60-record, 120-mark totals.
* The 4G runner reruns 4F, which reruns 4E, 4D, 4C, and 3D. The complete chain
  passed in the repository-local MiKTeX environment on 6 August 2026, ending with
  `All Phase 4G full-migration checks passed.` and `All Phase 4G tests passed.`
* Positive logs contain no LaTeX warnings, `xsim` warnings, overfull boxes, or
  underfull boxes.
* The complete structured example compiles cleanly at 25 pages.
* The legacy quiz remained pixel-identical at 23 pages through Checkpoints 4C,
  4D, and 4E.

### Checkpoint 4H — generated-booklet constants box

The Phase 4G visual review found that the complete structured example rendered no
constants box. `\quizconstants` only stores its text; `\constantsbox` renders it,
and `\makequiztitle` never calls it. The manually authored quiz calls
`\constantsbox` explicitly after its section heading, but a structured document
cannot reproduce that placement, because `\printquizquestions` emits its own
heading and then opens `multicol` with no author hook in between.

`\printquizquestions` therefore now renders `\constantsbox` itself, immediately
after its heading, whenever `\quizconstants` has been set. No pre-Phase-4
document calls `\printquizquestions`, so no existing quiz can receive a
duplicated box. The complete structured example remains 25 pages with the box
present and clean logs; the `all`, `foundation`, `ids`, and `random`
full-migration drivers are byte-identical, because none of them set
`\quizconstants`.

### Checkpoints 4I and 4J — shuffling and versions

`\quizshuffleoptions{<seed>}` permutes the five slots of the `\choices`
interface for every selected record, before rendering, so the answer key is
correct even in `answerkey` output where no booklet is typeset. A record's
permutation derives from the seed and the record's declaration index, so it does
not depend on selection order. `\quizcorrectletter` expands to the effective
letter, and all sixty worked solutions now use it instead of a hard-coded
letter.

`\quizdefineversion{<label>}{<recipe>}` and `\quizuseversion{<label>}` give a
version label a question-level meaning for the first time: a version names its
selection recipe and its own shuffle seed, and one compile produces one paper.
This closes the Phase 3 deferral of version-dependent question assignment.

Ten positive drivers, eight expected-failure drivers, a Python checker, and
`run_physicsquiz_phase4ij_tests.ps1` cover the work. The unshuffled
full-migration drivers remain byte-identical, and the sixty-solution rewrite
changes no unshuffled output.

### Deferred to a later phase

* Balancing a random paper to a target mark total.
* Retiring or replacing the legacy `PHY104_Exam revision.tex`.
* A pagination strategy for long generated answer keys.
* Any use of `xsim`'s own selection, collection, or grading facilities beyond
  storage.

### Phase 5 boundary

Phase 5 audits duplication across all four classes and the seven companion
packages, and designs a minimal shared-package architecture. It must not begin
by moving `physicsquiz` code: the class has just absorbed the largest addition in
its history, and any shared-code extraction should start from a coherent concern
that is genuinely duplicated across classes. Per `ROADMAP.md`, Phase 5 should
begin in a new chat with the complete class and package set attached.

## Phase 5 status

Phase 5 is complete. It audited duplication across the four classes and the
seven companion packages, then implemented a minimal shared-package architecture
for the OT side of the ecosystem.

### What the audit found

Across roughly 3,100 lines of active class and package source, the code that is
genuinely identical and live in more than one file amounts to about thirty
lines, and almost all of it sits between `otscience.cls` and
`otengineering.cls`:

* seven identical `\definecolor` lines, with `OTLight` deliberately divergent;
* one identical four-key `\hypersetup` block;
* one identical `geometry` option string, `margin=1in`;
* three identical `fancyhdr` lines;
* two identical `autorefname` provisions; and
* nine `\RequirePackage` lines common to all four classes.

`physicsquiz.cls` and `studentnotes.cls` share no colour value, no box
definition and no metadata idiom with the OT pair, and no two classes are ever
loaded into the same document, so none of this duplication is a collision risk.
It is a maintenance cost only.

The value of Phase 5 is therefore not line reduction. It is severing the
class-to-package cycle, which is the ecosystem's only structural defect.
Extraction is the mechanism; the cycle is the reason.

### Target architecture

* `ottheme.sty` — the OT colour palette and the shared hyperlink colour policy.
  It is pure values and moved first as Checkpoint 5B.
* `otboxes.sty` — `otscibox` and `otsciboxnosplit`. The only behavioural
  interface a companion package borrows from a class, so moving it is what
  actually severs the cycle.
* `otcore.sty` — shared package loading and page furniture for `otscience.cls`
  and `otengineering.cls` only. The weakest of the three; sequenced last and
  treated as optional.

`otmath` as a fourth package is rejected. Not extracted: any `physicsquiz.cls`
code, the `studentnotes` palette, boxes and theorem environments, the 42
semantic box wrappers, the 18 metadata setters, all four `\titleformat` blocks,
the three self-contained companion packages, the `\providecommand` fallback
block in `00_common_setup.tex`, and `src/legacy/otscience.sty`.

### Checkpoint 5A — the OT-side regression harness

Checkpoint 5A refactors nothing. Phase 5 changes only the side of the ecosystem
that had no runner, so chaining the accepted `physicsquiz` suites proves nothing
about a Phase 5 change — it is a guard, not a proof. Building the proof after
the first extraction would repeat the Phase 4 pattern of a harness shaped to
agree with the change it was written beside.

`tests/run_ot_phase5_tests.ps1` runs the accepted Phase 4I/4J chain as the
untouched-side guard, builds eighteen OT documents into the mirrored `build/`
tree, and records or verifies a baseline through `tests/check_ot_baseline.py`.

The OT side cannot assert zero diagnostics the way the `physicsquiz` runners do,
because `examples/otengineering/test.tex` carries an accepted underfull box and
`examples/studentnotes/Optics.tex` emits a `hyperref` warning. The assertion is
instead no change from the recorded baseline: page counts, per-class diagnostic
counts and the rendered-text hash are hard failures; PDF byte size is a warning.

### Checkpoint 5A acceptance evidence

* 18 documents baselined, 140 pages, all 18 verified by rendered text.
* The recorded baseline reproduces itself exactly on an unchanged rebuild.
* Both palette probes reported their full colour counts, 10 and 8.
* `otpractice_standalone` failed with `Environment otscibox undefined`, as the
  cycle witness requires.
* The accepted Phase 4I/4J chain passed end to end.

### Checkpoint 5B — shared OT theme

Checkpoint 5B introduces `src/packages/ottheme.sty` as the owner of the shared
OT palette and hyperlink policy. `otscience.cls` now loads this package instead
of defining those values inline. `otengineering.cls` also loads it, then
re-declares `OTLight` as `#F3F4F6` so the documented engineering background
divergence remains deliberate rather than accidental.

`otnotation.sty`, `otmath.sty`, and `otfigures.sty` now load `ottheme`
directly. This removes their colour dependency on `otscience.cls`. A new
compile-only smoke fixture, `tests/ot_theme_package_smoke.tex`, loads those
three packages from an ordinary `article` document and emits `OT5B-SMOKE`
markers for the runner.

A cross-day rebuild exposed a flaw in the Checkpoint 5A text hash: documents
using `\today` or `\DTMtoday` changed rendered text merely because the calendar
date changed from the manifest's recorded date. The checker now keeps the strong
hash assertion but retries after shifting only the current rendered date back to
the manifest date. Fixed historical dates remain protected.

Python and PowerShell syntax checks passed in this Codex shell. The full
checkpoint command also passed in the normal MiKTeX environment, ending with
`PASS expected failure: otpractice_standalone` and
`All OT Phase 5 tests passed.`

### Checkpoint 5C — shared OT boxes

Checkpoint 5C introduces `src/packages/otboxes.sty` as the owner of
`otscibox` and `otsciboxnosplit`. The extracted definitions keep the accepted
box behaviour: `otscibox` is breakable and asks for eight baseline lines before
starting, while `otsciboxnosplit` is indivisible and asks for twelve.

`otscience.cls` now loads `otboxes` and keeps the semantic science wrappers
locally. `otpractice.sty` also loads `otboxes` directly, so its `practice`,
`drillbox`, `recallbox`, and `examquestion` environments no longer depend on
`otscience.cls`.

Two compile-only smoke fixtures enforce the new capability:
`tests/ot_boxes_package_smoke.tex` loads `otboxes` directly and exercises both
base boxes, while `tests/otpractice_standalone.tex` has moved from expected
failure to positive standalone package smoke.

Direct MiKTeX smoke builds passed for `tests/ot_boxes_package_smoke.tex` and
`tests/otpractice_standalone.tex`, emitting `OT5C-SMOKE:OTBOXES` and
`OT5C-SMOKE:OTPRACTICE`. The full checkpoint command passed in the normal MiKTeX
environment with `All OT Phase 5 tests passed.`

### Checkpoint 5D — cleanup closure

Checkpoint 5D is closed as a no-op source checkpoint. The originally planned
work, `otengineering.cls` adopting `ottheme` while preserving
`OTLight=#F3F4F6`, was completed early in Checkpoint 5B. The remaining
class-to-package cycle was completed in Checkpoint 5C when `otboxes.sty` became
the owner of `otscibox` and `otsciboxnosplit`.

No additional class or package extraction is needed for 5D. The remaining
shared-code question is `otcore.sty`, which concerns package setup and page
furniture rather than theme or box ownership.

### Checkpoint 5E — shared OT core helpers

Checkpoint 5E introduces `src/packages/otcore.sty` for shared setup and page
furniture helpers used by `otscience.cls` and `otengineering.cls`. It loads the
common structural packages: `geometry`, `titlesec`, `fancyhdr`, `enumitem`,
`tabularx`, `array`, and `datetime2`.

The package also provides three class-facing helpers:
`\otcorelistdefaults`, `\otcorepagestyle`, and `\otcoresectionstyles`.
`otscience.cls` and `otengineering.cls` pass their own established values, so
the two classes keep separate headers, header-rule widths, section label
spacing, and subsubsection colours.

`tests/ot_core_package_smoke.tex` loads `ottheme` and `otcore`, exercises the
three helper commands, and emits `OT5E-SMOKE:OTCORE`. PowerShell syntax checks
passed for the Phase 5 runner, and direct MiKTeX builds passed for the 5E core
smoke plus the science and engineering box compatibility fixtures. The full
checkpoint command passed in the normal MiKTeX environment with
`All OT Phase 5 tests passed.`

### Checkpoint 5F — governance closure

Checkpoint 5F closes Phase 5 without another behavioural extraction. The three
new shared packages now declare the agreed kernel floor,
`\NeedsTeXFormat{LaTeX2e}[2022-06-01]`, while retaining semantic package version
`v0.2`.

The public-interface record now names the shared package support boundary:
pdfLaTeX is supported, LuaLaTeX and XeLaTeX are expected but untested, and the
shared packages are ecosystem hooks rather than ordinary document-author syntax.

Two governance decisions are closed. Generated PDFs, logs and auxiliary files
remain build artifacts rather than Phase 5 source. The `physicsquiz.cls`
semantic-version idea is carried forward to Phase 6 or a dedicated quiz
governance checkpoint, because Phase 5 deliberately leaves `physicsquiz.cls`
untouched and uses the Phase 4 chain only as a guard.

### Three defects found by running the harness, not by writing it

1. The runner announced no mode, so an invocation without `-Record` silently
   verified and failed later with a misleading message.
2. The baseline parser could not read a real MiKTeX log. TeX hard-wraps log lines
   at `max_print_line`, and a repository path always wraps the `Output written
   on` summary line. The synthetic test fixtures used short paths and never
   reached the wrap — a fixture unrepresentative of production, which is the
   exact failure mode the harness exists to prevent.
3. OneDrive stamps a mark-of-the-web on re-hydrated files, and PowerShell then
   refuses to load the older chained runners. The runner now pre-checks all seven
   and names `Unblock-File` as the remedy.

Each would otherwise have surfaced mid-extraction wearing the costume of a real
regression.

### Known limitations of the Phase 5 harness

* Box geometry is only partly covered. A changed `\Needspace` moves a page break
  and fails on page count, but a changed `arc` or `boxrule` moves neither glyphs
  nor pages. Checkpoint 5C adds standalone box smokes; final review should still
  visually inspect at least one rendered box, as the Phase 4G review did.
* `examples/studentnotes/Optics.tex` is baselined with its independent
  uncommitted modification in place. Correct for detecting drift within Phase 5,
  but the recorded numbers describe the modified file rather than `HEAD`.
* The combined workbook loads `silence`, so its empty diagnostic record
  understates what the build reports.
* The guard roughly doubles the wall-clock time of a full run.

### Completed Phase 5 checkpoints

Checkpoint 5B is complete, including the planned `otengineering.cls` adoption
and `OTLight` override that had originally been listed as 5D. Checkpoint 5C is
complete. Checkpoint 5D is closed as a no-op source cleanup stage. Checkpoint 5E
is complete. Checkpoint 5F is complete as governance closure.

* **5B** — `ottheme.sty`. Complete; frees `otnotation`, `otmath` and
  `otfigures`.
* **5C** — `otboxes.sty`. Complete; frees `otpractice` and moves
  `otpractice_standalone` into the positive list.
* **5D** — cleanup closure. Complete; no additional source behavior changes.
* **5E** — `otcore.sty`. Complete; shares setup and page-furniture helpers
  between `otscience.cls` and `otengineering.cls`.
* **5F** — governance closure. Complete; package support policy, generated-output
  policy, public-interface finalization and Phase 6 carry-forward decisions are
  recorded.

## Session handover log

### Session 0 — Project definition

* Established the staged learning and refactoring plan.
* Confirmed that MiKTeX, pdfTeX, latexmk, and LaTeX Workshop are working.
* Established local project folders as the primary working copy.
* Agreed to preserve visual identity and backward compatibility.
* No source files were modified.

### Session 1 — Initial Phase 0 audit

* Inspected the four classes, supplied documents, modules, and reference PDFs.
* Inventoried the public commands and environments.
* Audited direct package dependencies.
* Identified missing shared setup, companion packages, and diagram fragments.
* Recorded layout, performance, namespace, and interface risks.
* No source files were modified.

### Session 2 — Phase 0 evidence completion

* Inspected all seven OT companion packages and `00_common_setup.tex`.
* Confirmed that the workbook source set is complete.
* Distinguished the active `otscience.cls` architecture from the legacy `otscience.sty`.
* Confirmed the successful 30-page workbook build from its historical log.
* Recorded the workbook warnings and the Question 60 column-splitting defect.
* No source files were modified.

### Session 3 — Repository preparation

* Corrected an initially misplaced Git repository created above the intended root.
* Established `LaTeX-Lab` as the dedicated repository root.
* Reorganised the copied sources into `src/classes`, `src/packages`, and `src/legacy`.
* Established one example folder for each active class architecture.
* Prepared the repository for the baseline commit and the Phase 0 tag.

### Session 4 — Phase 1 LaTeX Workshop workflow

* Added and verified the shared repository-level `.latexmkrc`.
* Added and verified project-local LaTeX Workshop settings.
* Established the mirrored `build/` output structure.
* Verified all four active class architectures and both workbook build forms.
* Verified forward and inverse SyncTeX navigation, clean rebuilding, automatic
  compilation, ChkTeX, and explicit `latexindent` formatting.

### Session 5 — Phase 2 choices interface

* Completed the usage and compatibility audit of the semantic interfaces.
* Confirmed 60 legacy `\choices` calls in the representative physics quiz.
* Identified the unbreakable legacy choices table as the cause of the Question 60
  column-overlap defect.
* Added the flexible `choiceoptions` environment and preserved `\choices` as a
  wrapper.
* Confirmed that Question 60 now renders without column overlap.

### Session 6 — Phase 2 named-formula interface

* Preserved `F<section>.<formula>` numbering and section-based resets.
* Made the descriptive title available to `\nameref` without displaying it.
* Added `\formularef` and an isolated compatibility test.

### Session 7 — Studentnotes theorem and note-box compatibility

* Added isolated regression coverage for the theorem and note-box interfaces.
* Verified counters, resets, cross-references, appearance, and page boundaries.
* Confirmed that no class change was required.

### Session 8 — OTScience semantic-box compatibility

* Added regression coverage for all twenty semantic-box interfaces.
* Verified titles, pagination behaviour, and the workbook compatibility layer.
* Rebuilt the standalone and combined vector workbooks successfully.

### Session 9 — OTEngineering semantic-box compatibility

* Added coverage for the generic `otbox` interface and all fifteen wrappers.
* Strengthened the pagination probes after they proved insufficient.
* Rebuilt the representative engineering notebook successfully.

### Session 10 — Public-interface baseline and helper verification

* Documented the supported public interfaces of all four active classes.
* Added helper smoke tests and corrected the `\remembernote` label overflow.
* Completed the residual class and vector-workbook diagnostic corrections.
* Completed Phase 2.

### Session 11 — Phase 3 assessment-output architecture

* Audited the 60-question representative quiz as the compatibility baseline.
* Defined the boundary between Phase 3 rendering and Phase 4 question storage.
* Added mutually exclusive primary output modes, semantic section gates,
  independent colour/print presentation, version metadata, and marks/difficulty
  labels.
* Added a shared assessment fixture, the semantic-marker checker, and the
  PowerShell runner.
* Verified the complete local Phase 3D matrix and the representative default
  output.
* Completed Phase 3.

### Session 12 — Phase 4 architecture, production interface, selection, randomisation

* Compared a lightweight custom question record with `xsim` as a read-only study
  and chose the `xsim`-backed facade.
* Proved the facade as a test-only `.sty` over four real questions, without
  changing the production class.
* Promoted the accepted facade into `physicsquiz.cls` as the production
  structured-question interface, with full metadata validation.
* Separated declaration, deterministic selection, and rendering.
* Added seeded reproducible random selection with a class-owned Park-Miller
  generator.
* Introduced `expl3` programming into the class ahead of Phase 6.
* Made `quizquestions` support one column and corrected the 4C runner's
  `Select-String` matching.
* Verified the complete 4C, 4D, and 4E matrices, including 24 deliberate
  failures, against the accepted Phase 3D suite.
* Preserved and excluded the independent modification to
  `examples/studentnotes/Optics.tex`.

### Session 13 — Phase 4F real-question migration pilot

* Migrated twelve real questions covering every topic-by-difficulty combination.
* Verified stems, choices, choice order, correct options, and worked reasoning
  against the legacy source.
* Verified explicit-ID order, declaration order, and seed 104 reproducibility.
* Left the 60-question legacy quiz unmodified.

### Session 14 — Phase 4G complete migration

* Migrated all 60 records, totalling 120 marks, into
  `banks/phy104_full_question_bank.tex`.
* Added `PHY104_structured_revision.tex` as the complete structured example.
* Added nine full-migration drivers, the full-migration checker, and the 4G
  runner.
* Split the generated answer key into three 20-question difficulty bands because
  a single 60-entry key exceeds one page.
* Ran the complete 4G → 4F → 4E → 4D → 4C → 3D chain successfully in the local
  MiKTeX environment.
* Kept the legacy `PHY104_Exam revision.tex` in place as the fidelity baseline.
* Preserved and excluded the independent modification to
  `examples/studentnotes/Optics.tex`.

### Session 15 — Phase 4G review and Phase 4H constants box

* Confirmed the Phase 4G runner ending locally with both expected lines.
* Performed the mandated visual review against the legacy PDF and found the
  missing constants box.
* Committed Phase 4G as `19e816b` and the governance records as `5dc4a0b`.
* Removed draft scaffolding that had been pasted into `CHANGELOG.md`.
* Restored the constants box inside `\printquizquestions` as Checkpoint 4H and
  verified the complete example and four full-migration drivers.
* Recorded the mixed CRLF/LF line endings in `physicsquiz.cls` as a formatting
  hazard and added `.gitattributes`.
* Preserved and excluded the independent modification to
  `examples/studentnotes/Optics.tex`.

### Session 16 — Phase 4I and 4J

* Confirmed that all sixty solutions cited their answer letter once and agreed
  with the record metadata before rewriting them.
* Added seeded option shuffling, the effective-letter accessor, and the
  `choiceoptions` guard.
* Added the version manifest and made `\quizversion` denote a real paper.
* Added ten positive drivers, eight expected-failure drivers, a checker, and a
  runner.
* Verified reproducibility across output modes and the unchanged unshuffled
  output.
* Preserved and excluded the independent modification to
  `examples/studentnotes/Optics.tex`.

### Session 17 — Phase 5 audit and Checkpoint 5A

* Completed the read-only duplication and dependency audit of all four classes
  and all seven companion packages.
* Established that the genuinely identical live duplication is about thirty
  lines, almost entirely between `otscience.cls` and `otengineering.cls`.
* Established that the class-to-package cycle affects four of the seven
  packages, not all seven, and that it is a use-time rather than a load-time
  cycle.
* Agreed the three-package target architecture and rejected a fourth.
* Resolved the kernel, engine, versioning and legacy-retirement decisions.
* Added the OT-side regression harness, the baseline manifest, the two palette
  probes and the cycle witness as Checkpoint 5A, changing no file under `src/`.
* Fixed three harness defects found by running it: a silent mode, a log parser
  that could not read a real MiKTeX log, and an unhandled mark-of-the-web.
* Preserved and excluded the independent modification to
  `examples/studentnotes/Optics.tex`.

### Session 18 — Checkpoint 5B shared theme

* Added `ottheme.sty` as the shared OT palette and hyperlink-policy package.
* Moved `otscience.cls`, `otengineering.cls`, `otnotation.sty`, `otmath.sty`
  and `otfigures.sty` onto `ottheme`.
* Preserved the documented `otengineering.cls` `OTLight=#F3F4F6` divergence
  with a local override.
* Added the standalone 5B smoke document for `otnotation`, `otmath` and
  `otfigures`.
* Fixed the OT baseline checker so cross-day rebuilds do not fail solely because
  `\today` or `\DTMtoday` changed.
* Added a shared PowerShell log-read retry helper after the Phase 4 guard hit a
  transient Windows lock on `physicsquiz_mode_solutions.log`.
* Python and PowerShell syntax checks passed in this Codex shell.
* The full Phase 5 checkpoint command passed in the normal MiKTeX environment,
  ending with `PASS expected failure: otpractice_standalone` and
  `All OT Phase 5 tests passed.`

### Session 19 — Checkpoint 5C shared boxes

* Added `otboxes.sty` as the shared owner of `otscibox` and
  `otsciboxnosplit`.
* Moved `otscience.cls` onto `otboxes` while preserving the semantic science-box
  wrappers in the class.
* Moved `otpractice.sty` onto `otboxes`, removing its dependency on
  `otscience.cls`.
* Added a direct `otboxes` standalone smoke fixture and turned
  `otpractice_standalone` into a positive standalone smoke fixture.
* Updated the Phase 5 runner to build both 5C smokes and check their markers.
* Direct MiKTeX smoke builds passed for both 5C fixtures.
* The full Phase 5 checkpoint command passed in the normal MiKTeX environment.

### Session 20 — Checkpoint 5D cleanup closure

* Audited the post-5B/5C cleanup space.
* Closed 5D as a no-op source checkpoint because the planned engineering theme
  adoption happened in 5B and the remaining box cycle was resolved in 5C.
* Added `PHASE5_CHECKPOINT_5D.md`.
* Updated stale runner and project wording that still described the
  `otengineering.cls` `OTLight` override as deferred work.

### Session 21 — Checkpoint 5E shared core helpers

* Added `otcore.sty` for shared setup packages, list defaults, page furniture,
  and section-style helpers.
* Moved `otscience.cls` and `otengineering.cls` onto `otcore` while preserving
  their distinct page headers and heading styles.
* Added `ot_core_package_smoke.tex` and wired it into the Phase 5 runner with
  the marker `OT5E-SMOKE:OTCORE`.
* PowerShell syntax checks passed for the Phase 5 runner.
* Direct MiKTeX builds passed for the 5E core smoke and the two OT box
  compatibility fixtures.
* The full Phase 5 checkpoint command passed in the normal MiKTeX environment.

### Session 22 — Checkpoint 5F governance closure

* Added `PHASE5_CHECKPOINT_5F.md`.
* Wrote the agreed 2022-06-01 LaTeX kernel floor into `ottheme.sty`,
  `otboxes.sty`, and `otcore.sty`.
* Updated the public-interface record with the shared package support policy.
* Closed the generated-output policy: source fixtures, baseline manifests,
  checker output and smokes are the Phase 5 evidence; generated PDFs and logs
  remain build artifacts.
* Carried the `physicsquiz.cls` semantic-version idea forward to Phase 6 or a
  dedicated quiz governance checkpoint rather than changing that class inside
  the OT-only phase.
* Verified the 5F source change with direct MiKTeX package smokes for
  `ottheme`, `otboxes`, and `otcore`, plus parser and syntax checks. The full
  Phase 5 runner was attempted from this tool path after 5F but exceeded the
  command timeout before returning output.
* Marked Phase 5 complete.

### Session 23 — Checkpoint 6A conservative modernization opening

* Opened Phase 6 under the conservative modernization model.
* Added `PHASE6_CHECKPOINT_6A.md`.
* Added an isolated modern-interface learning scaffold,
  `tests/phase6_modern_interface_examples.tex`.
* Added `tests/run_phase6a_tests.ps1` to build the scaffold and check its marker
  lines.
* Verified the checkpoint in the normal MiKTeX environment:
  `All Phase 6A tests passed.`
* Made no production class or package behaviour changes.

### Session 24 — Checkpoint 6B physicsquiz capability marker

* Added public `physicsquiz.cls` version and capability markers:
  `\physicsquizclassversion`, `\physicsquizstructuredinterfaceversion`, and
  `\physicsquizstructuredinterfaceid`.
* Added semantic class version `v0.1` to the `physicsquiz.cls`
  `\ProvidesClass` line.
* Added `tests/physicsquiz_capability_marker_smoke.tex`.
* Added `tests/run_phase6b_tests.ps1`, which reruns 6A and checks the 6B marker
  smoke.
* Preserved class options, version-manifest syntax, shuffling behaviour,
  `choiceoptions` shuffling rejection, and metadata validation behaviour.
* Recorded the pre-existing dirty `physicsquiz.cls` state: a large formatting
  diff plus a small marks-regex change that 6B does not resolve.
* Verified the checkpoint in the normal MiKTeX environment:
  `All Phase 6B tests passed.`
* Confirmed the established Phase 4I/4J regression guard still passes after the
  production marker change.

### Session 25 - Checkpoint 6C physicsquiz namespace discipline

* Added `tests/check_physicsquiz_namespace.py`.
* Added `tests/run_phase6c_tests.ps1`, chaining the 6B checkpoint before the 6C
  namespace audit.
* Added `PHASE6_CHECKPOINT_6C.md`.
* Documented the `physicsquiz.cls` implementation namespace boundary in
  `docs/PUBLIC_INTERFACES.md`.
* Preserved the current public author syntax, the `__pq` internal module, and
  the `\pqchoiceoptionsguard` compatibility bridge.
* Left the pre-existing dirty marks-regex and formatting change out of scope.
* Verified the checkpoint with `All Phase 6C tests passed.`

### Session 26 - Checkpoint 6D marks decimal validation

* Resolved the carried marks-regex question by accepting both `0.5` and `.5`
  fractional marks.
* Updated both structured question metadata validation and marks-filter
  validation.
* Added `tests/physicsquiz_marks_decimal_smoke.tex`.
* Added `tests/run_phase6d_tests.ps1`, chaining the 6C checkpoint before the 6D
  marks smoke.
* Added `PHASE6_CHECKPOINT_6D.md`.
* Updated the public-interface record to spell out accepted marks forms.
* Verified the checkpoint with `All Phase 6D tests passed.`

### Session 27 - Checkpoint 6E physicsquiz author usability pass

* Improved author-facing validation help for missing metadata, invalid IDs,
  duplicate IDs, invalid marks, invalid correct labels, invalid filters,
  no-match filters, and invalid random values.
* Preserved the existing `physicsquiz.cls` author syntax and rendering
  behaviour.
* Added `examples/physicsquiz/starter_quiz_bank.tex` as a copyable structured
  quiz-bank starting point.
* Added expected-failure author-message fixtures for invalid IDs, invalid marks,
  and empty filters.
* Added `tests/run_phase6e_tests.ps1`, chaining the 6D checkpoint before the 6E
  starter and message checks.
* Added `PHASE6_CHECKPOINT_6E.md`.
* Verified the checkpoint with `All Phase 6E tests passed.`

### Session 28 - Checkpoint 6F versioned-paper review guard

* Closed the carried versioned-paper review item from Phase 4.
* Added generated Version A/B builds for `PHY104_versioned_paper.tex` so the
  source example does not need to be edited during verification.
* Added a checker for version activation, selected question-set differences,
  option-permutation differences, answer-key markers, and solution-heading
  answer markers.
* Added the internal `PQ6F-SOLUTION-ANSWER` marker to `physicsquiz.cls`.
* Added `PHASE6_CHECKPOINT_6F.md`.
* Verified the checkpoint with `All Phase 6F tests passed.`

### Session 29 - Checkpoint 6G Phase 6 closure

* Closed Phase 6 under the conservative modernization model.
* Recorded the Phase 6 delivered outcomes and deliberately preserved interfaces.
* Carried class-option modernization forward only as an optional future
  compatibility review.
* Added `PHASE6_CHECKPOINT_6G.md`.

### Session 30 - Checkpoint 7A workflow and collaboration opening

* Opened Phase 7 as local author workflow and distribution readiness.
* Added `README.md`.
* Added `docs/AUTHOR_WORKFLOW.md`.
* Added `PHASE7_CHECKPOINT_7A.md`.
* Accepted GitHub collaboration readiness as a Phase 7 workstream.

### Session 31 - Checkpoint 7B starter inventory and GitHub checklist

* Added `docs/STARTER_INVENTORY.md`.
* Added `docs/GITHUB_COLLABORATION.md`.
* Added `PHASE7_CHECKPOINT_7B.md`.
* Corrected the author workflow guide's structured PHY104 example path.
* Identified the next starter set: versioned quiz, student notes, engineering
  notes, science notes, and vector-workbook module.

### Session 32 - Checkpoint 7C copyable starter set

* Added the missing small starters:
  `examples/physicsquiz/starter_versioned_quiz.tex`,
  `examples/studentnotes/starter_notes.tex`,
  `examples/otengineering/starter_engineering_notes.tex`,
  `examples/otscience/starter_science_notes.tex`, and
  `examples/vector-workbook/starter_module.tex`.
* Added `tests/run_phase7c_starter_tests.ps1`, which builds the starter set and
  checks starter log markers.
* Added `PHASE7_CHECKPOINT_7C.md`.
* Updated `README.md`, `docs/AUTHOR_WORKFLOW.md`, and
  `docs/STARTER_INVENTORY.md` to distinguish true starters from larger examples.

### Session 33 - Checkpoint 7D collaboration packaging

* Added `CONTRIBUTING.md`.
* Added `.github/PULL_REQUEST_TEMPLATE.md`.
* Added GitHub issue templates for bug reports, starter/example requests, and
  workflow questions.
* Added `PHASE7_CHECKPOINT_7D.md`.
* Updated the README, author workflow guide, and GitHub collaboration checklist
  to reference the new collaboration packaging files.

### Session 34 - Checkpoint 7E release readiness boundary

* Added `docs/RELEASE_READINESS.md`.
* Added `docs/AUTHOR_KIT_MANIFEST.md`.
* Added `PHASE7_CHECKPOINT_7E.md`.
* Recorded the source repository as the first shareable release shape.
* Recorded that optional release PDFs should be attached to releases rather than
  committed as ordinary source.
* Recorded that any author kit should be generated from the manifest, not
  maintained as a second hand-edited copy.

### Session 35 - Checkpoint 7F GitHub push checklist

* Added `docs/GITHUB_PUSH_CHECKLIST.md`.
* Added `PHASE7_CHECKPOINT_7F.md`.
* Recorded the manual sequence for creating a private GitHub repository, adding
  `origin`, pushing `main`, inspecting rendered GitHub templates, and onboarding
  first collaborators.
* Linked the push checklist from the README, author workflow guide, GitHub
  collaboration checklist, and release-readiness guide.

## Next action

Phase 7 is open. Next:

1. Verify and commit Checkpoint 7F with careful staging so line-ending-only
   `physicsquiz.cls` noise and loose generated files are not included.
2. Decide whether to add a small combined-workbook starter or keep the workbook
   starter as a standalone module only.
3. Continue through the optional checklists one at a time: author kit build,
   release PDFs, GitHub Actions/CI, and combined workbook starter.

### Line-ending state, confirmed at the close of Checkpoint 5A

`git ls-files --eol` reports `i/lf` for all four classes, all seven companion
packages and the legacy package. The index is already normalised. The working
tree still holds CRLF for `otengineering.cls`, `physicsquiz.cls`,
`studentnotes.cls` and `src/legacy/otscience.sty`; that is cosmetic and resolves
on the next checkout.

Because the index is uniformly LF, an edit to any of those files produces a
content-only diff whether the editing tool writes LF or CRLF. The
`.gitattributes` hazard recorded in Session 15 is therefore closed, and no
renormalisation commit is required before Checkpoint 5B.
