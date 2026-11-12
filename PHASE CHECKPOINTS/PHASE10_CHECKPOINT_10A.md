# Phase 10 Checkpoint 10A - Versioning and release policy

## Scope

Checkpoint 10A opens Phase 10: testing and releases.

This checkpoint treats the project as maintained software, but it does not bump
class versions, create tags, create release assets, add `l3build`, or broaden
GitHub Actions yet.

## Added

Phase 10A adds:

```text
docs/VERSIONING_RELEASE_POLICY.md
tests/run_phase10a_release_policy.ps1
```

## Policy Boundary

The new policy records:

* repository release labels such as `v0.1.0`;
* patch, minor, and major meanings for this project;
* the rule that generated PDFs, author kits, and preview zips remain release
  assets rather than ordinary source;
* the current mixed class/package version state; and
* the public-interface update checklist for future version changes.

## Verification

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase10a_release_policy.ps1
```

The runner writes ignored reports under:

```text
build/phase10a-release-policy/
```

Result:

```text
All Phase 10A release policy checks passed with 1 note(s).
```

The first inventory found 15 real `\ProvidesClass`/`\ProvidesPackage`
declarations. Four include semantic version text.

The Phase 9C reliability guard was rerun after adding the 10A runner:

```text
PowerShell runners parsed: 24 / 24
findings: 0
failures: 0
```

## Preserved

Checkpoint 10A changes no class or package behavior.

The existing `\ProvidesClass`, `\ProvidesPackage`, and public capability marker
values remain unchanged.

## Carried Forward

The next Phase 10 checkpoint can choose one of three small moves:

* add a release-note template;
* add a local release checklist runner; or
* evaluate a minimal `l3build` proof without adopting it wholesale.
