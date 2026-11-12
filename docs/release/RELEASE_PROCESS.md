# Release Process

The single reference for versioning, release checks, CI release gates and the l3build decision. It merges nine earlier documents (listed in the contents below); their original text is kept as sections, with headings demoted one level and cross-references updated.

## Contents

* [Versioning And Release Policy](#versioning-and-release-policy) (was `#versioning-and-release-policy`)
* [Local Release Checklist](#local-release-checklist) (was `#local-release-checklist`)
* [Release Readiness](#release-readiness) (was `#release-readiness`)
* [Release PDF Checklist](#release-pdf-checklist) (was `#release-pdf-checklist`)
* [Release Candidate Dry Run](#release-candidate-dry-run) (was `#release-candidate-dry-run`)
* [CI Release Gate Plan](#ci-release-gate-plan) (was `#ci-release-gate-plan`)
* [Targeted Regression Gate Plan](#targeted-regression-gate-plan) (was `#targeted-regression-gate-plan`)
* [Release Source Checks Promotion Checklist](#release-source-checks-promotion-checklist) (was `#release-source-checks-promotion-checklist`)
* [l3build Pilot](#l3build-pilot) (was `#l3build-pilot`)

## Versioning And Release Policy

### Purpose

This guide records the Phase 10A versioning and release boundary.

Phase 10 treats the LaTeX classes, packages, examples, and workflow scripts as
maintained software. The first rule is conservative: define the release policy
before changing any class or package version numbers.

### Current Version State

The current source has mixed version maturity:

| Area | Current state |
| --- | --- |
| `physicsquiz.cls` | declares `v0.1` and exposes public capability markers |
| `otboxes.sty`, `otcore.sty`, `ottheme.sty` | declare `v0.2` shared-package versions |
| other active classes and packages | have dated `\Provides...` lines without semantic version numbers |
| `src/legacy/otscience.sty` | preserved historical package, not an active release target |

Phase 10A does not change these values.

### Release Source

The source repository remains the release source of truth.

A release should be based on:

* a committed source state;
* a clean ordinary source status apart from known local-only files;
* passing local checks listed in the release checklist; and
* a GitHub tag or release entry only after the source state is chosen.

Generated PDFs, author kits, and preview zips remain release assets. They should
not be committed as ordinary source files.

### Version Labels

Use simple project release labels for repository-level releases:

```text
v0.1.0
v0.1.1
v0.2.0
```

Recommended meaning:

* patch: documentation, examples, tests, or tooling that does not change public
  author behavior;
* minor: new opt-in public features or compatible public-interface additions;
* major: incompatible public-interface removals or behavior changes.

Class/package semantic versions may lag behind the repository release label
until a checkpoint explicitly updates them.

### Public Interface Rule

Before a public command, environment, option, or package version changes:

1. update or add a focused test;
2. update `docs/PUBLIC_INTERFACES.md`;
3. update `CHANGELOG.md`;
4. update `PROJECT_STATE.md`; and
5. record whether the change is patch, minor, or major.

### Phase 10A Boundary

Phase 10A establishes policy and audit only.

It does not:

* bump class or package versions;
* add a Git tag;
* create release assets;
* add `l3build`; or
* broaden GitHub Actions.

Those are later Phase 10 decisions.

## Local Release Checklist

Use this checklist before tagging a release or drafting GitHub release notes.

This checklist is intentionally source-first. It confirms that the repository is
ready to choose a release source state before any generated assets are attached.

### Required Source State

Before a release source commit is chosen:

* `git diff --check` must pass;
* `git status --short --branch` should show only intentional source changes and
  known local-only files;
* release notes should be drafted from `docs/release/templates/RELEASE_NOTES_TEMPLATE.md`;
* release-candidate rehearsal steps should follow
  `#release-candidate-dry-run`;
* the version label should follow `#versioning-and-release-policy`;
* public-interface changes should be recorded in `docs/PUBLIC_INTERFACES.md`;
* generated PDFs, author kits, preview zips, logs, and `build/` outputs should
  stay out of ordinary source commits; and
* the release source should be a committed state, not unstaged local edits.

### Required Local Checks

Run the source-level release checks:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_release_policy_guard.ps1
```

Run the starter build check in a normal MiKTeX PowerShell environment before a
real release:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_starter_tests.ps1
```

### Optional Release Assets

Use these only when a release needs assets:

* `#release-pdf-checklist` for preview PDFs;
* `docs/AUTHOR_KIT.md#author-kit-build-checklist` for an author-kit zip; and
* `docs/release/templates/RELEASE_ASSET_MANIFEST_TEMPLATE.md` to record asset names, statuses,
  sources, and hashes;
* `docs/release/templates/RELEASE_NOTES_TEMPLATE.md` to record asset names and hashes.

Generated assets should be attached to a GitHub release or recorded locally.
They should not be committed as ordinary source files.

### Not Yet Required

These remain later Phase 10 decisions:

* broader GitHub Actions workflows;
  see `#ci-release-gate-plan` for the staged release-gate plan;
  see `#release-source-checks-promotion-checklist` before making the release-source
  workflow required;
* active `l3build` adoption, with the current pilot recorded in
  `#l3build-pilot`;
* class/package version bumps;
* publishing a release tag; and
* making generated assets mandatory for every release.

## Release Readiness

### Purpose

This guide defines what is ready to share when the repository is pushed to
GitHub or packaged for collaborators. It keeps the first release source-focused
and avoids treating generated files as ordinary source.

### Recommended First Release Shape

Use a private GitHub repository first. The first collaborator-ready release is
the repository itself, not a separate zip.

The repository should include:

* source classes in `src/classes/`;
* source packages in `src/packages/`;
* copyable starters in `examples/`;
* representative examples for comparison;
* `README.md`;
* `CONTRIBUTING.md`;
* `docs/AUTHOR_WORKFLOW.md`;
* `docs/STARTER_INVENTORY.md`;
* `docs/GITHUB_WORKFLOW.md#github-collaboration-checklist`;
* `docs/PUBLIC_INTERFACES.md`; and
* local verification runners under `tests/`.

Do not include new generated PDFs, logs, auxiliary files, or `build/` output in
ordinary source commits.

### Author Kit Boundary

An author kit can be produced later as a GitHub release asset, but it should be
derived from source rather than maintained as another hand-edited copy.
Use `scripts/new-author-kit.ps1` and
`docs/AUTHOR_KIT.md#author-kit-build-checklist` when preparing the kit.
The current local source-derived kit is recorded in `docs/AUTHOR_KIT.md#author-kit-audit`.

If an author kit is prepared, include:

* `README.md`;
* `CONTRIBUTING.md`;
* `.latexmkrc`;
* `docs/AUTHOR_WORKFLOW.md`;
* `docs/STARTER_INVENTORY.md`;
* `docs/PUBLIC_INTERFACES.md`;
* `src/classes/`;
* `src/packages/`;
* `examples/physicsquiz/starter_quiz_bank.tex`;
* `examples/physicsquiz/starter_versioned_quiz.tex`;
* `examples/studentnotes/starter_notes.tex`;
* `examples/otengineering/starter_engineering_notes.tex`;
* `examples/otscience/starter_science_notes.tex`;
* `examples/otbook/starter_personal_book.tex`;
* `templates/otbook-project/` (source only, including dotfiles);
* `examples/vector-workbook/starter_module.tex`;
* `examples/vector-workbook/starter_combined_workbook.tex`;
* `examples/vector-workbook/00_common_setup.tex`;
* `tests/run_starter_tests.ps1`;
* `tests/run_otbook_tests.ps1`;
* `tests/powershell_log_helpers.ps1`; and
* `tests/otbook_class_smoke.tex`.

The original audited kit predates `otbook`. New kits must include the book
class and starter and pass `tests/run_otbook_tests.ps1` as recorded in
`docs/AUTHOR_KIT.md#author-kit-build-checklist`; the Phase 7 runner covers seven starters.

Do not include:

* `build/`;
* `tests/__pycache__/`;
* generated `.aux`, `.log`, `.fls`, `.fdb_latexmk`, `.out`, `.toc`, or
  `.synctex.gz` files;
* local editor settings that are not already part of the project workflow; or
* exploratory files not approved for source control.

### Release PDFs

Release PDFs are optional. They are useful when a collaborator needs to preview
the expected visual result without building locally, but they should be attached
to a GitHub release rather than committed as normal source files.
Use `#release-pdf-checklist` before creating or attaching preview PDFs.
The current local preview set is recorded in
`docs/history/RELEASE_PREVIEW_PDF_AUDIT.md`.

A first PDF preview set would be:

* starter quiz bank;
* starter versioned quiz;
* starter student notes;
* starter engineering notes;
* starter science notes; and
* starter workbook module; and
* starter combined workbook.

### Pre-Push Checklist

Before pushing for collaborators:

* `git status --short --branch` shows only intentional source changes;
* `git diff --check` passes;
* `tests/run_starter_tests.ps1` passes;
* the book starter and smoke builds in `docs/STARTER_INVENTORY.md` pass;
* generated build files are excluded;
* the README points to the author workflow and contributing guide;
* issue and pull-request templates are present; and
* any public-interface change is recorded in `docs/PUBLIC_INTERFACES.md`.

Use `docs/GITHUB_WORKFLOW.md#github-push-checklist` for the step-by-step remote creation and
push runbook.

### Starter Automation

Checkpoint 8F adds the first GitHub Actions workflow for starter builds. The
first GitHub push did not depend on CI, and branch protection should still wait
until the starter-build workflow has passed consistently on `main`.
Use `docs/GITHUB_WORKFLOW.md#github-actions-ci-checklist` before expanding hosted checks.

Hosted CI starts with the starter runner before attempting the full historical
regression suites.

Checkpoint 8I records the first protected-`main` settings in
`docs/GITHUB_WORKFLOW.md#branch-protection-checklist`. The first required hosted check is
`Starter documents`; full regression workflows remain outside branch protection
for now.

## Release PDF Checklist

### Purpose

This checklist defines when and how to create preview PDFs for a GitHub release.
Preview PDFs help collaborators see the expected output without building
locally, but they remain release assets rather than ordinary source files.

Checkpoint 8G prepares the first local preview set and records it in
`docs/history/RELEASE_PREVIEW_PDF_AUDIT.md`.

### 1. Decide Whether PDFs Are Needed

Create release PDFs only when at least one of these is true:

* a collaborator needs visual previews before installing MiKTeX;
* a release announcement should show the starter outputs;
* a reviewer needs to compare expected layout against local builds; or
* a public-facing release needs quick inspection artifacts.

For routine source work, do not create release PDFs.

### 2. Build From a Clean Source Commit

From the repository root:

```powershell
git status --short --branch
git diff --check
powershell -ExecutionPolicy Bypass -File tests\run_starter_tests.ps1
```

Use the committed source state as the release source. Do not build release PDFs
from unstaged edits or local-only files.

### 3. Starter PDF Preview Set

The first preview set should come from the Phase 7 starter documents:

| Output | Source |
| --- | --- |
| Starter quiz bank PDF | `examples/physicsquiz/starter_quiz_bank.tex` |
| Starter versioned quiz PDF | `examples/physicsquiz/starter_versioned_quiz.tex` |
| Starter student notes PDF | `examples/studentnotes/starter_notes.tex` |
| Starter engineering notes PDF | `examples/otengineering/starter_engineering_notes.tex` |
| Starter science notes PDF | `examples/otscience/starter_science_notes.tex` |
| Starter workbook module PDF | `examples/vector-workbook/starter_module.tex` |
| Starter combined workbook PDF | `examples/vector-workbook/starter_combined_workbook.tex` |

The Phase 7C starter runner already builds these PDFs under `build/examples/`.

### 4. Visual Review

Before attaching PDFs to a release, open each preview and check:

* the title or first page clearly identifies the starter;
* pages are not blank;
* text is not visibly overlapping;
* tables, boxes, and formulas fit the page;
* the versioned quiz answer key and solutions match the rendered paper; and
* the workbook module builds as a standalone document.

If a PDF fails visual review, fix the source starter and rerun the starter
runner. Do not patch generated PDFs directly.

### 5. File Naming

Use names that make the release and source clear:

```text
latex-lab-starter-quiz-bank-YYYY-MM-DD.pdf
latex-lab-starter-versioned-quiz-YYYY-MM-DD.pdf
latex-lab-starter-student-notes-YYYY-MM-DD.pdf
latex-lab-starter-engineering-notes-YYYY-MM-DD.pdf
latex-lab-starter-science-notes-YYYY-MM-DD.pdf
latex-lab-starter-workbook-module-YYYY-MM-DD.pdf
latex-lab-starter-combined-workbook-YYYY-MM-DD.pdf
```

### 6. Attach to Release

Attach preview PDFs to a GitHub release. Do not commit them as ordinary source
files.

In the release notes, record:

* source commit hash;
* build command;
* whether all starter tests passed;
* whether visual review was completed; and
* which PDFs are attached.

### 7. Keep Source Clean

After preparing release PDFs:

```powershell
git status --short --branch
```

Generated PDFs, logs, and auxiliaries should remain untracked or ignored unless
a checkpoint explicitly approves a tracked baseline artifact.

## Release Candidate Dry Run

### Purpose

This guide defines the first source-only release-candidate rehearsal.

The dry run proves that the release checklist, release notes template, source
guards, CI gates, and asset-manifest template fit together before the project
publishes a real GitHub release.

### Candidate Label

Use a rehearsal label, not a real release tag:

```text
v0.1.0-rc-dry-run
```

Do not create this as a Git tag.

### Candidate Source

The candidate source should be:

* a committed branch or `main` state;
* clean apart from known local-only files;
* after the `Starter documents` GitHub check has passed;
* after the non-required `Release source checks` workflow has passed; and
* before any generated release asset is attached.

### Dry-Run Commands

Run source checks:

```powershell
git diff --check
powershell -ExecutionPolicy Bypass -File tests\run_release_policy_guard.ps1
powershell -ExecutionPolicy Bypass -File tests\run_build_recipe_guard.ps1
```

Run the starter build in the normal MiKTeX PowerShell environment:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_starter_tests.ps1
```

### Draft Release Notes

Draft notes from:

```text
docs/release/templates/RELEASE_NOTES_TEMPLATE.md
```

Record:

* candidate label;
* source commit;
* release type as `preview`;
* checks run;
* public-interface status;
* asset status;
* known limitations; and
* whether admin bypass was used in the PR history.

### Asset Decision

Use:

```text
docs/release/templates/RELEASE_ASSET_MANIFEST_TEMPLATE.md
```

For the first dry run, mark assets as `omitted` unless preview PDFs or an author
kit are intentionally prepared.

Generated PDFs, zips, logs, auxiliaries, and `build/` outputs remain out of
ordinary source commits.

### Go / No-Go Questions

Before a real release:

* Did `Starter documents` pass on GitHub?
* Did `Release source checks` pass on GitHub?
* Are release notes complete?
* Is the asset manifest complete, even if assets are omitted?
* Are known local-only files excluded from source?
* Are public-interface changes recorded?
* Is a repository label such as `v0.1.0` appropriate?

### Phase 10J Boundary

Phase 10J creates no Git tag, GitHub release, release asset, generated PDF,
author-kit zip, class/package version bump, or branch-protection change.

The next implementation checkpoint can perform the dry run after the current
pull request has passed hosted checks.

## CI Release Gate Plan

### Purpose

This plan describes how hosted CI should grow from the current starter check
into a release gate.

It is intentionally a plan, not a new workflow. The current protected `main`
rule should continue to require only `Starter documents` until each wider check
has passed repeatedly on GitHub and remains understandable for collaborators.

### Current Required Gate

The current required GitHub status check is:

```text
Starter documents
```

That job proves:

* the hosted MiKTeX setup works;
* project-local classes and packages are discovered;
* all starter documents build;
* generated PDFs are uploaded only as workflow artifacts; and
* `git diff --check` passes.

The current workflow is `.github/workflows/starter-build.yml`.

### Proposed Gate Levels

#### Level 1 - Starter Gate

Status: active and required.

Keep requiring:

```powershell
git diff --check
tests\run_starter_tests.ps1
```

This remains the only branch-protection requirement until broader hosted checks
have proven stable.

#### Level 2 - Release Source Gate

Status: active as a non-required workflow.

Workflow:

```text
.github/workflows/release-source-checks.yml
```

Candidate checks:

```powershell
tests\run_release_policy_guard.ps1
tests\run_build_recipe_guard.ps1
```

Purpose:

* confirm release policy files are present;
* confirm release-note and asset-manifest templates stay complete;
* confirm the local release checklist still names the required source gates;
* confirm the `l3build` pilot stays non-mandatory until adoption; and
* confirm PowerShell runners remain parseable.

This level runs on pull requests first. Do not make it required until it has
passed on several ordinary PRs.

#### Level 3 - Targeted Regression Gate

Status: planned, not active.

Plan:

```text
#targeted-regression-gate-plan
```

Candidate checks:

```powershell
tests\run_phase6f_tests.ps1
tests\run_ot_baseline_tests.ps1
```

Purpose:

* catch changes to the structured physics quiz behavior;
* catch OT class/package rendering baseline drift; and
* keep expensive or baseline-sensitive checks separate from the starter gate.

This level should be manual or scheduled before it becomes a required PR check.

#### Level 4 - Release Asset Gate

Status: deferred.

Candidate actions:

* build release-preview PDFs;
* build an author-kit zip;
* record asset hashes with `docs/release/templates/RELEASE_ASSET_MANIFEST_TEMPLATE.md`; and
* attach assets to a GitHub release.

This level should not run on every pull request.

The first source-only release rehearsal is recorded in
`#release-candidate-dry-run`.

### Promotion Rules

Promote a planned gate only when:

* it passes on GitHub at least twice without source changes;
* failures are readable from the GitHub log;
* package installation is explicit enough for hosted MiKTeX;
* runtime is acceptable for ordinary pull requests;
* generated outputs remain artifacts or ignored build files; and
* the local checklist has a matching command.

### Branch Protection Rules

Do not add a new required status check immediately.

When Level 2 is stable, add it as a separate required status check instead of
folding it into `Starter documents`. Separate checks make failures easier to
understand:

```text
Starter documents
Release source checks
```

Keep admin bypass available while hosted LaTeX behavior is still being hardened.

### Phase 10F Boundary

Phase 10F creates no new GitHub Actions workflow, required status check,
release tag, generated asset, package version bump, or `l3build` adoption.

Checkpoint 10G adds the non-required Level 2 workflow. Checkpoint 10H records
the promotion checklist for making it required later.

## Targeted Regression Gate Plan

### Purpose

This plan defines how broader regression checks should enter hosted CI without
making ordinary pull requests slow or hard to diagnose.

The current required check remains:

```text
Starter documents
```

The current non-required source check is:

```text
Release source checks
```

Targeted regression checks are the next wider layer. They should begin as manual
or scheduled checks before they become pull-request requirements.

### Candidate Checks

Start with the smallest high-value candidates:

| Candidate | Command | Why it matters | First hosted mode |
| --- | --- | --- | --- |
| PhysicsQuiz versioned-paper review | `tests\run_phase6f_tests.ps1` | catches versioned-paper selection and review regressions | manual dispatch |
| OT rendering baseline | `tests\run_ot_baseline_tests.ps1` | catches class/package rendering drift | manual dispatch or scheduled |

These checks are intentionally separate from `Release source checks` because
they may need MiKTeX package installation, generated build output, and more
careful log review.

### Hosted Workflow Shape

A future workflow can be named:

```text
Targeted Regression Checks
```

Recommended triggers:

```yaml
workflow_dispatch:
schedule:
```

Do not run the targeted regression workflow on every pull request until it has
proven stable on GitHub.

### Pass Criteria

Before promoting any targeted regression job:

* it passes locally in the normal MiKTeX PowerShell environment;
* it passes on GitHub at least twice;
* missing hosted MiKTeX packages are installed explicitly;
* logs point clearly to the failing source or baseline;
* generated files remain under ignored `build/` paths or workflow artifacts; and
* the job runtime is acceptable for the chosen trigger.

### Failure Handling

When a targeted regression job fails:

* do not patch generated PDFs or logs;
* inspect the source change, baseline record, or hosted MiKTeX package setup;
* keep failures separate from starter failures; and
* update the checkpoint record before changing branch protection.

### Branch Protection Boundary

Do not add targeted regression checks to branch protection yet.

The first protected checks should remain:

```text
Starter documents
```

and, only after promotion:

```text
Release source checks
```

Targeted regression checks should become required only after manual or scheduled
hosted runs are stable and their failures are easy to interpret.

### Phase 10I Boundary

Phase 10I creates no targeted regression workflow, required status check,
baseline update, generated PDF, release asset, tag, version bump, or `l3build`
adoption.

The next implementation checkpoint can add a manual `Targeted Regression
Checks` workflow after this plan is reviewed.

## Release Source Checks Promotion Checklist

### Purpose

This checklist records when the `Release source checks` GitHub Actions job can
move from optional CI to a required branch-protection check.

Checkpoint 10G adds the workflow. Checkpoint 10H keeps it non-required until the
hosted run history proves that it is stable and useful.

### Current Status

The workflow file is:

```text
.github/workflows/release-source-checks.yml
```

The job name is:

```text
Release source checks
```

Current branch protection should still require only:

```text
Starter documents
```

### What The Workflow Runs

The workflow runs source-level checks only:

```powershell
git diff --check
tests\run_release_policy_guard.ps1
tests\run_build_recipe_guard.ps1
```

It does not install MiKTeX, build starter PDFs, run the Phase 5 rendering
baseline, run Phase 6F generated-paper checks, build release assets, or adopt
`l3build`.

### Promotion Criteria

Promote `Release source checks` to a required status check only after:

* it passes on at least two pull requests or workflow dispatches without source
  changes made only to appease hosted CI;
* failures are readable from the GitHub Actions log;
* runtime remains acceptable for ordinary pull requests;
* the `Starter documents` required check remains stable;
* generated outputs remain ignored and are not uploaded as release assets by
  this workflow; and
* the maintainer is comfortable recovering with admin bypass if hosted CI
  changes unexpectedly.

### How To Promote Later

When the criteria are met:

1. Open repository branch protection settings.
2. Edit the `main` branch rule.
3. Keep `Starter documents` required.
4. Add `Release source checks` as a second required status check.
5. Keep force pushes and deletion disabled.
6. Keep admin bypass available until the second check survives normal use.

Do not require this check before it has completed successfully on GitHub.

### Rollback

If the check becomes noisy:

* remove only `Release source checks` from required status checks;
* keep `Starter documents` required;
* fix the workflow on a branch; and
* restore the requirement after the workflow is stable again.

### Phase 10H Boundary

Phase 10H does not change branch protection.

It records the promotion criteria for a future manual GitHub setting change.

## l3build Pilot

### Purpose

This pilot evaluates whether `l3build` is worth adding to the release workflow.

The project already has useful PowerShell guards for starter builds, rendered
baseline checks, release policy, and generated-file hygiene. The pilot does not
replace those checks. It only records the smallest useful `l3build` role so a
future checkpoint can decide whether to adopt it deliberately.

### Current Decision

Checkpoint 10E does not add an active root `build.lua`.

That is intentional. A root `build.lua` would make `l3build` look adopted across
the repository before we have confirmed the value, maintenance cost, and
expected output shape.

For now:

* PowerShell runners remain the source of truth for existing tests;
* `l3build` is optional and may be missing from a local shell;
* no release requires `l3build check`;
* no `.tlg` reference logs are introduced; and
* no class/package version is changed.

### Candidate Scope

If adopted later, `l3build` should start with a very small surface:

| Candidate area | Why it fits | Keep outside l3build for now |
| --- | --- | --- |
| package/class smoke tests | stable logs can catch interface regressions | visual PDF review |
| public version metadata probes | output is small and text-like | full starter PDF builds |
| dot-grid fallback smoke test | confirms command availability | timing measurements |
| release policy source checks | can remain PowerShell unless a clear gain appears | GitHub release assets |

The first active suite should cover one package/class family only. Expanding to
every example at once would make failures noisy and hard to interpret.

### Candidate Folder Shape

A future active proof could live under:

```text
tests/l3build-proof/
  build.lua
  testfiles/
    otcore-smoke.lvt
    otcore-smoke.tlg
```

The project root should not get an active `build.lua` until the pilot has shown
that the test output is stable on Windows and GitHub Actions.

### Candidate Commands

From the candidate proof folder:

```powershell
l3build check
l3build clean
```

If the proof graduates into a release gate, the local release checklist can add:

```powershell
Push-Location tests\l3build-proof
l3build check
Pop-Location
```

### Adoption Conditions

Adopt `l3build` only when all of these are true:

* `l3build` is available in the normal MiKTeX environment;
* one tiny proof suite passes locally and in GitHub Actions;
* generated `.tlg` references are stable across repeated runs;
* failures are easier to understand than the equivalent PowerShell guard;
* the suite does not duplicate expensive starter builds; and
* the release checklist can explain the command without extra setup work.

### Rejection Conditions

Do not adopt `l3build` if:

* it produces unstable logs on Windows;
* it needs broad fixture rewrites before proving value;
* it makes simple starter-build failures harder for collaborators to understand;
* it pulls generated PDFs or build output into source; or
* it duplicates the existing guards without improving confidence.

### Phase 10E Boundary

Phase 10E is an evaluation checkpoint only.

It creates no active `build.lua`, no `.lvt` or `.tlg` fixtures, no release tag,
no version bump, no generated asset, and no new CI requirement.
