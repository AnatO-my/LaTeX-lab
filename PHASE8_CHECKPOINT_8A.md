# Phase 8 Checkpoint 8A - GitHub launch audit

## Scope

Checkpoint 8A opens Phase 8 as GitHub launch and collaborator onboarding.

This checkpoint does not create a remote, push to GitHub, install automation, or
change production class/package behavior. It records the local state that should
be checked before the first private GitHub push.

## Local launch state

The repository is locally ready for a private-first GitHub launch when:

* the working branch is `main`;
* all Phase 7 checkpoints are committed;
* no Git remote is configured yet, or any existing remote has been inspected;
* known local-only leftovers remain unstaged;
* `git diff --check` passes; and
* the Phase 7 starter runner passes.

## Known local-only leftovers

These remain outside the launch commit:

* `src/classes/physicsquiz.cls` line-ending-only working-tree noise;
* `AGENTS.md`;
* `examples/physicsquiz/indent.log`; and
* `tests/__pycache__/`.

## GitHub-side action still required

The next manual step is to create the private GitHub repository and add it as
`origin`, following `docs/GITHUB_PUSH_CHECKLIST.md`.

Do not push to a non-empty remote without inspecting it first.

## Verification

Run from the repository root:

```powershell
git status --short --branch
git remote -v
git diff --check
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```
