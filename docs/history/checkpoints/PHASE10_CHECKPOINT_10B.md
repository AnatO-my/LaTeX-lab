# Phase 10 Checkpoint 10B - Release notes template

## Scope

Checkpoint 10B adds the first release-notes template.

This checkpoint does not create a release, tag a commit, generate release
assets, change CI, or change class/package versions.

## Added

Phase 10B adds:

```text
docs/RELEASE_NOTES_TEMPLATE.md
tests/run_phase10b_release_notes_template.ps1
```

## Template Boundary

The template requires future releases to record:

* release label, date, branch, commit, and release type;
* author-facing summary and highlights;
* public-interface changes or an explicit no-change statement;
* exact checks that passed;
* release assets or an explicit no-asset statement;
* upgrade notes or an explicit no-action statement; and
* links to the versioning policy, public interfaces, release readiness, release
  PDF checklist, and author-kit checklist.

## Verification

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase10b_release_notes_template.ps1
```

The runner writes ignored reports under:

```text
build/phase10b-release-notes-template/
```

Result:

```text
All Phase 10B release notes template checks passed with 1 note(s).
```

The first report checked 10 required template sections and 14 required markers,
with 0 warnings and 0 failures.

The Phase 9C reliability guard was rerun after adding the 10B runner:

```text
PowerShell runners parsed: 25 / 25
findings: 0
failures: 0
```

## Preserved

Checkpoint 10B changes no author-facing LaTeX behavior.

Generated PDFs, author kits, preview zips, and release notes remain deliberate
release assets or records, not ordinary generated source files.

## Carried Forward

The next Phase 10 checkpoint can add a local release checklist runner or begin a
minimal `l3build` evaluation.
