# Phase 10 Checkpoint 10C - Local release checklist

## Scope

Checkpoint 10C adds a local release checklist.

This checkpoint does not create a release, tag a commit, generate release
assets, broaden CI, add `l3build`, or change class/package versions.

## Added

Phase 10C adds:

```text
docs/LOCAL_RELEASE_CHECKLIST.md
tests/run_phase10c_local_release_checklist.ps1
```

## Checklist Boundary

The checklist records the source-first release gate:

* run `git diff --check`;
* review `git status --short --branch`;
* draft notes from `docs/RELEASE_NOTES_TEMPLATE.md`;
* choose labels from `docs/VERSIONING_RELEASE_POLICY.md`;
* keep public-interface changes recorded in `docs/PUBLIC_INTERFACES.md`;
* keep generated assets out of ordinary source commits; and
* run the starter build check in a normal MiKTeX PowerShell environment before a
  real release.

## Verification

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase10c_local_release_checklist.ps1
```

The runner writes ignored reports under:

```text
build/phase10c-local-release-checklist/
```

Result after committing the 10C source changes:

```text
All Phase 10C local release checklist checks passed with 0 warning(s) and 2 note(s).
```

The final report confirmed that only known local-only files were visible in
ordinary status.

The final report checked 11 required files and 10 required markers, with 0
failures.

The Phase 9C reliability guard was rerun after adding the 10C runner:

```text
PowerShell runners parsed: 26 / 26
findings: 0
failures: 0
```

## Preserved

Checkpoint 10C changes no author-facing LaTeX behavior.

The checklist prepares a release gate but does not choose a release source
commit, create a release, or require generated release assets.

## Carried Forward

The next Phase 10 checkpoint can evaluate a minimal `l3build` proof or begin
broader CI planning.
