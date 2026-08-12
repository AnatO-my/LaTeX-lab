# Changelog

This file records significant changes to the LaTeX Workspace Learning and Class Refactoring Project.

## Phase 5 — Shared OT design system

**Completed: 12 August 2026.**

### Decided

* Target architecture: three new packages — `ottheme.sty` for the OT colour
  palette and hyperlink policy, `otboxes.sty` for `otscibox` and
  `otsciboxnosplit`, and `otcore.sty` for shared package loading and page
  furniture across `otscience.cls` and `otengineering.cls`.
* `MASTER_PROMPT.md`'s suggested fourth package, `otmath`, is rejected. The name
  is already held by a live, documented companion package with different content,
  and the audit found essentially no identical maths code among active packages —
  only conceptual redundancy, which consolidation rather than extraction fixes.
* Migration order: 5A harness, 5B `ottheme`, 5C `otboxes`, 5D cleanup closure,
  5E `otcore` (optional), 5F governance.
* Minimum supported LaTeX kernel: 2022-06-01. Supported engine: pdfLaTeX, with
  LuaLaTeX and XeLaTeX expected to work but untested.

### Added (Checkpoint 5A)

* `tests/run_ot_phase5_tests.ps1` — the first regression runner for the
  `otscience`, `otengineering` and `studentnotes` side of the ecosystem. It
  chains the accepted Phase 4I/4J suite as an untouched-side guard, builds
  eighteen OT documents, and verifies them against a recorded baseline.
* `tests/check_ot_baseline.py` — records and verifies page counts, per-class log
  diagnostics, and a SHA-256 of the extracted page text for every document.
* `tests/ot_baseline_manifest.json` — the recorded baseline: 18 documents,
  140 pages, all 18 verified by rendered text.
* `tests/ot_palette_probe_science.tex` and
  `tests/ot_palette_probe_engineering.tex` — colour-value probes. Page counts and
  text hashes cannot see a colour value, so these print what `xcolor` actually
  resolves each `OT...` name to, into both the log and the page text.
* `tests/otpractice_standalone.tex` — the cycle witness. It fails today because
  `otpractice.sty` borrows `otscibox` and the OT palette from `otscience.cls`.
  Checkpoint 5C moves it from the expected-failure list into the positive list.
* `PHASE5_CHECKPOINT_5A.md`.

### Verified (Checkpoint 5A)

* The recorded baseline reproduces itself exactly on an unchanged rebuild.
* Both palette probes report their full colour count, 10 and 8.
* `otpractice_standalone` fails with `Environment otscibox undefined`.
* The accepted Phase 4I/4J → 4G → 4F → 4E → 4D → 4C → 3D chain still passes.

### Recorded rather than suppressed

* Two pre-existing diagnostics are baselined instead of asserted away: one
  underfull box in `examples/otengineering/test.tex`, already a known issue, and
  one `hyperref` warning in `examples/studentnotes/Optics.tex`, not previously
  recorded anywhere. A blanket zero-diagnostic assertion of the kind the
  `physicsquiz` runners use would have failed on day one for accepted
  conditions, so the OT assertion is "no change from the recorded baseline".
* `examples/vector-workbook/00_main_combined_workbook.tex` loads `silence`, so
  its empty diagnostic record understates what the build actually reports.

### Fixed during Checkpoint 5A

* The runner announced no mode, so an invocation that did not carry `-Record`
  silently verified and failed several stages later with a message about a
  missing manifest rather than a wrong invocation. It now prints its resolved
  mode before doing anything.
* The baseline parser could not read a real MiKTeX log. TeX hard-wraps log lines
  at `max_print_line` with no continuation marker, and a repository path is long
  enough that the `Output written on` summary line always wraps — sometimes
  inside the filename, a number, or a keyword. The parser now strips wrapping
  before matching.
* The runner now pre-checks all seven chained runners for a mark-of-the-web,
  which OneDrive applies on re-hydration and which makes PowerShell refuse to
  load them under a `RemoteSigned` policy.

### Unchanged (Checkpoint 5A)

* No file under `src/` was modified.
* `docs/PUBLIC_INTERFACES.md` is unchanged, because Checkpoint 5A introduces no
  public interface. The ownership records change at Checkpoints 5B and 5C, when
  the palette and the base boxes move from a class to a package.

### Added (Checkpoint 5B)

* Added `src/packages/ottheme.sty`, the shared OT palette and hyperlink policy
  package.
* Added `tests/ot_theme_package_smoke.tex`, a compile-only smoke document that
  loads `otnotation`, `otmath`, and `otfigures` directly and exercises their
  theme-dependent output.

### Changed (Checkpoint 5B)

* `otscience.cls` now loads `ottheme` instead of defining the OT colour palette
  and hyperlink setup inline.
* `otengineering.cls` now loads `ottheme` and deliberately re-declares only
  `OTLight` as `#F3F4F6`, preserving the documented engineering background
  divergence.
* `otnotation.sty`, `otmath.sty`, and `otfigures.sty` now load `ottheme`
  directly, so their palette references no longer rely on `otscience.cls`.
* `otmath.sty` now loads the `tcolorbox` libraries required by its boxed
  environments, so `identitybox` and `proofbox` work in standalone package
  documents.
* `tests/run_ot_phase5_tests.ps1` now builds the 5B standalone package smoke and
  asserts its three markers.
* Added `tests/powershell_log_helpers.ps1` and routed the Phase 3D/4C/4D/4E/4F/
  4G/4I-J and Phase 5 runner log scans through it, so transient Windows file
  locks on freshly written `.log` files are retried before failing the suite.
* `tests/check_ot_baseline.py` now tolerates only the known volatile rendered
  date strings when comparing text hashes, after a cross-day rebuild proved the
  original 5A baseline was too sensitive to `\today` and `\DTMtoday`.

### Preserved (Checkpoint 5B)

* The accepted OT colour values remain unchanged.
* `otpractice_standalone` remains an expected failure. Checkpoint 5B frees the
  theme-using packages; Checkpoint 5C is still responsible for moving
  `otscibox` into `otboxes.sty`.

### Verification (Checkpoint 5B)

* Python and PowerShell syntax checks passed locally in this Codex shell,
  including a smoke test of the log-read retry helper.
* The full Phase 5 checkpoint command passed in the normal MiKTeX environment:
  `PASS expected failure: otpractice_standalone` followed by
  `All OT Phase 5 tests passed.`

### Added (Checkpoint 5C)

* Added `src/packages/otboxes.sty`, the shared owner of `otscibox` and
  `otsciboxnosplit`.
* Added `tests/ot_boxes_package_smoke.tex`, a compile-only smoke document that
  loads `otboxes` directly and exercises both base science boxes.
* Added `PHASE5_CHECKPOINT_5C.md`.

### Changed (Checkpoint 5C)

* `otscience.cls` now loads `otboxes` and keeps only the semantic science-box
  wrappers locally.
* `otpractice.sty` now loads `otboxes` directly, so `practice`, `drillbox`,
  `recallbox`, and `examquestion` no longer depend on `otscience.cls`.
* `tests/otpractice_standalone.tex` is now a positive smoke fixture with the
  marker `OT5C-SMOKE:OTPRACTICE`.
* `tests/run_ot_phase5_tests.ps1` now builds the 5C `otboxes` and `otpractice`
  standalone smokes instead of expecting `otpractice_standalone` to fail.

### Preserved (Checkpoint 5C)

* The accepted `otscibox` and `otsciboxnosplit` visual settings are unchanged.
* `otscience.cls` still provides the established semantic science-box wrappers.

### Verification (Checkpoint 5C)

* Direct MiKTeX smoke builds passed for `tests/ot_boxes_package_smoke.tex` and
  `tests/otpractice_standalone.tex`, emitting `OT5C-SMOKE:OTBOXES` and
  `OT5C-SMOKE:OTPRACTICE`.
* The full Phase 5 checkpoint command passed in the normal MiKTeX environment:
  `All OT Phase 5 tests passed.`

### Closed (Checkpoint 5D)

* Closed the reserved theme and box cleanup checkpoint as a no-op source stage:
  the planned `otengineering.cls` adoption of `ottheme` was already completed in
  Checkpoint 5B, and the remaining `otpractice` box cycle was completed in
  Checkpoint 5C.
* Added `PHASE5_CHECKPOINT_5D.md`.
* Updated stale project and runner wording so `OTLight` preservation is described
  as current tested behavior, not deferred work.

### Added (Checkpoint 5E)

* Added `src/packages/otcore.sty`, the shared OT class-support package for common
  setup packages, list defaults, page furniture, and section styling helpers.
* Added `tests/ot_core_package_smoke.tex`, a compile-only smoke document that
  loads `ottheme` and `otcore` and exercises the three core helper commands.
* Added `PHASE5_CHECKPOINT_5E.md`.

### Changed (Checkpoint 5E)

* `otscience.cls` now loads `otcore` and calls the shared helpers with its
  established science page and section values.
* `otengineering.cls` now loads `otcore` and calls the shared helpers with its
  established engineering page and section values.
* `tests/run_ot_phase5_tests.ps1` now builds the 5E standalone core-package
  smoke and checks `OT5E-SMOKE:OTCORE`.

### Preserved (Checkpoint 5E)

* `otscience.cls` and `otengineering.cls` keep separate headers, header-rule
  widths, section spacing, and subsubsection colours.
* `otcore.sty` does not load `ottheme`; callers still control when the shared OT
  colour names become available.

### Verification (Checkpoint 5E)

* PowerShell syntax checks passed for the Phase 5 runner.
* Direct MiKTeX builds passed for `tests/ot_core_package_smoke.tex`,
  `tests/otscience_boxes_compatibility.tex`, and
  `tests/otengineering_boxes_compatibility.tex`.
* The full Phase 5 checkpoint command passed in the normal MiKTeX environment:
  `All OT Phase 5 tests passed.`

### Closed (Checkpoint 5F)

* Added `PHASE5_CHECKPOINT_5F.md` as the Phase 5 governance closure record.
* Wrote the agreed LaTeX kernel floor, `2022-06-01`, into the three new shared
  packages: `ottheme.sty`, `otboxes.sty`, and `otcore.sty`.
* Confirmed that Phase 5's package version policy is semantic package version
  `v0.2` for the new OT shared packages, with pdfLaTeX as the supported engine.
* Resolved the `physicsquiz.cls` semantic-version item as a Phase 6 or
  `physicsquiz`-specific governance decision, not a Phase 5 source change.
* Resolved the generated-output policy: generated PDFs, logs, and auxiliary
  files remain build artifacts; the Phase 5 evidence is the source fixtures,
  baseline manifest, checker output, and package smokes.
* Verified the 5F source change with direct MiKTeX package smokes for
  `ottheme`, `otboxes`, and `otcore`; the full Phase 5 runner was attempted from
  this tool path but exceeded the command timeout before returning output.
* Marked Phase 5 complete.

## Phase 4 — Question-bank architecture

**Completed: 8 August 2026**

**Amended: 9 August 2026 — Checkpoints 4H, 4I, and 4J**

### Decided

- Chose an `xsim`-backed storage engine behind a `physicsquiz`-owned author
  syntax, rather than a lightweight fully custom record implementation. This
  closes the open decision "whether assessment questions should use a
  lightweight custom architecture or `xsim`".
- Fixed the question-record interface and metadata validation policy at
  Checkpoint 4C, closing the open decision "the exact Phase 4 question-record
  interface and metadata validation policy".
- Adopted `xsim` and `siunitx` as verified prerequisites of the structured
  interface. The Phase 4 runners fail early when `kpsewhich` cannot find them.

### Added

- Added the `quizbank` environment for declaring a structured bank without
  rendering it.
- Added the `quizquestion` environment, taking `id`, `topic`, `difficulty`,
  `marks`, `correct`, and `tags` as required keys and `outcome` as optional.
- Added the `quizsolution` environment, which must immediately follow its
  question.
- Added `quizquestionbank` as a declare-select-print compatibility wrapper for
  documents written against the Checkpoint 4C interface.
- Added deterministic selection commands `\quizselectids`, `\quizselect`,
  `\quizselectall`, and `\quizclearselection`.
- Added seeded reproducible random selection through
  `\quizselectrandom[<filters>]{<count>}{<seed>}`.
- Added the generated output commands `\printquizquestions`,
  `\printquizanswerkey`, `\printquiztopicreport`, `\printquizsolutions`, and
  `\printquizteacherreport`.
- Added the regression assertions `\quizbankassert{<count>}{<marks>}` and
  `\quizselectionassert{<count>}{<marks>}{<ordered IDs>}`.
- Added metadata validation with descriptive class errors for missing required
  keys, malformed stable IDs, duplicate stable IDs, invalid marks values,
  invalid correct-option labels, orphan solutions, duplicate solutions, and
  non-adjacent solutions.
- Added selection validation with descriptive class errors for unknown IDs,
  empty ID lists, empty selections, empty metadata filters, invalid difficulty
  or marks filters, and filters matching no records.
- Added random-selection validation for non-positive and non-integer counts,
  out-of-range seeds, insufficient candidate pools, exhausted pools, and
  filters matching no eligible records.
- Added a class-owned Park-Miller pseudo-random generator using Schrage's
  overflow-safe update, rejection sampling, and a Fisher-Yates permutation,
  published under the compatibility marker `park-miller-v1`.
- Added `examples/physicsquiz/banks/phy104_migration_pilot_bank.tex`, a
  twelve-record audit pilot covering every topic-by-difficulty combination.
- Added `examples/physicsquiz/PHY104_migration_pilot.tex`.
- Added `examples/physicsquiz/banks/phy104_full_question_bank.tex`, the complete
  sixty-record structured migration of the representative quiz.
- Added `examples/physicsquiz/PHY104_structured_revision.tex`, the complete
  structured example document.
- Added the Phase 4C, 4D, 4E, 4F, and 4G test drivers, the Python checkers
  `check_physicsquiz_xsim_facade.py`, `check_physicsquiz_selection.py`,
  `check_physicsquiz_random_selection.py`,
  `check_physicsquiz_migration_pilot.py`, and
  `check_physicsquiz_full_migration.py`, and their PowerShell runners.

### Changed

- Separated declaration, selection, and rendering into three distinct stages.
  Questions are now single authoritative records; answers, solutions, topic
  reports, and mark totals are derived from them rather than maintained
  separately.
- Made `quizquestions` support a single column as well as its established
  two-column default.
- Reimplemented `quizquestionbank` as a wrapper that declares, selects, and
  prints the records it encloses, so Checkpoint 4C documents need no rewrite.
- Introduced `expl3` programming into `physicsquiz.cls` — key definitions,
  sequences, property lists, floating-point totals, and regular-expression
  validation — ahead of the planned Phase 6 introduction of modern interface
  programming.
- Corrected the Phase 4C runner to use literal `Select-String` matching, so the
  `Overfull \hbox` regular-expression failure does not recur.

### Preserved

- Preserved `full,colour` as the no-option default.
- Preserved `quizquestions`, `choiceoptions`, the legacy five-argument
  `\choices`, the manual `answerkey` environment, the five Phase 3 semantic
  gates, version metadata, and the display-only marks and difficulty hooks.
- Preserved the representative 60-question `PHY104_Exam revision.tex` unchanged,
  as the fidelity baseline against which the migration is checked.
- Preserved the accepted 23-page default rendering of that legacy quiz,
  pixel-identical through Checkpoints 4C, 4D, and 4E.
- Preserved and excluded the independent modification to
  `examples/studentnotes/Optics.tex`.

### Verified

- Verified that the Phase 4B proof of concept stored four real questions,
  derived the answer sequence C, B, B, E, and totalled 8 marks without changing
  the production class.
- Verified the Phase 4C production interface across five output modes, one-column
  and optional-outcome fixtures, and ten deliberate validation failures.
- Verified deterministic selection across reordered IDs in all five output modes,
  topic, difficulty, marks and match-all tag filters, append, de-duplication,
  clearing, select-all, and seven deliberate selection failures.
- Verified that the same bank, filter, count, and seed reproduce the same ordered
  stable IDs, that a comparison seed produces a different valid selection, and
  that seven deliberate random-selection failures behave as intended.
- Verified the twelve-record migration pilot against the legacy source for stems,
  choices, choice order, correct options, and worked reasoning.
- Verified the complete sixty-record migration: all 60 stems, all 300 choices,
  all 60 correct answers, all 60 worked solutions, record order, stable IDs,
  topic, difficulty and mark metadata, tags, and learning outcomes, against the
  legacy source.
- Verified complete declaration-order selection, three 20-question difficulty
  bands, deliberately reordered ID selection, combined topic-and-difficulty
  filtering, tag filtering across bands, and reproducible 12-question random
  selection under seed 104.
- Verified the 60-record, 120-mark bank totals through `\quizbankassert` and
  `\quizselectionassert`.
- Verified clean compilation of the complete structured example at 25 pages.
- Verified that positive logs contain no LaTeX warnings, `xsim` warnings,
  overfull boxes, or underfull boxes.
- Verified that the Phase 4G runner reruns the accepted 4F, 4E, 4D, 4C, and 3D
  suites, and that the complete chain passed in the repository-local MiKTeX
  environment on 6 August 2026.

### Fixed (Checkpoint 4H)

- Restored the established constants box in the generated question booklet.
  `\printquizquestions` now renders `\constantsbox` immediately after its
  section heading when `\quizconstants` has been set, reproducing the placement
  used by the manually authored quiz. Documents that call `\constantsbox`
  themselves are unaffected, because only the Phase 4 generated booklet reaches
  this code.
- Verified that the complete structured example remains 25 pages with the
  constants box present and produces no LaTeX, `xsim`, overfull, or underfull
  diagnostics, and that the `all`, `foundation`, `ids`, and `random`
  full-migration drivers are byte-identical because they do not set
  `\quizconstants`.

### Added (Checkpoints 4I and 4J)

- Added `\quizshuffleoptions{<seed>}`, which permutes the five slots of the
  `\choices` interface for every selected record. A record's permutation derives
  from the seed and its declaration index, so it is independent of selection
  order, and it is computed before rendering so that an answer-key-only compile
  agrees with the paper it belongs to.
- Added `\quizcorrectletter`, expanding to the effective answer letter for the
  record being rendered.
- Added `\quizdefineversion{<label>}{<recipe>}` and `\quizuseversion{<label>}`.
  A version names a selection recipe and its own shuffle seed; activating one
  clears the selection, runs the recipe, and sets the Phase 3 `\quizversion`
  header metadata, so a version label now denotes a genuinely different paper.
- Added the `\quizshuffleassert` and `\quizversionassert` regression hooks.
- Added `examples/physicsquiz/PHY104_versioned_paper.tex`.
- Added ten positive drivers, eight expected-failure drivers,
  `tests/check_physicsquiz_shuffle_versions.py`, and
  `tests/run_physicsquiz_phase4ij_tests.ps1`.

### Changed (Checkpoints 4I and 4J)

- Rewrote all sixty worked solutions in the PHY104 bank to end with
  `\quizcorrectletter` rather than a hard-coded answer letter. Every literal was
  verified against its record's `correct=` key before the rewrite, and the
  unshuffled build is byte-identical afterwards.
- Made the generated answer key and the solution heading read the effective
  letter rather than the declared one.
- Made `\quizclearselection` also discard any existing shuffle.
- Made `choiceoptions` raise a class error when a shuffled record would be
  rendered through it, because the class cannot know the option count.
- Taught `check_physicsquiz_full_migration.py` to resolve `\quizcorrectletter`
  back to the record's declared letter before comparing worked solutions with
  the legacy source. The Phase 4G fidelity contract is about reasoning text,
  and the resolution also makes the check fail if a record ever used the macro
  while declaring a different answer from the legacy quiz.

### Known limitations

- A generated 60-entry answer key is taller than one page. The complete example
  therefore prints three 20-question band keys. `\printquizanswerkey` does not
  yet paginate a long key by itself.
- `quizquestionbank` clears the current selection before printing the records it
  encloses. Mixing it with explicit selection commands in one document discards
  the earlier selection.
- A semantic gate that changes the selection leaves that change in place for
  later gates. The complete example re-selects deliberately for this reason.
- The structured bank and the legacy quiz now describe the same 60 questions.
  This duplication persists until the legacy source is retired.
- Changing the `park-miller-v1` algorithm would be a documented compatibility
  break, because existing seeds would stop reproducing their selections.

### Deferred

- Balancing a random paper to a target mark total.
- Retiring or replacing the legacy `PHY104_Exam revision.tex`.
- A pagination strategy for long generated answer keys.
- Any use of `xsim`'s own selection, collection, or grading facilities beyond
  storage.

## Phase 3 — One source, multiple assessment outputs

**Completed: 6 August 2026**

### Added

- Added mutually exclusive `full`, `student`, `teacher`, `solutions`, and
  `answerkey` primary output modes to `physicsquiz.cls`.
- Added five semantic section gates: `quizquestioncontent`,
  `quizanswerkeycontent`, `quizsolutioncontent`, `quizteachercontent`, and
  `quizreferencecontent`.
- Added independent `colour` and `print` presentation modes, with `color` as an
  alias for `colour`.
- Added `\quizversion{<label>}` for visible version metadata.
- Added the display-only `\quizmarks{<value>}` and
  `\quizdifficulty{<label>}` question hooks.
- Added a shared synthetic assessment fixture and separate drivers for every
  primary output mode.
- Added colour/print matrix tests, Version A/B tests, option-state assertions,
  and deliberate conflict tests.
- Added `tests/check_physicsquiz_output_modes.py` for exact semantic-marker
  verification.
- Added `tests/run_physicsquiz_phase3d_tests.ps1` as the repository-local
  Phase 3 verification runner.

### Changed

- Preserved `full,colour` as the no-option default.
- Continued forwarding non-`physicsquiz` options such as `12pt` and `a4paper`
  to `article`.
- Mapped the public quiz palette to high-contrast greys in `print` mode and
  hid hyperlink decoration.
- Extended the title page and running header to show version metadata only
  when supplied.
- Defined marks as visible in `full`, `student`, and `teacher` outputs.
- Defined difficulty as visible in `full` and `teacher` outputs.
- Documented the new Phase 3 public interfaces and their compatibility
  boundaries.

### Preserved

- Preserved the existing metadata commands, `quizquestions`, `choiceoptions`,
  legacy five-argument `\choices`, `answerkey`, and public colour names.
- Preserved the established default visual output.
- Left the representative 60-question quiz source unchanged and requiring no
  immediate migration.
- Kept answer-key contents manually authored; automatic answer collection was
  not introduced.
- Preserved and excluded the independent modification to
  `examples/studentnotes/Optics.tex`.

### Verified

- Verified all 21 positive Phase 3D drivers in the repository-local MiKTeX
  environment.
- Verified all ten semantic colour/print combinations against the exact content
  matrix.
- Verified that both conflicting-primary-mode and conflicting-presentation-mode
  tests fail with their intended class errors.
- Verified default and explicit colour state, the `color` alias, and explicit
  print state.
- Verified Version A and Version B output.
- Verified marks and difficulty visibility in every primary mode.
- Verified pass-through article options.
- Verified positive logs without LaTeX warnings, overfull boxes, or underfull
  boxes.
- Verified the unchanged Phase 2 choices compatibility output.
- Verified the representative quiz's accepted 23-page default rendering, with
  Question 60 and all five choices together.

### Deferred

- Structured question records and question-bank storage.
- Automatic answer-key generation and mark-total calculation.
- Question selection, filtering, reordering, randomisation, and choice shuffling.
- Version-dependent question assignment.
- Comparison of a lightweight custom architecture with `xsim`.
- Migration of the representative 60-question quiz.

## Phase 2 — Semantic and flexible document interfaces

**Completed: 5 August 2026**

### Added

- Added the semantic `choiceoptions` environment to `physicsquiz.cls`.
- Added support for an arbitrary number of alphabetically labelled options.
- Added `tests/physicsquiz_choices_compatibility.tex`.
- Added repository-level class discovery to `.latexmkrc`.
- Added `\formularef` for references matching visible named-formula tags.
- Added `tests/studentnotes_namedformula_compatibility.tex`.
- Added `docs/PUBLIC_INTERFACES.md`, documenting the supported interfaces of all four active classes.
- Added `tests/otengineering_helpers_smoke.tex`.
- Added `tests/studentnotes_helpers_smoke.tex`.

### Changed

- Reimplemented the five-argument `\choices` command as a backward-compatible wrapper around `choiceoptions`.
- Replaced the unbreakable options table with a semantic list-based interface.
- Retained the required `namedformula` title as reference metadata.
- Enabled descriptive formula-title references through `\nameref`.
- Preserved the existing hidden-title appearance and environment syntax.
- Documented stable author interfaces, advanced ecosystem hooks, implementation boundaries, defaults, compatibility guarantees, and namespace risks.
- Added explicit `\autoref` names for definitions and examples where required.
- Reduced the fixed `Remember:` margin-note label slightly so that it fits within the established margin width.
- Replaced the ineffective `silence`-based `physics`–`siunitx` warning filter with the native message redirection.
- Corrected the shared workbook setup and all seven modules without changing their intended mathematical content or visual identity.

### Fixed

- Fixed the Question 60 layout defect in the representative physics quiz.
- Prevented the complete option block from overlapping content in the following column.
- Fixed the `\remembernote` label overflow detected by the StudentNotes helper test.
- Fixed the workbook header-height warning.
- Fixed the recorded overfull lines in the combined workbook.
- Fixed malformed PDF-bookmark warnings caused by mathematical formatting in headings.
- Replaced deprecated `siunitx` settings.
- Removed redundant warning-suppression configuration.

### Verified

- Verified all 60 existing legacy `\choices` calls without source migration.
- Verified four-option, five-option, and six-option questions.
- Verified mathematical and prose options.
- Verified the representative quiz using the controlled `build/` output.
- Confirmed that the answer-key table remains correct.
- Confirmed that `examples/studentnotes/Optics.tex` remains separate from Phase 2.
- Verified `F<section>.<formula>` numbering.
- Verified formula-counter resets between sections.
- Verified `\formularef` output.
- Verified descriptive-title references through `\nameref`.
- Verified that formula titles remain visually hidden.
- Verified that the final build contains no unresolved references.
- Verified independent numbering and section-based resets for `theorem`, `definition`, and `example`.
- Verified headed and unheaded theorem rendering.
- Verified `\label`, `\ref`, `\nameref`, and `\autoref` behaviour.
- Verified the established appearance of `quicknote`, `personalnote`, and `importantnote`.
- Verified intact note-box rendering at page boundaries.
- Confirmed that the existing theorem and note-box definitions require no changes.
- Verified the documented public-interface declarations against the canonical class sources.
- Verified OTEngineering metadata, dashboard, sketch, status, rating, field, and theme helpers.
- Verified StudentNotes metadata, dotted background, margin-note, `WithArrows`, vector, and theme helpers.
- Confirmed that both helper smoke-test logs contain no matching warnings or errors.
- Visually confirmed both helper-test PDFs.
- Verified the corrected combined vector workbook with a clean build.

### Deferred

- Changes to the `answerkey` environment.
- Multiple assessment-output modes and question-bank metadata.

## Phase 1 — LaTeX Workshop workflow

**Completed: 4 August 2026**

### Added

- Added a repository-level `.latexmkrc`.
- Added project-local LaTeX Workshop settings in `.vscode/settings.json`.
- Added project-local discovery paths for classes under `src/classes`.
- Added project-local discovery paths for packages under `src/packages`.
- Added a controlled and mirrored `build/` output structure.
- Added `tests/otscience_boxes_compatibility.tex`.
- Added `tests/otengineering_boxes_compatibility.tex`.

### Configured

- Configured `latexmk` to build directly with pdfLaTeX.
- Configured SyncTeX generation and file-and-line diagnostics.
- Configured nested root documents to build from their own directories.
- Configured automatic compilation when a LaTeX source is saved.
- Configured ChkTeX linting on save.
- Configured `latexindent` as the explicit LaTeX formatter.
- Disabled automatic formatting on save for LaTeX documents.
- Disabled automatic mathematical-delimiter and quotation rewriting.
- Retained LaTeX Workshop’s internal PDF viewer.

### Verified

- Verified command-line builds from PowerShell.
- Verified LaTeX Workshop builds using the shared `.latexmkrc`.
- Verified controlled output directories for nested example projects.
- Verified combined and standalone compilation of the modular vector workbook.
- Verified standalone builds for all four active class architectures.
- Verified forward and inverse SyncTeX navigation.
- Verified clean rebuilding through LaTeX Workshop.
- Verified automatic compilation on save.
- Verified ChkTeX 1.7.9 integration.
- Verified `latexindent` 4.0 integration.
- Confirmed that `% !TeX root` directives are unnecessary for the existing dual-root workbook architecture.
- Verified all breakable and non-splitting `otscience` semantic-box interfaces.
- Verified default and custom semantic-box titles.
- Verified established box colours and visual appearance.
- Verified clean splitting of breakable boxes across pages.
- Verified intact page-boundary movement of `nosplit` boxes.
- Verified compatibility with the fallback definitions in `00_common_setup.tex`.
- Verified the `practicebox` and `practiceboxnosplit` workbook wrappers.
- Verified successful standalone and combined vector-workbook builds.
- Confirmed that the existing `otscience` box definitions require no changes.
- Verified the generic `otbox` interface and all fifteen semantic wrappers.
- Verified default and custom semantic-box titles.
- Verified established colours and visual appearance.
- Verified the `calculation` environment and `\calcfield` command.
- Verified intact page-boundary movement of short boxes.
- Verified clean continuation of long breakable boxes across pages.
- Verified the representative `otengineering` notebook build.
- Confirmed that the existing box definitions require no changes.

### Preserved

- No class, package, or example-document source was changed as part of Phase 1.
- Existing visual output and document interfaces were preserved.
- The separate modification to `examples/studentnotes/Optics.tex` was excluded from Phase 1.

## Phase 0 — Baseline audit and safety

### Established

- Established the canonical repository structure.
- Inventoried the four active classes and seven OT companion packages.
- Preserved representative sources, PDFs, and diagnostic logs.
- Audited public interfaces, dependencies, known warnings, and layout defects.
- Created the initial Git baseline.
- Tagged the baseline as `phase-0-baseline`.
