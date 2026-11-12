# Phase 7 Checkpoint 7A - Workflow and collaboration opening

## Scope

Checkpoint 7A opens Phase 7: local author workflow and distribution readiness.

The checkpoint is documentation-only. It does not change classes, packages,
tests, examples, or rendering behaviour.

## Outcome

7A establishes the first user-facing project landing page and workflow guide:

* `README.md` gives collaborators a repository overview, requirements, quick
  build commands, and status.
* `docs/AUTHOR_WORKFLOW.md` explains local setup, starter choices, build
  commands, Git hygiene, and the GitHub collaboration track.

## GitHub collaboration decision

Preparing for GitHub collaboration is worth doing in Phase 7. The repository
already has meaningful history, tests, public-interface records, and examples.
The remaining work is making the contribution path explicit enough that a
collaborator can clone, build, edit, test, and submit changes without relying on
chat context.

## Verification

This checkpoint is docs-only. Verification consists of:

```powershell
git diff --check
git status --short --branch
```

The existing Phase 6F runner remains the latest full physicsquiz guard:

```text
All Phase 6F versioned-paper checks passed.
All Phase 6F tests passed.
```
