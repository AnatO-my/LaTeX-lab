# Changelog

## Phase 10 - Testing and releases

**In progress. Checkpoint 10A opened: 15 August 2026.**

### Added (Checkpoint 10A)

* Added `docs/VERSIONING_RELEASE_POLICY.md`, defining the first repository
  release-label policy, public-interface update rule, and release-asset
  boundary.
* Added `tests/run_phase10a_release_policy.ps1`, a source-level guard that
  inventories class/package `\Provides...` declarations and verifies the Phase
  10A policy records.
* Added `PHASE10_CHECKPOINT_10A.md`.

### Decided (Checkpoint 10A)

* Phase 10 begins with policy and inventory rather than a version bump.
* Repository releases should use labels such as `v0.1.0`, with patch/minor/major
  meanings defined in the policy guide.
* Generated PDFs, author kits, and preview zips remain release assets rather
  than ordinary source files.
* Class/package versions and `l3build` adoption remain later Phase 10 decisions.

### Verification (Checkpoint 10A)

* The Phase 10A release policy guard passed with 1 informational note.
* Inventoried 15 real `\ProvidesClass`/`\ProvidesPackage` declarations; 4
  include semantic version text.
* Reran the Phase 9C reliability guard; it parsed 24 of 24 PowerShell runners
  and reported 0 findings and 0 failures.

### Added (Checkpoint 10B)

* Added `docs/RELEASE_NOTES_TEMPLATE.md`, the first reusable release-notes
  template for GitHub releases or local release records.
* Added `tests/run_phase10b_release_notes_template.ps1`, a source-level guard
  for the required release-note sections and policy links.
* Added `PHASE10_CHECKPOINT_10B.md`.

### Decided (Checkpoint 10B)

* Release notes must name the release label, source commit, release type,
  verification checks, public-interface changes, assets, upgrade notes, and
  known limitations.
* Release notes are not a release by themselves; tags, release assets, and
  version bumps remain separate checkpoint decisions.

### Verification (Checkpoint 10B)

* The Phase 10B release-notes template guard passed with 1 informational note.
* Checked 10 required template sections and 14 required markers.
* Reran the Phase 9C reliability guard; it parsed 25 of 25 PowerShell runners
  and reported 0 findings and 0 failures.

### Added (Checkpoint 10C)

* Added `docs/LOCAL_RELEASE_CHECKLIST.md`, a source-first checklist for choosing
  a release source state before tags or assets.
* Added `tests/run_phase10c_local_release_checklist.ps1`, a source-level guard
  for release checklist markers and known local-only status.
* Added `PHASE10_CHECKPOINT_10C.md`.

### Decided (Checkpoint 10C)

* Release readiness should be checked locally before a tag, GitHub release, or
  asset upload is prepared.
* The starter build remains the required MiKTeX-side release check before a real
  release.
* Generated PDFs, author kits, and preview zips remain optional release assets,
  not ordinary source.

### Verification (Checkpoint 10C)

* The Phase 10C local release checklist guard passed with 0 warnings and 2
  informational notes after the 10C source changes were committed locally.
* Checked 11 required files and 10 required markers, with 0 failures.
* Confirmed that only known local-only files were visible in ordinary status.
* Reran the Phase 9C reliability guard; it parsed 26 of 26 PowerShell runners
  and reported 0 findings and 0 failures.

### Added (Checkpoint 10D)

* Added `docs/RELEASE_ASSET_MANIFEST_TEMPLATE.md`, a source-only template for
  recording optional release PDFs and author-kit zips.
* Added `tests/run_phase10d_release_asset_manifest.ps1`, a guard for the
  manifest template, related release checklist links, and planned asset ids.
* Added `PHASE10_CHECKPOINT_10D.md`.

### Decided (Checkpoint 10D)

* Release assets should have a simple source record naming their status, source,
  output name, and `sha256` hash.
* The release-asset manifest does not create a tag, version bump, generated PDF,
  zip, GitHub release, or new CI workflow.
* Assets remain optional; source-only releases can explicitly mark them omitted.

### Verification (Checkpoint 10D)

* The Phase 10D release-asset manifest guard passed with 0 warnings and 2
  informational notes.
* Checked 11 required files, 12 required markers, and 9 planned release asset
  ids, with 0 failures.
* Reran the Phase 10C local release checklist from the committed 10D source
  state; it passed with 0 warnings and 2 informational notes.
* Reran the Phase 9C reliability guard; it parsed 27 of 27 PowerShell runners
  and reported 0 findings and 0 failures.

This file records significant changes to the LaTeX Workspace Learning and Class Refactoring Project.

## Phase 8 — GitHub launch and collaborator onboarding

**Completed: 14 August 2026.**

### Added (Checkpoint 8A)

* Added `docs/GITHUB_LAUNCH_AUDIT.md`, recording the local state before the
  first private GitHub push.
* Added `PHASE8_CHECKPOINT_8A.md`.

### Decided (Checkpoint 8A)

* Phase 8 begins with a local launch audit before any remote is created or
  pushed.
* The first GitHub repository should still be private-first, source-only by
  default, and inspected manually before hosted CI is added.

### Added (Checkpoint 8B)

* Added `PHASE8_CHECKPOINT_8B.md`, recording the first GitHub push.

### Changed (Checkpoint 8B)

* Updated `docs/GITHUB_LAUNCH_AUDIT.md` and `PROJECT_STATE.md` to record
  `origin` as `https://github.com/AnatO-my/LaTeX-lab.git`.
* Recorded that `main` now tracks `origin/main`.
* Carried GitHub-side repository inspection forward as the next Phase 8 step.

### Added (Checkpoint 8C)

* Added `PHASE8_CHECKPOINT_8C.md`, recording the first GitHub-side repository
  inspection after push.

### Confirmed (Checkpoint 8C)

* The pushed repository files are present as expected.
* Generated output files are absent.
* The `build/` folder is absent.

### Added (Checkpoint 8D)

* Added `docs/COLLABORATOR_ONBOARDING_CHECKLIST.md`, defining the first
  collaborator access packet, first local check, first contribution shape, and
  branch/pull-request habit.
* Added `PHASE8_CHECKPOINT_8D.md`.

### Decided (Checkpoint 8D)

* First collaborators should start with the README, author workflow,
  contribution guide, starter inventory, onboarding checklist, and starter
  verification command.
* Admin access, branch protection, required checks, and release permissions
  remain separate Phase 8 decisions.

### Added (Checkpoint 8E)

* Added `docs/BRANCH_AND_PR_POLICY.md`, defining the first branch naming,
  pull-request, local-check, artifact, and review expectations.
* Added `PHASE8_CHECKPOINT_8E.md`.

### Decided (Checkpoint 8E)

* `main` remains the stable branch.
* Collaborator changes should use short feature branches and pull requests.
* GitHub branch protection and required checks remain deferred until a
  collaborator pull request has been tried and starter-build CI is stable.

### Added (Checkpoint 8F)

* Added `.github/workflows/starter-build.yml`, the first GitHub Actions
  workflow.
* Added `PHASE8_CHECKPOINT_8F.md`.

### Changed (Checkpoint 8F)

* Updated CI, branch policy, collaboration, onboarding, README, and project
  state records to treat starter-build CI as present but not yet required.

### Decided (Checkpoint 8F)

* The first hosted workflow runs only `git diff --check` and the Phase 7C
  starter runner.
* Starter PDFs may be uploaded as workflow artifacts but remain excluded from
  ordinary source commits.
* Full regression suites and branch-protection enforcement remain later
  checkpoints.

### Confirmed (Checkpoint 8F)

* The first pushed `Starter documents` GitHub Actions job passed in 4m 33s.
* Recorded GitHub's Node.js 20 deprecation warning for the current action
  versions as a future watch item.

### Added (Checkpoint 8G)

* Added `docs/RELEASE_PREVIEW_PDF_AUDIT.md`, recording the first local
  release-preview PDF set.
* Added `PHASE8_CHECKPOINT_8G.md`.

### Confirmed (Checkpoint 8G)

* Generated seven starter preview PDFs under `build/release-preview/2026-08-13/`.
* Recorded page counts, byte sizes, and SHA256 hashes for the preview PDFs.
* Confirmed the PDFs remain generated artifacts and are not committed as source.

### Added (Checkpoint 8H)

* Added `docs/AUTHOR_KIT_AUDIT.md`, recording the first source-derived author
  kit.
* Added `PHASE8_CHECKPOINT_8H.md`.

### Changed (Checkpoint 8H)

* Added `.latexmkrc` to the author-kit manifest and release-readiness kit list
  so copied kits can build from their own root.
* Updated the author-kit checklist to remove kit-local `build/` outputs before
  zipping.

### Confirmed (Checkpoint 8H)

* Built and zipped `build/author-kit/latex-lab-author-kit-2026-08-13.zip`.
* Verified the copied kit from its own root with the Phase 7C starter runner.
* Confirmed the final kit folder and zip exclude generated outputs and
  local-only files.

### Fixed (Checkpoint 8F follow-up)

* Updated `.github/workflows/starter-build.yml` to discover the hosted MiKTeX
  binary directory instead of assuming `C:\Program Files\MiKTeX\miktex\bin\x64`.
* Recorded the hosted path-discovery failure as a CI stabilization item.
* Replaced the Chocolatey MiKTeX install path with MiKTeX's standalone setup
  utility after the hosted runner reported no usable MiKTeX-like directories.
* Updated the workflow install step to refresh its current `PATH` before
  invoking MiKTeX commands and to install `latexmk` explicitly.
* Added bounded retry and backoff to the MiKTeX setup download after a hosted
  run timed out while contacting `miktex.org`.

### Confirmed (Checkpoint 8F follow-up)

* Confirmed commit `f40f051` passed the hosted `Starter documents` job in 4m
  40s, with total workflow duration 4m 43s.
* Confirmed GitHub produced the `starter-pdfs` artifact at 780 KB.
* Left the Node.js 20 deprecation annotation as a non-blocking future action
  version watch item.
* Confirmed commit `e9374af` passed the hosted `Starter documents` job in 5m
  9s, with total workflow duration 5m 12s and the `starter-pdfs` artifact at
  780 KB.

### Added (Checkpoint 8I)

* Added `docs/BRANCH_PROTECTION_CHECKLIST.md`.
* Added `PHASE8_CHECKPOINT_8I.md`.

### Decided (Checkpoint 8I)

* The first protected-`main` rule should require pull requests, one approval,
  conversation resolution, up-to-date branches, and the `Starter documents`
  hosted status check.
* Force pushes and branch deletion should remain blocked.
* Signed commits, linear history, merge queue, deployment requirements, full
  regression workflows, and no-admin-bypass enforcement remain later decisions.

### Confirmed (Checkpoint 8I)

* Confirmed on GitHub that the `main` branch protection rule currently applies
  to one branch.

### Closed (Checkpoint 8J)

* Added `PHASE8_CHECKPOINT_8J.md`.
* Closed Phase 8 after the GitHub launch, repository inspection, collaborator
  onboarding records, branch and pull-request policy, starter-build CI,
  release-preview audit, author-kit audit, and protected-`main` rule were in
  place.
* Carried the first protected collaborator pull request, GitHub release assets,
  broader CI, stricter branch protection, and future document capabilities
  forward as post-Phase-8 work.

## Phase 9 — Automation and performance

**In progress. Checkpoint 9A opened: 14 August 2026.**

### Added (Checkpoint 9A)

* Added `tests/run_phase9a_measurement.ps1`, a measurement runner for starter
  and representative builds.
* Added `docs/BUILD_MEASUREMENT_BASELINE.md`.
* Added `PHASE9_CHECKPOINT_9A.md`.

### Decided (Checkpoint 9A)

* Phase 9 begins with measurement, not optimization.
* Generated timing reports belong under `build/phase9a-measurement/` and remain
  ignored build artifacts.
* Class, package, TikZ, dot-grid, and build-recipe changes remain deferred until
  a measurement shows a clear target.

### Verification (Checkpoint 9A)

* The Phase 9A runner passed PowerShell syntax checking.
* The first timing run could not complete in this Codex shell because `latexmk`
  was not visible on `PATH`; the command should be run in the normal MiKTeX
  PowerShell environment.
* Fixed the measurement runner to pass absolute output paths to `latexmk` after
  normal-environment feedback showed a representative build writing under an
  example-local nested `build/` folder.
* Fixed the timing wrapper so build output is displayed without entering the
  measurement result list.
* Reworked final report construction to use a plain timing-record array and
  explicit note properties for Windows PowerShell compatibility.
* Recorded the first successful Phase 9A timing baseline: 15.75 seconds total,
  with a stable generated-file inventory before and after the run.

### Added (Checkpoint 9B)

* Added `tests/run_phase9b_generated_hygiene.ps1`, a non-destructive
  generated-file hygiene reporter.
* Added `docs/GENERATED_FILE_HYGIENE.md`.
* Added `PHASE9_CHECKPOINT_9B.md`.

### Changed (Checkpoint 9B)

* Updated `.gitignore` to ignore `indent.log`, `__pycache__/`, and `*.py[cod]`
  after the hygiene report identified them as visible generated leftovers.

### Verification (Checkpoint 9B)

* The first hygiene run completed and reported 14 tracked generated-looking
  files, 3 visible generated-looking files, 1292 ignored generated files, and
  1104 files under `build/`.
* After the ignore update, the hygiene runner completed with 0 visible
  generated-looking files, 1297 ignored generated files, and 1106 files under
  `build/`.

### Added (Checkpoint 9C)

* Added `tests/run_phase9c_build_recipe_reliability.ps1`, a structural
  reliability guard for PowerShell runners, `.latexmkrc`, generated-output
  ignore patterns, Phase 9A/9B safeguards, the starter runner, and hosted
  starter workflow markers.
* Added `docs/BUILD_RECIPE_RELIABILITY.md`.
* Added `PHASE9_CHECKPOINT_9C.md`.

### Verification (Checkpoint 9C)

* The Phase 9C runner passed.
* Parsed 19 of 19 PowerShell runners.
* Inventoried 75 `latexmk` references.
* Reported 0 findings and 0 failures.

### Added (Checkpoint 9D)

* Added `tests/run_phase9d_starter_timing.ps1`, a per-starter timing runner
  that preserves the Phase 7C starter marker checks.
* Added `docs/STARTER_SUITE_TIMING.md`.
* Added `PHASE9_CHECKPOINT_9D.md`.

### Decided (Checkpoint 9D)

* Phase 9D measures the starter suite before optimization.
* TikZ and dot-grid adjustments remain deferred to Phase 9E, after the starter
  timing split is known.

### Verification (Checkpoint 9D)

* The Phase 9D runner passed PowerShell syntax checking.
* The normal MiKTeX PowerShell run passed in 13.64 seconds and wrote ignored
  reports under `build\phase9d-starter-timing\`.
* The Codex shell could not run TeX because `latexmk` was not visible on
  `PATH`.

### Added (Checkpoint 9E)

* Added `tests/run_phase9e_tikz_dotgrid_audit.ps1`, a source-level TikZ and
  dot-grid audit runner.
* Added `docs/TIKZ_DOTGRID_AUDIT.md`.
* Added `PHASE9_CHECKPOINT_9E.md`.

### Verification (Checkpoint 9E)

* The Phase 9E runner passed with 0 warnings and 0 failures.
* Recorded the current dot-grid estimate as 2,580 dots per page.
* Confirmed the representative Optics example keeps `\usedotgrid` commented by
  default and the helper smoke test exercises it once.
* Inventoried reusable `otfigures` macros and TikZ usage across source,
  examples, and tests.
* Reran the Phase 9C reliability guard; it parsed 21 of 21 PowerShell runners
  and reported 0 findings and 0 failures.

### Added (Checkpoint 9F)

* Added `\setdotgridbackgroundimage{<path>}` to `studentnotes.cls`.
* Added `tests/studentnotes_dotgrid_image_fallback.tex`.
* Added `tests/run_phase9f_dotgrid_modernization.ps1`.
* Added `docs/DOTGRID_MODERNIZATION.md`.
* Added `PHASE9_CHECKPOINT_9F.md`.

### Changed (Checkpoint 9F)

* Kept the original TikZ dot grid as the default fallback.
* Added an opt-in image/PDF background path for StudentNotes dot-grid pages.
* Made repeated `\usedotgrid` calls harmless.
* Updated the Phase 9E audit expectation so the image/PDF installer and TikZ
  fallback installer are both recognized.

### Verification (Checkpoint 9F)

* The Phase 9F source checks passed in this Codex shell.
* The Phase 9E TikZ/dot-grid audit still passed with 0 warnings and 0 failures.
* The Phase 9C reliability guard parsed 22 of 22 PowerShell runners and
  reported 0 findings and 0 failures.
* The normal MiKTeX PowerShell run passed the full Phase 9F dot-grid
  modernization check.
* The Codex shell cannot see `latexmk` on `PATH`, so it runs source checks only
  for this checkpoint.

### Closed (Checkpoint 9G)

* Added `tests/run_phase9g_phase_closeout.ps1`, a source-level closeout guard
  for the Phase 9 file set and recorded verification markers.
* Added `docs/PHASE9_CLOSEOUT.md`.
* Added `PHASE9_CHECKPOINT_9G.md`.
* Closed Phase 9 after measurement, generated-file hygiene, build-recipe
  reliability, starter timing, TikZ/dot-grid audit, and conservative dot-grid
  modernization were complete.
* Verified the Phase 9G closeout guard: 21 required files, 11 required markers,
  0 warnings, and 0 failures.
* Reran the Phase 9C reliability guard; it parsed 23 of 23 PowerShell runners
  and reported 0 findings and 0 failures.
* Carried version policy, release assets, broader CI, `l3build` evaluation,
  packaged dot-grid image/PDF measurement, and the first protected pull-request
  trial forward to Phase 10 or post-Phase-9 work.

## Phase 7 — Local author workflow and distribution readiness

**Completed: 13 August 2026.**

### Added (Checkpoint 7A)

* Added `README.md` as the first user-facing repository landing page.
* Added `docs/AUTHOR_WORKFLOW.md` with local setup, starter choices, build
  commands, Git hygiene, and GitHub collaboration guidance.
* Added `PHASE7_CHECKPOINT_7A.md`.

### Decided (Checkpoint 7A)

* Phase 7 will treat GitHub collaboration as part of distribution readiness.
* The recommended collaboration shape is branch-based work, pull-request review
  once collaborators are active, generated build artifacts excluded from normal
  commits, and setup instructions kept in source-controlled docs.

### Added (Checkpoint 7B)

* Added `docs/STARTER_INVENTORY.md`, separating true starters from
  representative examples and listing the missing starter set.
* Added `docs/GITHUB_COLLABORATION.md`, a private-first collaboration checklist
  for repository visibility, branches, pull requests, artifact policy, labels,
  and release questions.
* Added `PHASE7_CHECKPOINT_7B.md`.

### Changed (Checkpoint 7B)

* Corrected the author workflow guide to reference the existing
  `examples/physicsquiz/PHY104_structured_revision.tex` file.

### Added (Checkpoint 7C)

* Added small copyable starters for versioned quizzes, student notes,
  engineering notebooks, science notes, and vector-workbook modules.
* Added `tests/run_phase7c_starter_tests.ps1`, a fast starter-only build guard.
* Added `PHASE7_CHECKPOINT_7C.md`.

### Changed (Checkpoint 7C)

* Updated the starter inventory, README, and author workflow guide so the new
  true starters are distinct from larger representative examples.

### Added (Checkpoint 7D)

* Added `CONTRIBUTING.md`.
* Added a GitHub pull-request template.
* Added GitHub issue templates for bug reports, starter/example requests, and
  workflow questions.
* Added `PHASE7_CHECKPOINT_7D.md`.

### Changed (Checkpoint 7D)

* Updated the README, author workflow guide, and GitHub collaboration checklist
  to reference the new collaboration packaging files.

### Added (Checkpoint 7E)

* Added `docs/RELEASE_READINESS.md`, defining the first shareable repository
  boundary, optional release PDFs, and deferred CI.
* Added `docs/AUTHOR_KIT_MANIFEST.md`, listing the source files that belong in a
  future author kit.
* Added `PHASE7_CHECKPOINT_7E.md`.

### Changed (Checkpoint 7E)

* Updated the README, contribution guide, author workflow guide, and GitHub
  collaboration checklist to point at the release-readiness boundary.

### Added (Checkpoint 7F)

* Added `docs/GITHUB_PUSH_CHECKLIST.md`, a manual runbook for creating the
  private GitHub repository, adding the remote, pushing `main`, inspecting
  templates, and onboarding first collaborators.
* Added `PHASE7_CHECKPOINT_7F.md`.

### Changed (Checkpoint 7F)

* Linked the push checklist from the README, author workflow guide, GitHub
  collaboration checklist, and release-readiness guide.

### Added (Checkpoint 7G)

* Added `docs/AUTHOR_KIT_BUILD_CHECKLIST.md`, a manual checklist for producing a
  future source-derived author kit from `docs/AUTHOR_KIT_MANIFEST.md`.
* Added `PHASE7_CHECKPOINT_7G.md`.

### Changed (Checkpoint 7G)

* Linked the author-kit build checklist from the README, release-readiness
  guide, author-kit manifest, and GitHub collaboration checklist.

### Added (Checkpoint 7H)

* Added `docs/RELEASE_PDF_CHECKLIST.md`, a manual checklist for optional starter
  preview PDFs attached to GitHub releases.
* Added `PHASE7_CHECKPOINT_7H.md`.

### Changed (Checkpoint 7H)

* Linked the release PDF checklist from the README, release-readiness guide,
  author-kit build checklist, and GitHub collaboration checklist.

### Added (Checkpoint 7I)

* Added `docs/GITHUB_ACTIONS_CI_CHECKLIST.md`, a checklist for when and how to
  introduce hosted CI after the repository is pushed to GitHub.
* Added `PHASE7_CHECKPOINT_7I.md`.

### Changed (Checkpoint 7I)

* Linked the CI checklist from the README, release-readiness guide, GitHub
  push checklist, and GitHub collaboration checklist.

### Added (Checkpoint 7J)

* Added `examples/vector-workbook/starter_combined_workbook.tex`.
* Added `docs/COMBINED_WORKBOOK_STARTER_CHECKLIST.md`.
* Added `PHASE7_CHECKPOINT_7J.md`.

### Changed (Checkpoint 7J)

* Added the combined workbook starter to the starter runner.
* Updated the starter inventory, author workflow guide, author-kit manifest,
  release-readiness guide, release PDF checklist, README, and collaboration
  checklist to include the combined workbook starter.

### Closed (Checkpoint 7K)

* Added `PHASE7_CHECKPOINT_7K.md` as the Phase 7 closure record.
* Recorded Phase 7 as complete after the starter, collaboration, release,
  author-kit, push, CI-planning, and combined-workbook decisions were captured.
* Carried GitHub push, hosted CI, author-kit creation, and release PDFs forward
  as next-phase options rather than source changes inside Phase 7.

## Phase 6 — Modern LaTeX interface programming

**Completed: 13 August 2026.**

### Decided (Checkpoint 6A)

* Adopted the conservative modernization model: preserve existing author-facing
  structures unless a modern LaTeX change improves safety, maintainability,
  validation, or local usability.
* Added the Phase 6 user check-in rule: meaningful conservation decisions should
  be checked with the user unless reworking would require a broad breakage audit
  for little practical gain.
* Kept Checkpoint 6A production-neutral. It does not change `physicsquiz.cls`,
  any OT class, or any package.

### Added (Checkpoint 6A)

* Added `PHASE6_CHECKPOINT_6A.md`.
* Added `tests/phase6_modern_interface_examples.tex`, an isolated learning
  scaffold for `\NewDocumentCommand`, optional arguments, `expl3` keys, token
  lists, booleans, and named messages.
* Added `tests/run_phase6a_tests.ps1`, a small runner that builds the learning
  scaffold and checks its marker lines.

### Verification (Checkpoint 6A)

* PowerShell parser checks passed for `tests/run_phase6a_tests.ps1`.
* The Phase 6A runner passed in the normal MiKTeX environment:
  `All Phase 6A tests passed.`

### Added (Checkpoint 6B)

* Added public `physicsquiz.cls` version and capability markers:
  `\physicsquizclassversion`, `\physicsquizstructuredinterfaceversion`, and
  `\physicsquizstructuredinterfaceid`.
* Added semantic class version `v0.1` to the `physicsquiz.cls`
  `\ProvidesClass` line.
* Added `tests/physicsquiz_capability_marker_smoke.tex`, which prints the marker
  values and verifies that the structured bank interface remains available.
* Added `tests/run_phase6b_tests.ps1`, which reruns the 6A scaffold and checks
  the 6B capability smoke markers.
* Added `PHASE6_CHECKPOINT_6B.md`.

### Preserved (Checkpoint 6B)

* Preserved the traditional `physicsquiz.cls` class-option layer.
* Preserved `\quizversion`, `\quizdefineversion`, and `\quizuseversion` syntax.
* Preserved five-option-only shuffling through `\choices`.
* Preserved the current class error for shuffled `choiceoptions` records.
* Preserved existing question-bank metadata validation behaviour.

### Verification (Checkpoint 6B)

* PowerShell parser checks passed for `tests/run_phase6a_tests.ps1` and
  `tests/run_phase6b_tests.ps1`.
* The Phase 6B runner passed in the normal MiKTeX environment:
  `All Phase 6B tests passed.`
* The established Phase 4I/4J regression guard passed after the 6B production
  marker change:
  `PASS expected failure: physicsquiz_version_already_active` followed by
  `All Phase 4I/4J tests passed.`

### Added (Checkpoint 6C)

* Added `tests/check_physicsquiz_namespace.py`, a source-level guard for the
  current `physicsquiz.cls` modern-code boundary.
* Added `tests/run_phase6c_tests.ps1`, which reruns 6B and then checks the 6C
  namespace markers.
* Added `PHASE6_CHECKPOINT_6C.md`.
* Documented the `physicsquiz.cls` implementation namespace boundary in
  `docs/PUBLIC_INTERFACES.md`.

### Preserved (Checkpoint 6C)

* Preserved the existing author-facing `physicsquiz.cls` commands and
  environments.
* Preserved the `__pq` internal `expl3` namespace instead of renaming working
  internals during the audit.
* Preserved the legacy `\pqchoiceoptionsguard` bridge as an internal
  compatibility bridge for the older `choiceoptions` path.
* Left the pre-existing dirty marks-regex and formatting change outside the
  checkpoint.

### Verification (Checkpoint 6C)

* PowerShell parser checks passed for `tests/run_phase6c_tests.ps1`.
* The Phase 6C runner passed:
  `All Phase 6C tests passed.`

### Changed (Checkpoint 6D)

* Resolved the carried `physicsquiz.cls` marks-regex question by preserving
  existing leading-zero decimals such as `0.5` and also accepting leading-dot
  decimals such as `.5`.
* Applied the same marks syntax to structured question metadata and marks
  filters.

### Added (Checkpoint 6D)

* Added `tests/physicsquiz_marks_decimal_smoke.tex`.
* Added `tests/run_phase6d_tests.ps1`, which reruns 6C and checks the 6D marks
  decimal smoke.
* Added `PHASE6_CHECKPOINT_6D.md`.

### Verification (Checkpoint 6D)

* PowerShell parser checks passed for `tests/run_phase6d_tests.ps1`.
* The Phase 6D runner passed:
  `All Phase 6D tests passed.`

### Changed (Checkpoint 6E)

* Improved `physicsquiz.cls` author-facing validation help for common
  structured-bank mistakes: missing metadata, invalid IDs, duplicate IDs,
  invalid marks, invalid correct labels, invalid filters, no-match filters, and
  invalid random counts or seeds.
* Preserved the existing public quiz syntax while making the errors show
  copyable examples such as `id=waves-001`, `marks=0.5`, `marks=.5`,
  `\quizselectall`, and `\quizselect[topic=waves]`.

### Added (Checkpoint 6E)

* Added `examples/physicsquiz/starter_quiz_bank.tex`, a minimal copyable
  structured quiz-bank document.
* Added expected-failure author-message fixtures for invalid IDs, invalid marks,
  and empty filters.
* Added `tests/run_phase6e_tests.ps1`, which reruns 6D, builds the starter
  document, and checks the new author hints.
* Added `PHASE6_CHECKPOINT_6E.md`.

### Verification (Checkpoint 6E)

* PowerShell parser checks passed for `tests/run_phase6e_tests.ps1`.
* The Phase 6E runner passed:
  `All Phase 6E tests passed.`

### Added (Checkpoint 6F)

* Added `tests/run_phase6f_tests.ps1`, which builds generated Version A and
  Version B copies of the representative PHY104 versioned paper without editing
  the source example.
* Added `tests/check_physicsquiz_versioned_visual.py`, which verifies version
  activation, selected question sets, shuffled option differences, answer-key
  markers, and solution-heading answer markers.
* Added `PHASE6_CHECKPOINT_6F.md`.

### Changed (Checkpoint 6F)

* Added the internal log marker `PQ6F-SOLUTION-ANSWER:<id>=<letter>` while
  rendering worked solutions. It mirrors the answer already printed in the
  solution heading and does not change document output.

### Verification (Checkpoint 6F)

* PowerShell parser checks passed for `tests/run_phase6f_tests.ps1`.
* The Phase 6F runner passed:
  `All Phase 6F tests passed.`

### Closed (Checkpoint 6G)

* Closed Phase 6 under the conservative modernization model.
* Recorded that the traditional class-option layer, structured quiz-bank syntax,
  five-option `\choices` shuffling contract, `choiceoptions` shuffle guard,
  version-manifest syntax, `__pq` internal namespace, and visual output
  expectations remain preserved.
* Carried class-option modernization forward only as an optional future
  compatibility review.
* Added `PHASE6_CHECKPOINT_6G.md`.

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
