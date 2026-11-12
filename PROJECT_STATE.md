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

## Current state (12 November 2026)

* **Branch work:** the architecture refactor (`docs/architecture/PLAN.md`,
  phases A–F) is committed on `refactor/architecture-plan`; repository
  restructuring is on `chore/repo-structure`.
* **Layout:** classes in `src/classes/`, packages in `src/packages/` (layered:
  `otcolors` → `otlayout`/`otcore` → `ottheme` → presets and boxes →
  capability packages), frozen `src/legacy/`. Documentation map in
  `README.md`; history in `docs/history/`.
* **Tests:** entry points are listed in `tests/README.md`;
  `tests/run_all_tests.ps1` runs every active suite.
* **Releases:** `docs/release/RELEASE_PROCESS.md`; draft notes for the refactor
  in `docs/architecture/RELEASE_NOTES_ARCHITECTURE_REFACTOR.md`.
* **History:** phase status, decisions and the session handover log are in
  `docs/history/PROJECT_LOG.md`; checkpoint records in
  `docs/history/checkpoints/`.

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
│   │   └── test.tex
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
│   │   └── Optics.tex
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

The architecture refactor (docs/architecture/PLAN.md Phase B, 2026-11-11) adds
`src/packages/otsciboxes.sty`, the single owner of the semantic science boxes
previously duplicated in `otscience.cls` and `otbook.cls`.

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

Generated outputs are rebuilt, not committed. The Phase 0 preserved PDFs and logs were
removed on 12 November 2026; they remain recoverable from the local tag
`archive/phase0-preserved-outputs` (for example
`git show "archive/phase0-preserved-outputs:examples/studentnotes/Optics.pdf" > Optics.pdf`).

### `physicsquiz.cls`

Legacy fidelity baseline:

* `PHY104_Exam revision.tex`

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

The separate normal-modes project was also audited during Phase 0. Its historical log confirmed successful compilation and identified a small margin-note overflow. The `Optics` project is presently the representative example retained in the canonical repository.

### `otengineering.cls`

Representative project:

* `test.tex`

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
* ~~The optional-loading arrangement can hide missing ecosystem dependencies.~~
  Resolved by the architecture refactor (docs/architecture/PLAN.md Phase C, 2026-11-11): the
  `otscience` and `otbook` bundles now load unconditionally, with a `minimal`
  opt-out.
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

## Architecture refactor (docs/architecture/PLAN.md)

Branch `refactor/architecture-plan`. Phases A–C completed on 11 November 2026;
see `docs/architecture/ARCHITECTURE_AUDIT.md` for the audit, move register and evidence.
Decision 7 (colour tokens split from link policy: new `otcolors.sty`) and the
`\otmarks` fix were completed on 11 November 2026 after approval. Phase D
(`otlayout`, `otcore` facade, `otscience-theme` preset, class composition) was
completed on 12 November 2026. Phase E (notation: `otemphasis`,
`otmathboxes`, canonical `\ot...` names) and the `OTLight` unification
(`#F3F4F6` for every class) were completed on 12 November 2026. The Phase 5
baseline manifest must be re-recorded for the new `OTLight`. Phase F
(migration guide, package-author checklist, release-notes draft, manual
update) was completed on 12 November 2026. The Phase 5 baseline re-record,
architecture-refactor runner and manual author-reference guard were completed
under MiKTeX on 12 November 2026. Remaining before release: integrate the
refactor branch, obtain hosted `Starter documents` and `Release source checks`
evidence, then select a source commit for the proposed `v0.2.0` minor release.

## Decisions still required

* Whether the modular workbook should retain its existing conditional structure or adopt `subfiles`
* Naming and compatibility policy for public commands
* Accessibility target for future PDFs

## Next action

1. Run `tests\run_all_tests.ps1` under MiKTeX on `chore/repo-structure`.
2. Merge `refactor/architecture-plan` and `chore/repo-structure` through pull
   requests, then publish the refactor release notes.
3. Decide the open structural items: `skills/`, `output/tex/`, the OT
   Calculator material in `LaTeX-full_manual.md`, `PROJECT_ARCHITECTURE.md`, and
   the root AI-workflow files (`MASTER_PROMPT.md`, `PHASE_PROMPTS.md`,
   `FILE_CHECKLIST.md`, `ROADMAP.md`).
