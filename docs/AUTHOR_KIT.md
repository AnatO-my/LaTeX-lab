# Author Kit

What the author kit contains, how to build and check it, and the original 2026-08-13 audit. It merges three earlier documents.

## Contents

* [Author Kit Manifest](#author-kit-manifest) (was `#author-kit-manifest`)
* [Author Kit Build Checklist](#author-kit-build-checklist) (was `#author-kit-build-checklist`)
* [Author Kit Audit](#author-kit-audit) (was `#author-kit-audit`)

## Author Kit Manifest

### Purpose

This manifest lists the files that belong in a source-derived author kit. It is
a packaging boundary, not a second copy of the project.

Use `#author-kit-build-checklist` for the step-by-step process of
assembling, verifying, and sharing the kit. Use
`scripts/new-author-kit.ps1` to create the standard kit under
`build/author-kit/`.

### Required Files

| Area | Include |
| --- | --- |
| Repository overview | `README.md` |
| Contribution guide | `CONTRIBUTING.md` |
| Local build configuration | `.latexmkrc` |
| Author workflow | `docs/AUTHOR_WORKFLOW.md` |
| Starter inventory | `docs/STARTER_INVENTORY.md` |
| Public interface record | `docs/PUBLIC_INTERFACES.md` |
| Classes | `src/classes/` |
| Packages | `src/packages/` |
| Physics quiz bank starter | `examples/physicsquiz/starter_quiz_bank.tex` |
| Versioned quiz starter | `examples/physicsquiz/starter_versioned_quiz.tex` |
| Student notes starter | `examples/studentnotes/starter_notes.tex` |
| Engineering notes starter | `examples/otengineering/starter_engineering_notes.tex` |
| Science notes starter | `examples/otscience/starter_science_notes.tex` |
| Personal book starter | `examples/otbook/starter_personal_book.tex` |
| Copyable book project | `templates/otbook-project/` (source only, including dotfiles) |
| Workbook module starter | `examples/vector-workbook/starter_module.tex` |
| Combined workbook starter | `examples/vector-workbook/starter_combined_workbook.tex` |
| Workbook shared setup | `examples/vector-workbook/00_common_setup.tex` |
| Starter verification | `tests/run_starter_tests.ps1` and `tests/run_otbook_tests.ps1` |
| Book smoke document | `tests/otbook_class_smoke.tex` |
| Log retry helper | `tests/powershell_log_helpers.ps1` |

The required class tree includes `src/classes/otbook.cls`. Include the complete
package tree so its conditional OT companion commands are available. The kit
contains eight starters; the Phase 7 runner verifies the original seven and
the otbook runner verifies the book workflow.

### Optional Reference Examples

These are helpful but can make an author kit feel less lightweight:

| Area | Optional file |
| --- | --- |
| Full PHY104 structured paper | `examples/physicsquiz/PHY104_structured_revision.tex` |
| Full PHY104 versioned paper | `examples/physicsquiz/PHY104_versioned_paper.tex` |
| Student notes example | `examples/studentnotes/Optics.tex` |
| Engineering notes example | `examples/otengineering/test.tex` |
| Full vector workbook | `examples/vector-workbook/00_main_combined_workbook.tex` |

### Excluded Files

Exclude generated or local-only files:

* `build/`;
* `tests/__pycache__/`;
* `examples/physicsquiz/indent.log`;
* ordinary `.aux`, `.log`, `.fls`, `.fdb_latexmk`, `.out`, `.toc`, and
  `.synctex.gz` files; and
* local instruction files that are not meant for collaborators.

### Verification

After creating an author kit from the manifest, run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_starter_tests.ps1
powershell -ExecutionPolicy Bypass -File tests\run_otbook_tests.ps1
```

The kit is usable when both runners pass. The otbook runner verifies the book
starter, smoke document, and project template; do not include the generated
template `build/` directory when packaging the kit.
The historical kit in `#author-kit-audit` predates `otbook`; updating this
manifest does not rebuild that archive.

## Author Kit Build Checklist

### Purpose

This checklist describes how to produce a source-derived author kit from
`#author-kit-manifest`. It is a generated release asset, not a second
copy of the project.

### 1. Decide the Kit Shape

Before building a kit, decide:

* whether it is for one collaborator, a private release, or a public release;
* whether optional reference examples should be included;
* whether preview PDFs will be attached separately; and
* what version or date label should identify the kit.

Use `docs/release/RELEASE_PROCESS.md#release-pdf-checklist` if preview PDFs will be attached separately.

Recommended first kit name:

```text
latex-lab-author-kit-YYYY-MM-DD
```

### 2. Start From a Clean Source Commit

From the repository root:

```powershell
git status --short --branch
git diff --check
powershell -ExecutionPolicy Bypass -File tests\run_starter_tests.ps1
powershell -ExecutionPolicy Bypass -File tests\run_otbook_tests.ps1
```

Only build a kit from a committed source state. Do not include local-only files
such as `AGENTS.md`, `examples/physicsquiz/indent.log`, `tests/__pycache__/`, or
line-ending-only working-tree noise.

### 3. Create the Kit

Run the generator from the repository root. It writes the kit under ignored
`build/author-kit/`, copies only manifest-approved source files, and refuses a
dirty working tree by default:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\new-author-kit.ps1
```

For an explicitly local, uncommitted snapshot, add `-AllowDirty`. To create a
zip alongside the kit, add `-Zip`. The generator never overwrites an existing
kit folder; choose a distinct `-Name` when needed.

### 4. Inspect Required Files

Copy only the required files listed in `#author-kit-manifest`:

* repository overview and author guides;
* `.latexmkrc`;
* `src/classes/`;
* `src/packages/`;
* the eight starter documents, including `examples/otbook/starter_personal_book.tex`;
* `templates/otbook-project/`, including dotfiles but excluding `build/`;
* `examples/vector-workbook/00_common_setup.tex`;
* `tests/run_starter_tests.ps1` and `tests/run_otbook_tests.ps1`;
* `tests/otbook_class_smoke.tex`; and
* `tests/powershell_log_helpers.ps1`.

If optional reference examples are included, keep them in their original
relative folders so paths remain predictable.

### 5. Exclude Generated Files

Before zipping or sharing, confirm the kit does not contain:

* `build/`;
* `.git/`;
* `tests/__pycache__/`;
* `examples/physicsquiz/indent.log`;
* `.aux`, `.log`, `.fls`, `.fdb_latexmk`, `.out`, `.toc`, or `.synctex.gz`
  files; or
* local instruction files that are not meant for collaborators.

### 6. Verify the Kit

Open a shell from the kit root and run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_starter_tests.ps1
powershell -ExecutionPolicy Bypass -File tests\run_otbook_tests.ps1
```

The Phase 7 runner covers the original seven starters. The otbook runner
builds the book starter, smoke document, and project template. Include
`otbook.cls` with the other classes and the complete OT package tree; no
standalone copy of the book class is sufficient.

Require exit status zero and `templates/otbook-project/build/pdf/main.pdf`.
Exclude this nested `build/` folder as well when packaging the kit.

### 7. Package the Kit

After verification, remove kit-local generated `build/` outputs, then zip the
kit folder. Or run the generator initially with `-Zip`, which creates the zip
beside the kit under ignored `build/author-kit/`.

Recommended zip name:

```text
latex-lab-author-kit-YYYY-MM-DD.zip
```

### 8. Attach or Share

For private collaborators, share the repository first and use the kit only if
they need a source snapshot without Git history.

For a GitHub release, attach the zip as a release asset. Do not commit it as an
ordinary source file.

### 9. Record the Source

When a kit is shared, record:

* commit hash used to build it;
* date built;
* whether optional examples were included;
* whether preview PDFs were attached separately; and
* verification command result.

Checkpoint 8H records the first source-derived kit in `#author-kit-audit`.

## Author Kit Audit

### Purpose

This audit records the first source-derived author kit. The kit is a release
asset, not a maintained second copy of the repository.

### Source State

Source commit:

```text
de87e4b
```

Manifest:

```text
#author-kit-manifest
```

### Local Artifact Paths

Kit folder:

```text
build/author-kit/latex-lab-author-kit-2026-08-13/
```

Zip:

```text
build/author-kit/latex-lab-author-kit-2026-08-13.zip
```

Both paths are under ignored `build/`.

### Zip

| File | Bytes | SHA256 |
| --- | ---: | --- |
| `latex-lab-author-kit-2026-08-13.zip` | 56899 | `093855b8fbfd9fd2313cd49f674e5c00ffb26bc3faa6f0b499b6d6f16219fe60` |

### Included Files

The kit includes:

* `README.md`;
* `CONTRIBUTING.md`;
* `.latexmkrc`;
* `docs/AUTHOR_WORKFLOW.md`;
* `docs/STARTER_INVENTORY.md`;
* `docs/PUBLIC_INTERFACES.md`;
* `src/classes/`;
* `src/packages/`;
* `examples/physicsquiz/starter_quiz_bank.tex`;
* `examples/physicsquiz/starter_versioned_quiz.tex`;
* `examples/studentnotes/starter_notes.tex`;
* `examples/otengineering/starter_engineering_notes.tex`;
* `examples/otscience/starter_science_notes.tex`;
* `examples/vector-workbook/starter_module.tex`;
* `examples/vector-workbook/starter_combined_workbook.tex`;
* `examples/vector-workbook/00_common_setup.tex`;
* `tests/run_starter_tests.ps1`; and
* `tests/powershell_log_helpers.ps1`.

Optional reference examples were not included.

### Verification

The kit was verified from the kit root with:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_starter_tests.ps1
```

The starter runner passed.

Before zipping, kit-local generated `build/` outputs were removed.

The final kit folder and zip were scanned and do not contain:

* `build/`;
* `.git/`;
* `tests/__pycache__/`;
* `examples/physicsquiz/indent.log`; or
* `AGENTS.md`.
