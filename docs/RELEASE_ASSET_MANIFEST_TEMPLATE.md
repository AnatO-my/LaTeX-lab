# Release Asset Manifest Template

Use this template when a release needs downloadable PDFs or an author-kit zip.

The manifest is a source record for release assets. It does not create assets by
itself, and it does not make assets mandatory for every release.

## Release Source

* Release label: `vX.Y.Z`
* Source commit: `<commit sha>`
* Release type: `patch | minor | major | preview`
* Build date: `YYYY-MM-DD`
* Built by: `<name or initials>`

Release assets are built from a committed source state. Do not build release
assets from unstaged edits.

## Required Checks Before Assets

```powershell
git status --short --branch
git diff --check
powershell -ExecutionPolicy Bypass -File tests\run_phase10a_release_policy.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase10b_release_notes_template.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase10c_local_release_checklist.ps1
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

Record the result in `docs/RELEASE_NOTES_TEMPLATE.md`.

## Planned Assets

Use `included` only for assets that are actually attached to the release.
Use `omitted` when the release is source-only or the asset was deliberately not
prepared.

| Asset id | Status | Source | Output name | Hash |
| --- | --- | --- | --- | --- |
| starter-pdfs | `included | omitted` | `docs/RELEASE_PDF_CHECKLIST.md` | `latex-lab-starter-pdfs-YYYY-MM-DD.zip` or individual PDFs | `sha256:<hash>` |
| starter-quiz-bank-pdf | `included | omitted` | `examples/physicsquiz/starter_quiz_bank.tex` | `latex-lab-starter-quiz-bank-YYYY-MM-DD.pdf` | `sha256:<hash>` |
| starter-versioned-quiz-pdf | `included | omitted` | `examples/physicsquiz/starter_versioned_quiz.tex` | `latex-lab-starter-versioned-quiz-YYYY-MM-DD.pdf` | `sha256:<hash>` |
| starter-student-notes-pdf | `included | omitted` | `examples/studentnotes/starter_notes.tex` | `latex-lab-starter-student-notes-YYYY-MM-DD.pdf` | `sha256:<hash>` |
| starter-engineering-notes-pdf | `included | omitted` | `examples/otengineering/starter_engineering_notes.tex` | `latex-lab-starter-engineering-notes-YYYY-MM-DD.pdf` | `sha256:<hash>` |
| starter-science-notes-pdf | `included | omitted` | `examples/otscience/starter_science_notes.tex` | `latex-lab-starter-science-notes-YYYY-MM-DD.pdf` | `sha256:<hash>` |
| starter-workbook-module-pdf | `included | omitted` | `examples/vector-workbook/starter_module.tex` | `latex-lab-starter-workbook-module-YYYY-MM-DD.pdf` | `sha256:<hash>` |
| starter-combined-workbook-pdf | `included | omitted` | `examples/vector-workbook/starter_combined_workbook.tex` | `latex-lab-starter-combined-workbook-YYYY-MM-DD.pdf` | `sha256:<hash>` |
| author-kit | `included | omitted` | `docs/AUTHOR_KIT_BUILD_CHECKLIST.md` | `latex-lab-author-kit-YYYY-MM-DD.zip` | `sha256:<hash>` |

## Asset Review

Before an asset is attached to a release:

* confirm each included asset was built from the source commit above;
* confirm generated PDFs are not blank and do not have obvious overlap;
* confirm the author kit, if included, passes the starter build check from its
  own root;
* confirm every included asset has a recorded `sha256` hash; and
* confirm generated PDFs, zips, logs, auxiliaries, and `build/` outputs are not
  committed as ordinary source files.

## Release Notes Link

Release notes should record:

* whether this manifest was used;
* which assets were included or omitted;
* the hash for each included asset;
* the source commit used to build assets; and
* any asset-specific limitation.

No tag, version bump, generated PDF, zip, or GitHub release is created by this
template.

## Related Guides

* `docs/LOCAL_RELEASE_CHECKLIST.md`
* `docs/RELEASE_PDF_CHECKLIST.md`
* `docs/AUTHOR_KIT_BUILD_CHECKLIST.md`
* `docs/RELEASE_NOTES_TEMPLATE.md`
