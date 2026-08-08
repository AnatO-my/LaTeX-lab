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

**Phase 4 — Question-bank architecture — completed on 8 August 2026.**

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
  6 August 2026.
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
│   └── run_physicsquiz_phase3d/4c/4d/4e/4f/4g_tests.ps1
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

They currently depend on colours, boxes, or other interfaces defined by `otscience.cls`. They must therefore be treated as ecosystem components rather than independently loadable general-purpose packages.

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
* `\ProvidesClass` carries a date but no semantic version, so a document cannot
  test for the presence of the structured interface.
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

* Minimum supported LaTeX kernel or release date
* Whether support is limited to pdfLaTeX or extended to LuaLaTeX and XeLaTeX
* How much shared code should move into common OT packages
* Whether the modular workbook should retain its existing conditional structure or adopt `subfiles`
* Whether generated PDFs and selected logs should remain version-controlled after the baseline
* Naming and compatibility policy for public commands
* Accessibility target for future PDFs
* Release-versioning and tagging conventions, including whether `physicsquiz.cls`
  should now carry a semantic version
* When and how to retire the legacy `PHY104_Exam revision.tex`

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

### Deferred to a later phase

* Choice shuffling within a question.
* Assigning questions to multiple version labels from a version manifest.
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

## Next action

1. Complete the Phase 4G visual review — the complete booklet, the three band
   answer keys, the reordered-ID and seed-104 random PDFs, and a fidelity
   spot-check against the legacy PDF. Confirm in particular that Question 60
   still keeps all five options in one column and that no answer-key box
   overflows a page.
2. Commit Phase 4G as a source-only checkpoint: the bank, the structured example,
   the nine drivers, the shared driver content file, the checker, and the runner.
   Exclude the regenerated `PHY104_Exam revision.pdf` and `.log`, all other build
   artefacts, and `examples/studentnotes/Optics.tex`.
3. Commit the governance records — this file, `CHANGELOG.md`, and
   `docs/PUBLIC_INTERFACES.md` — as a separate documentation checkpoint.
4. Decide whether `physicsquiz.cls` should now carry a semantic version, and
   whether the repository should continue tracking generated example PDFs.
5. Decide when the legacy `PHY104_Exam revision.tex` is retired. It must not be
   replaced or deleted until the visual review is complete and recorded.
6. Begin Phase 5 in a new chat, with the complete class and package set attached,
   auditing duplication before moving any shared code.
