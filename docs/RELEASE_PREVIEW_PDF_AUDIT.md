# Release Preview PDF Audit

## Purpose

This audit records the first local release-preview PDF set. Preview PDFs help a
collaborator inspect starter output before building locally, but they remain
release assets rather than source files.

## Source State

Source commit:

```text
f51d198
```

Build command:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

The starter runner passed.

## Local Artifact Folder

Prepared PDFs:

```text
build/release-preview/2026-08-13/
```

The folder is ignored by Git and should not be committed.

## Prepared PDFs

| File | Pages | Bytes | SHA256 |
| --- | ---: | ---: | --- |
| `latex-lab-starter-combined-workbook-2026-08-13.pdf` | 2 | 110512 | `e8727a9946e54e1fd49466b956971fe643006c5c01a685234df60ac47935b61f` |
| `latex-lab-starter-engineering-notes-2026-08-13.pdf` | 2 | 76673 | `f3f22dff8c9e4256246f3f2014bd6508f0497692f1f8a8ea778ffdf3b577877e` |
| `latex-lab-starter-quiz-bank-2026-08-13.pdf` | 2 | 165700 | `739b61fc179a49dc0b190f671c267a9ab265b80c64dde773d0370c6c8225d8df` |
| `latex-lab-starter-science-notes-2026-08-13.pdf` | 2 | 92928 | `f472f53fb4954c4671b826411021c1a6b2e9c67e8c0d58e38ff0e57c3a22ad33` |
| `latex-lab-starter-student-notes-2026-08-13.pdf` | 2 | 138128 | `80ad528c955c74f91b37ffdba51a952f6ba2d811f6919a84167771a3d873b225` |
| `latex-lab-starter-versioned-quiz-2026-08-13.pdf` | 4 | 183141 | `8f426b1062c2357e05c0f45e857b47603bba66fff854e29064f33132bd7bbffc` |
| `latex-lab-starter-workbook-module-2026-08-13.pdf` | 2 | 95311 | `40e72d82361c9ccadaff23e902668a4fdb649af4933f8aafdd405db1aefedf1f` |

## Automated Structural Review

Confirmed:

* all seven PDFs exist;
* each PDF has at least one page;
* each first page has extractable text; and
* SHA256 hashes were recorded.

## Manual Visual Review

Before attaching these PDFs to a GitHub release, manually open each PDF and
check:

* the first page identifies the starter;
* pages are not blank;
* text is not visibly overlapping;
* tables, boxes, and formulas fit the page;
* the versioned quiz answer key and solutions match the rendered paper; and
* the workbook module and combined workbook both render as intended.

Do not patch generated PDFs directly. If visual review fails, fix the source
starter and regenerate the preview set.
