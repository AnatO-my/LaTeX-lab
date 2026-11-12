# GitHub Workflow

Collaboration, branches, pull requests, branch protection, pushing, CI and onboarding on GitHub. It merges seven earlier documents; `CONTRIBUTING.md` is the short entry point.

## Contents

* [GitHub Collaboration Checklist](#github-collaboration-checklist) (was `#github-collaboration-checklist`)
* [Branch and Pull Request Policy](#branch-and-pull-request-policy) (was `#branch-and-pull-request-policy`)
* [Branch Protection Checklist](#branch-protection-checklist) (was `#branch-protection-checklist`)
* [GitHub Push Checklist](#github-push-checklist) (was `#github-push-checklist`)
* [GitHub Actions CI Checklist](#github-actions-ci-checklist) (was `#github-actions-ci-checklist`)
* [Collaborator Onboarding Checklist](#collaborator-onboarding-checklist) (was `#collaborator-onboarding-checklist`)
* [GitHub Launch Audit](#github-launch-audit) (was `#github-launch-audit`)

## GitHub Collaboration Checklist

### Purpose

This checklist captures the decisions needed before pushing the repository for
collaborators.

### Recommended First Setup

Start with a private GitHub repository. Invite collaborators after the README,
author workflow guide, starter inventory, and starter build checks are present.

Use:

* `main` as the stable branch;
* feature branches for changes;
* pull requests once more than one person is editing;
* source-only commits by default;
* generated PDFs and logs excluded from ordinary commits; and
* `README.md`, `docs/AUTHOR_WORKFLOW.md`, and `docs/PUBLIC_INTERFACES.md` as
  the onboarding and contract documents.

### Decisions Before Push

| Decision | Recommended default |
| --- | --- |
| Visibility | Private first. |
| Default branch | `main`. |
| Branch naming | Use short feature branches, for example `phase7-starters`. |
| Review style | Pull requests for collaborator changes. |
| Required checks | Relevant phase runner plus `git diff --check`. |
| Build artifacts | Keep `build/`, logs, and generated auxiliaries out of commits. |
| PDFs | Generate locally; attach release PDFs only when intentionally publishing. |
| Issues | Use labels for docs, starters, tests, examples, classes, packages, and workflow. |
| Releases | Use the source repository first; prepare author-kit assets later from a manifest. |

### Suggested Labels

* `docs`
* `starter`
* `workflow`
* `physicsquiz`
* `studentnotes`
* `otscience`
* `otengineering`
* `vector-workbook`
* `tests`
* `packaging`
* `question`

### Pull Request Checklist

Each collaborator pull request should say:

* what changed;
* which public interface is affected, if any;
* which command was run;
* whether generated artifacts were intentionally excluded; and
* whether the change needs visual review.

Checkpoint 7D adds `.github/PULL_REQUEST_TEMPLATE.md`, so GitHub will present
this checklist automatically when a collaborator opens a pull request.

Checkpoint 8E adds `#branch-and-pull-request-policy`, which records the first
branch and pull-request working agreement. It keeps enforcement manual until at
least one collaborator pull request has been tried and starter-build CI is
stable.
Checkpoint 8F adds `.github/workflows/starter-build.yml`, the first hosted
starter-build workflow. Do not require it in branch protection until it has
passed consistently on `main`.
Checkpoint 8I adds `#branch-protection-checklist`, which records the
first protected-`main` settings after the hosted starter workflow passed again
at commit `e9374af`.

### Issue Templates

Checkpoint 7D adds issue templates for:

* bug reports;
* starter or example requests; and
* workflow questions.

Use these to keep support requests tied to an outcome, a command, and the file
or starter involved.

### Not Yet Decided

These can wait until after the initial collaboration and release boundary:

* whether to mirror docs into a hosted site; and
* whether to support a downstream project template separate from this lab repo.

### Release Boundary

Checkpoint 7E records `docs/release/RELEASE_PROCESS.md#release-readiness` and
`docs/AUTHOR_KIT.md#author-kit-manifest`. The first shareable form should be the source
repository itself. A future author kit should be generated from the manifest,
and optional preview PDFs should be attached to releases rather than committed
as ordinary source.

Checkpoint 7G adds `docs/AUTHOR_KIT.md#author-kit-build-checklist`, which describes how to
assemble and verify that future kit without maintaining a second copy.
Checkpoint 7H adds `docs/release/RELEASE_PROCESS.md#release-pdf-checklist`, which describes how optional
preview PDFs should be generated, reviewed, and attached to releases.
Checkpoint 7I adds `#github-actions-ci-checklist`, which describes when
hosted CI should be added and why it should start with the starter runner.
Checkpoint 7J adds `docs/COMBINED_WORKBOOK_STARTER_CHECKLIST.md`, which records
the decision to support both standalone workbook modules and a combined workbook
root.

### Push Checklist

Checkpoint 7F records `#github-push-checklist`. Use it when the project
is ready to create the private GitHub repository, add the `origin` remote, push
`main`, and inspect the rendered GitHub templates.

### Collaborator Onboarding

Checkpoint 8D adds `#collaborator-onboarding-checklist`. Use it before
inviting the first collaborators.

The first onboarding packet should include:

* the repository URL;
* `README.md`;
* `docs/AUTHOR_WORKFLOW.md`;
* `CONTRIBUTING.md`;
* `docs/STARTER_INVENTORY.md`;
* `#branch-and-pull-request-policy`;
* `#branch-protection-checklist`;
* `#collaborator-onboarding-checklist`; and
* the starter verification command.

Keep the first collaborator path small: clone the repository, build a starter,
run the starter guard, then make a small branch-based contribution.

## Branch and Pull Request Policy

### Purpose

This policy describes how collaborators should make shared changes after the
first GitHub launch.

It began as a working agreement first. Checkpoint 8I adds
`#branch-protection-checklist`, which records the first protected-`main`
settings after the starter-build workflow passed consistently on `main`.

### Stable Branch

Use `main` as the stable branch.

`main` should contain source that has either:

* passed the relevant local check; or
* been intentionally recorded as a checkpoint with its verification boundary.

Maintainer checkpoint commits may still go directly to `main` until branch
protection is enabled. Collaborator changes should use branches and pull
requests.

### Feature Branches

Use short branch names that describe the outcome:

```text
docs-branch-policy
starter-studentnotes-example
fix-physicsquiz-message
workflow-ci-checklist
```

Prefer one clear outcome per branch. Avoid mixing unrelated class, package,
example, documentation, and workflow changes in a single pull request.

### Pull Requests

Open a pull request for collaborator changes.

Each pull request should state:

* what changed;
* which files or author-facing behavior were touched;
* which commands were run;
* whether generated artifacts were excluded; and
* whether visual PDF review is needed.

Use `.github/PULL_REQUEST_TEMPLATE.md` as the review checklist.

### Required Local Checks

Before opening a pull request, run:

```powershell
git status --short --branch
git diff --check
```

For documentation, starter, workflow, packaging, and onboarding changes, also
run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_starter_tests.ps1
```

For `physicsquiz.cls` behavior changes, run the latest relevant physicsquiz
phase runner and explain why that runner is sufficient.

For OT class or package changes, run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_ot_baseline_tests.ps1
```

### Generated Artifacts

Do not commit ordinary generated outputs:

* `build/`;
* PDFs created by local builds;
* `.aux`, `.log`, `.fls`, `.fdb_latexmk`, `.out`, `.toc`, or SyncTeX files;
* Python cache folders; or
* local editor/theme files.

Generated assets belong in GitHub release assets only when a release checklist
explicitly calls for them.

### Review Expectations

Small documentation and starter changes can be reviewed for clarity, build
commands, and artifact hygiene.

Class, package, public-interface, baseline, and representative-example changes
need stricter review. The pull request should identify the author-facing impact,
the compatibility risk, and the verification command.

### GitHub Settings

Use `#branch-protection-checklist` for the first protected-`main` setup.

The first rule should:

* requiring pull requests before merging into `main`;
* require the `Starter documents` status check to pass;
* require at least one approving review;
* require conversation resolution;
* clear stale approvals after new commits; and
* block force pushes and deletion of `main`.

Stricter settings such as signed commits, linear history, merge queue, full
regression workflows, and removing admin bypass remain later decisions.

## Branch Protection Checklist

### Purpose

This checklist records the first protected-`main` setup for the GitHub
repository.

The goal is simple: collaborators should use pull requests, the starter build
should pass before merge, and `main` should not be force-pushed or deleted by
accident.

### Preconditions

Enable branch protection only after:

* `main` has been pushed to GitHub;
* `.github/workflows/starter-build.yml` exists on `main`;
* the hosted `Starter documents` job has passed on `main`; and
* generated outputs remain absent from the repository source.

These conditions were met before this checklist was added. Commit `e9374af`
passed the hosted starter workflow in 5m 12s and produced the `starter-pdfs`
artifact.

### Recommended First Rule

Use a classic branch protection rule first.

Repository path:

```text
Settings -> Branches -> Branch protection rules -> Add rule
```

Rule target:

```text
main
```

Enable:

* require a pull request before merging;
* require approvals: `1`;
* dismiss stale pull request approvals when new commits are pushed;
* require conversation resolution before merging;
* require status checks to pass before merging;
* require branches to be up to date before merging; and
* required status check: `Starter documents`.

Leave disabled for the first rule:

* require signed commits;
* require linear history;
* require merge queue;
* require deployments before merging;
* lock branch;
* restrict who can push to matching branches;
* allow force pushes; and
* allow deletions.

Do not enable "Do not allow bypassing the above settings" for the first rule.
Keeping admin bypass available gives the maintainer a recovery path while the
hosted workflow is still young.

### Expected Outcome

After the rule is saved:

* collaborators cannot merge into `main` without a pull request;
* pull requests need one approval;
* unresolved conversations block merge;
* `Starter documents` must pass before merge;
* stale approvals are cleared when new commits are pushed; and
* force pushes and branch deletion stay blocked by default.

### Applied Result

The first rule has been applied on GitHub. The branch settings page showed:

```text
main
Currently applies to 1 branch
```

### Deferred Tightening

Do not add stricter requirements until the first protected collaborator pull
request has been tried.

Later candidates:

* require signed commits;
* require linear history;
* require full regression workflows;
* add `Release source checks` after applying
  `docs/release/RELEASE_PROCESS.md#release-source-checks-promotion-checklist`;
* use repository rulesets if several branches need shared rules; and
* remove admin bypass only after the recovery path is clear.

## GitHub Push Checklist

### Purpose

This checklist is the final local runbook before the repository is pushed for
collaborators. It assumes the first GitHub repository is private and that the
source repository is the first shareable form.

### 1. Local Readiness

Before creating or pushing to a remote:

* confirm the working branch is `main`;
* confirm all intended Phase 7 checkpoints are committed;
* leave local-only files untracked or ignored;
* keep generated outputs out of source commits;
* run `git diff --check`; and
* run the starter check:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_starter_tests.ps1
```

Expected known local leftovers before push:

* `src/classes/physicsquiz.cls` line-ending-only working-tree noise;
* `AGENTS.md`;
* `examples/physicsquiz/indent.log`; and
* `tests/__pycache__/`.

Do not stage those unless a later checkpoint explicitly changes the policy.

### 2. Create the GitHub Repository

Recommended first settings:

* visibility: private;
* default branch: `main`;
* initialize with README: no, because the local repository already has one;
* add `.gitignore`: no, because the local repository already has one;
* add license: decide separately before public release.

### 3. Add the Remote

After creating the empty GitHub repository, add the remote from the local
repository root:

```powershell
git remote add origin <github-repository-url>
git remote -v
```

If a remote already exists, inspect it before changing it:

```powershell
git remote -v
```

### 4. Push `main`

Push the current branch:

```powershell
git push -u origin main
```

If GitHub rejects the push because the remote is not empty, stop and inspect the
remote before merging or force-pushing.

### 5. Inspect GitHub After Push

In GitHub, confirm:

* `README.md` renders on the repository landing page;
* `CONTRIBUTING.md` is visible;
* `.github/PULL_REQUEST_TEMPLATE.md` appears when opening a test pull request;
* issue templates appear for bug reports, starter/example requests, and workflow
  questions;
* `docs/AUTHOR_WORKFLOW.md` and `docs/release/RELEASE_PROCESS.md#release-readiness` render correctly;
* generated `build/` files are absent; and
* starter files are present under `examples/`.

### 6. First Collaborator Instructions

Send collaborators:

* the repository URL;
* `README.md`;
* `docs/AUTHOR_WORKFLOW.md`;
* `CONTRIBUTING.md`;
* `docs/STARTER_INVENTORY.md`; and
* the starter verification command.

Ask them to work from feature branches and open pull requests for shared
changes.

### 7. Optional Branch Protection

After the first collaborator has access, consider enabling:

* pull requests before merging into `main`;
* no direct pushes to `main`;
* required status checks later, once starter CI is stable; and
* branch deletion after merge.

Do not require CI checks until the starter-build GitHub Actions workflow has
passed consistently on the repository.
Use `#github-actions-ci-checklist` before adding that workflow.

## GitHub Actions CI Checklist

### Purpose

This checklist defines when GitHub Actions should be added and what the first CI
workflow should prove.

Checkpoint 8F adds the first workflow at
`.github/workflows/starter-build.yml`. After hosted MiKTeX setup stabilization,
commit `f40f051` passed on `main` and produced the `starter-pdfs` artifact.
Commit `e9374af` then passed after the hosted download retry was added.
Checkpoint 8I promotes the `Starter documents` job into the first required
branch-protection check for `main`.

### 1. Add CI Only After GitHub Push

Checkpoint 8F satisfies the preconditions for adding the first workflow:

* the private GitHub repository exists;
* `main` has been pushed;
* README, issue templates, and pull-request template render correctly;
* the Phase 7C starter runner passes locally; and
* the first collaborator workflow is clear.

### 2. First CI Scope

The first CI workflow is narrow:

* install or provide a TeX environment;
* run `git diff --check`;
* run `tests/run_starter_tests.ps1`; and
* upload starter PDFs only as workflow artifacts, not as source files.

The first workflow does not run the full historical regression suites.

### 3. Why Start With Starters

The starter runner is the best first CI target because it proves the author
experience:

* the project-local class and package discovery works;
* all copyable starter documents build;
* generated outputs stay under `build/`; and
* collaborators can trust the starting points before editing larger examples.

### 4. Hosted Environment Risks

Before requiring CI for pull requests, confirm:

* the selected runner has a reliable LaTeX distribution;
* required packages such as `xsim` and `siunitx` are available;
* PowerShell path behaviour is stable;
* hosted package downloads survive transient network timeouts;
* builds do not rely on user-local MiKTeX state;
* generated PDFs land in the expected `build/` paths; and
* the workflow finishes quickly enough to be useful.

### 5. CI Pass Criteria

The first workflow is ready to become a required check only when:

* `git diff --check` passes;
* all Phase 7C starter builds pass;
* no generated outputs are committed;
* logs are available for failed builds; and
* a failed starter build blocks the pull request only after the workflow has
  passed consistently on `main`.

The first pushed run passed in 4m 33s. Later runs exposed hosted MiKTeX
installation and path-discovery issues with Chocolatey. The workflow now uses
MiKTeX's standalone setup utility, installs into `RUNNER_TEMP`, and adds
discovered TeX tool directories to `GITHUB_PATH`. It also updates the current
step's `PATH` before running MiKTeX commands and installs `latexmk` explicitly.
After a later documentation-only push timed out while downloading the setup
zip, the workflow added bounded retry and backoff around that download.
After the protected-branch pull-request trial exposed a missing
`amsthm.sty` during `examples/studentnotes/starter_notes.tex`, the workflow
started installing `amscls` explicitly. `amscls` provides `amsthm.sty`, so the
starter job no longer depends on hosted MiKTeX discovering that package during
the build.

GitHub also reported a Node.js 20 deprecation warning for `actions/checkout@v4`
and `actions/upload-artifact@v4` being forced to run on Node.js 24. Treat that
as a watch item for future action-version updates, not as a failed starter-build
result.

Final stabilized run:

```text
Commit f40f051: Success in 4m 43s.
Starter documents job passed in 4m 40s.
Artifact: starter-pdfs, 780 KB.

Commit e9374af: Success in 5m 12s.
Starter documents job passed in 5m 9s.
Artifact: starter-pdfs, 780 KB.
```

### 6. What Stays Local For Now

Keep these local until CI is stable:

* full Phase 4 physicsquiz regression chain;
* full Phase 5 OT rendering baseline checks;
* visual PDF review;
* release PDF preparation; and
* author-kit zip creation.

### 7. Branch Protection

Checkpoint 8I records the first protected-`main` settings in
`#branch-protection-checklist`.

Use `Starter documents` as the required status check. Do not require the full
historical regression suites in branch protection yet.

### 8. Later CI Expansion

Checkpoint 10F records the broader release-gate plan in
`docs/release/RELEASE_PROCESS.md#ci-release-gate-plan`.
Checkpoints 10G and 10H add the non-required `Release source checks` workflow
and its promotion checklist in `docs/release/RELEASE_PROCESS.md#release-source-checks-promotion-checklist`.

After starter CI is stable, consider adding:

* a scheduled full regression job;
* manual workflow dispatch for release PDF previews;
* artifact upload for starter PDFs;
* branch protection requiring starter CI; and
* separate jobs for physicsquiz and OT-side regression suites.

Each expansion should be a separate checkpoint because hosted LaTeX behaviour
can differ from the local MiKTeX environment.

## Collaborator Onboarding Checklist

### Purpose

This checklist gives a new collaborator the smallest safe path from GitHub
access to a useful first contribution.

### Access

Recommended first access:

* keep the repository private;
* give trusted active collaborators write access;
* keep admin permissions limited to repository maintainers;
* defer branch protection until the first collaborator workflow is confirmed;
  and
* defer required CI checks until the starter-build GitHub Actions workflow has
  passed consistently on `main`.

### First Message to a Collaborator

Send:

* repository URL: `https://github.com/AnatO-my/LaTeX-lab.git`;
* `README.md`;
* `docs/AUTHOR_WORKFLOW.md`;
* `CONTRIBUTING.md`;
* `docs/STARTER_INVENTORY.md`;
* `#branch-and-pull-request-policy`; and
* this checklist.

Ask them to start by cloning the repository and building one starter document.

### First Local Check

From the repository root, run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_starter_tests.ps1
```

A collaborator is ready to edit source when the starter runner passes locally.

### First Contribution Shape

Good first contributions are small and easy to review:

* fix or clarify documentation;
* add a small starter note or example request through an issue;
* improve a starter without changing public class behavior; or
* report a build issue with the exact command and log excerpt.

Avoid first contributions that change class internals, package behavior,
generated artifacts, or large representative examples unless the change has
already been discussed.

### Branch and Pull Request Habit

Use short feature branches, for example:

```powershell
git switch -c docs-onboarding-note
```

Before opening a pull request:

```powershell
git status --short --branch
git diff --check
powershell -ExecutionPolicy Bypass -File tests\run_starter_tests.ps1
```

The pull request should say what changed, which command was run, and whether any
generated artifacts were intentionally excluded.

Use `#branch-and-pull-request-policy` for the current branch naming, pull-request,
and review expectations.

### Do Not Commit

Do not commit:

* `build/`;
* generated PDFs, logs, auxiliary files, or SyncTeX files;
* local editor color/theme changes;
* Python cache folders; or
* local instruction files.

### Escalate Before Editing

Ask before changing:

* `src/classes/`;
* `src/packages/`;
* `docs/PUBLIC_INTERFACES.md`;
* representative course-scale examples; or
* test baselines.

## GitHub Launch Audit

### Purpose

This audit records the local state before the first private GitHub launch. It is
the bridge between the Phase 7 readiness documents and the actual push process.

### Current Result

The repository has completed the first GitHub push and the first GitHub-side
inspection.

Local state to preserve:

* branch: `main`;
* remote: `origin` points to `https://github.com/AnatO-my/LaTeX-lab.git`;
* normal commit policy: source files only;
* generated outputs: excluded from source commits; and
* first hosted automation: `starter-build.yml` is present and verified; and
* first branch-protection settings: recorded in
  `#branch-protection-checklist`.

### Expected Local Leftovers

The following are expected before the first push and should remain unstaged:

* `src/classes/physicsquiz.cls` line-ending-only working-tree noise;
* `AGENTS.md`;
* `examples/physicsquiz/indent.log`; and
* `tests/__pycache__/`.

### Launch Sequence

Use `#github-push-checklist` for the full runbook.

The short sequence is:

1. Create a private GitHub repository without initializing it with a README,
   `.gitignore`, or license.
2. Add the remote locally with `git remote add origin <github-repository-url>`.
3. Inspect the remote with `git remote -v`.
4. Push with `git push -u origin main`.
5. Inspect the rendered README, contribution guide, issue templates, pull
   request template, workflow docs, and starter files on GitHub.

Steps 1 through 5 are complete for
`https://github.com/AnatO-my/LaTeX-lab.git`.

The GitHub inspection confirmed:

* expected files are present;
* generated output files are absent; and
* the `build/` folder is absent.

### After Push

After the first push inspection, the next checkpoints can choose whether to:

* onboard first collaborators;
* inspect starter-build GitHub Actions;
* prepare release preview PDFs; or
* prepare a source-derived author kit.

Checkpoint 8G prepares the first local release-preview PDF set and records it in
`docs/history/RELEASE_PREVIEW_PDF_AUDIT.md`. The PDFs remain under `build/` until they
are attached manually to a GitHub release.

Checkpoint 8I records the first protected-`main` settings after the hosted
starter workflow passed again at commit `e9374af`.
