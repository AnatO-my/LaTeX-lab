# l3build Pilot

## Purpose

This pilot evaluates whether `l3build` is worth adding to the release workflow.

The project already has useful PowerShell guards for starter builds, rendered
baseline checks, release policy, and generated-file hygiene. The pilot does not
replace those checks. It only records the smallest useful `l3build` role so a
future checkpoint can decide whether to adopt it deliberately.

## Current Decision

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

## Candidate Scope

If adopted later, `l3build` should start with a very small surface:

| Candidate area | Why it fits | Keep outside l3build for now |
| --- | --- | --- |
| package/class smoke tests | stable logs can catch interface regressions | visual PDF review |
| public version metadata probes | output is small and text-like | full starter PDF builds |
| dot-grid fallback smoke test | confirms command availability | timing measurements |
| release policy source checks | can remain PowerShell unless a clear gain appears | GitHub release assets |

The first active suite should cover one package/class family only. Expanding to
every example at once would make failures noisy and hard to interpret.

## Candidate Folder Shape

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

## Candidate Commands

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

## Adoption Conditions

Adopt `l3build` only when all of these are true:

* `l3build` is available in the normal MiKTeX environment;
* one tiny proof suite passes locally and in GitHub Actions;
* generated `.tlg` references are stable across repeated runs;
* failures are easier to understand than the equivalent PowerShell guard;
* the suite does not duplicate expensive starter builds; and
* the release checklist can explain the command without extra setup work.

## Rejection Conditions

Do not adopt `l3build` if:

* it produces unstable logs on Windows;
* it needs broad fixture rewrites before proving value;
* it makes simple starter-build failures harder for collaborators to understand;
* it pulls generated PDFs or build output into source; or
* it duplicates the existing guards without improving confidence.

## Phase 10E Boundary

Phase 10E is an evaluation checkpoint only.

It creates no active `build.lua`, no `.lvt` or `.tlg` fixtures, no release tag,
no version bump, no generated asset, and no new CI requirement.
