# Release Notes Template

Use this template when drafting a GitHub release or local release record.

Do not publish release notes from unstaged edits or generated files that are not
attached intentionally as release assets.

## Release

```text
Label: v0.1.0
Date: YYYY-MM-DD
Source branch:
Source commit:
Release type: patch | minor | major
```

## Summary

Write one short paragraph describing what changed for an author or collaborator.

## Highlights

* First highlight.
* Second highlight.
* Third highlight.

## Public Interface Changes

Use this section for commands, environments, class options, package options,
document workflows, or visible behavior changes.

| Area | Change | Compatibility |
| --- | --- | --- |
|  |  | compatible |

If there are no public-interface changes, write:

```text
No public-interface changes.
```

## Verification

Record the exact checks that passed.

| Check | Result |
| --- | --- |
| `git diff --check` |  |
| starter documents |  |
| release policy guard |  |

Add full regression, PDF preview, author-kit, or hosted CI checks only when they
were actually run.

## Release Assets

Generated PDFs, author kits, and preview zips are release assets. They are not
ordinary source files.

| Asset | Source | SHA256 or note |
| --- | --- | --- |
|  |  |  |

If there are no assets, write:

```text
No release assets.
```

## Upgrade Notes

Describe what an existing author must do after updating.

If no action is needed, write:

```text
No author action required.
```

## Known Limitations

Record known limitations, deferred work, or environment notes.

## Links

* Versioning policy: `docs/VERSIONING_RELEASE_POLICY.md`
* Public interfaces: `docs/PUBLIC_INTERFACES.md`
* Release readiness: `docs/RELEASE_READINESS.md`
* Release PDFs: `docs/RELEASE_PDF_CHECKLIST.md`
* Author kit: `docs/AUTHOR_KIT_BUILD_CHECKLIST.md`
