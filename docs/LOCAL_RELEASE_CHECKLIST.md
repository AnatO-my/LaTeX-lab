# Local Release Checklist

Use this checklist before tagging a release or drafting GitHub release notes.

This checklist is intentionally source-first. It confirms that the repository is
ready to choose a release source state before any generated assets are attached.

## Required Source State

Before a release source commit is chosen:

* `git diff --check` must pass;
* `git status --short --branch` should show only intentional source changes and
  known local-only files;
* release notes should be drafted from `docs/RELEASE_NOTES_TEMPLATE.md`;
* the version label should follow `docs/VERSIONING_RELEASE_POLICY.md`;
* public-interface changes should be recorded in `docs/PUBLIC_INTERFACES.md`;
* generated PDFs, author kits, preview zips, logs, and `build/` outputs should
  stay out of ordinary source commits; and
* the release source should be a committed state, not unstaged local edits.

## Required Local Checks

Run the source-level release checks:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase10a_release_policy.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase10b_release_notes_template.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase10c_local_release_checklist.ps1
```

Run the starter build check in a normal MiKTeX PowerShell environment before a
real release:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

## Optional Release Assets

Use these only when a release needs assets:

* `docs/RELEASE_PDF_CHECKLIST.md` for preview PDFs;
* `docs/AUTHOR_KIT_BUILD_CHECKLIST.md` for an author-kit zip; and
* `docs/RELEASE_NOTES_TEMPLATE.md` to record asset names and hashes.

Generated assets should be attached to a GitHub release or recorded locally.
They should not be committed as ordinary source files.

## Not Yet Required

These remain later Phase 10 decisions:

* broader GitHub Actions workflows;
* `l3build`;
* class/package version bumps;
* publishing a release tag; and
* making generated assets mandatory for every release.
