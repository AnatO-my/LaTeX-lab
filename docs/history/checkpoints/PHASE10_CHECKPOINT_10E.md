# Phase 10 Checkpoint 10E - l3build pilot

## Summary

Checkpoint 10E adds an l3build pilot decision record.

The checkpoint evaluates where `l3build` might help the release workflow without
adopting it as an active project-wide test system. It does not add a root
`build.lua`, `.lvt` fixtures, `.tlg` reference logs, a release tag, a version
bump, generated assets, or a new CI requirement.

Phase 10E adds:

```text
docs/L3BUILD_PILOT.md
tests/run_phase10e_l3build_pilot.ps1
PHASE10_CHECKPOINT_10E.md
```

It also links the pilot from the README and local release checklist.

## Conservative Decision

The existing PowerShell runners remain the source of truth for the current
project checks.

`l3build` is not required for releases yet because:

* it is not visible on PATH in this Codex shell;
* stable `.tlg` references have not been proven on Windows or GitHub Actions;
* the starter PDF suite is already covered by existing runners; and
* collaborators should not inherit a new mandatory tool before it proves value.

## Candidate Future Use

If adopted later, `l3build` should begin as a tiny proof under:

```text
tests/l3build-proof/
```

That proof should cover one stable package/class smoke test first. It should not
start by absorbing full starter PDF builds, timing measurements, release assets,
or visual review.

## Verification

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase10e_l3build_pilot.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase10d_release_asset_manifest.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase10c_local_release_checklist.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase9c_build_recipe_reliability.ps1
```

The runner writes ignored reports under:

```text
build/phase10e-l3build-pilot/
```

Expected result in this Codex shell:

```text
All Phase 10E l3build pilot checks passed with 1 warning(s) and 1 note(s).
```

The warning records that `l3build` is not visible on PATH in this shell. That is
not a failure for 10E because the checkpoint is an evaluation boundary, not an
adoption step.

The guard checks 10 required files and 18 required markers.

## Hosted Starter CI Follow-up

During the protected-branch pull-request trial, GitHub Actions failed while
building `examples/studentnotes/starter_notes.tex` because hosted MiKTeX could
not find `amsthm.sty`.

The workflow now installs MiKTeX package `amscls` explicitly. `amscls` provides
`amsthm.sty`, so the starter job does not depend on hosted auto-install finding
that package during the build.

The committed-state cross-checks also passed:

* Phase 10D release-asset manifest: 0 warnings and 0 failures;
* Phase 10C local release checklist: 0 warnings and 0 failures;
* Phase 9C build-recipe reliability: 28 of 28 PowerShell runners parsed, with 0
  findings and 0 failures.

## Decision

Phase 10E keeps `l3build` as a deliberate future option. The next Phase 10
checkpoint can either create a tiny inactive proof fixture after normal MiKTeX
availability is confirmed, or plan broader CI release-gate coverage.
