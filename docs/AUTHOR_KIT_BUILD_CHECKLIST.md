# Author Kit Build Checklist

## Purpose

This checklist describes how to produce a source-derived author kit from
`docs/AUTHOR_KIT_MANIFEST.md`. It is a generated release asset, not a second
copy of the project.

## 1. Decide the Kit Shape

Before building a kit, decide:

* whether it is for one collaborator, a private release, or a public release;
* whether optional reference examples should be included;
* whether preview PDFs will be attached separately; and
* what version or date label should identify the kit.

Use `docs/RELEASE_PDF_CHECKLIST.md` if preview PDFs will be attached separately.

Recommended first kit name:

```text
latex-lab-author-kit-YYYY-MM-DD
```

## 2. Start From a Clean Source Commit

From the repository root:

```powershell
git status --short --branch
git diff --check
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
powershell -ExecutionPolicy Bypass -File tests\run_otbook_tests.ps1
```

Only build a kit from a committed source state. Do not include local-only files
such as `AGENTS.md`, `examples/physicsquiz/indent.log`, `tests/__pycache__/`, or
line-ending-only working-tree noise.

## 3. Create the Kit

Run the generator from the repository root. It writes the kit under ignored
`build/author-kit/`, copies only manifest-approved source files, and refuses a
dirty working tree by default:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\new-author-kit.ps1
```

For an explicitly local, uncommitted snapshot, add `-AllowDirty`. To create a
zip alongside the kit, add `-Zip`. The generator never overwrites an existing
kit folder; choose a distinct `-Name` when needed.

## 4. Inspect Required Files

Copy only the required files listed in `docs/AUTHOR_KIT_MANIFEST.md`:

* repository overview and author guides;
* `.latexmkrc`;
* `src/classes/`;
* `src/packages/`;
* the eight starter documents, including `examples/otbook/starter_personal_book.tex`;
* `templates/otbook-project/`, including dotfiles but excluding `build/`;
* `examples/vector-workbook/00_common_setup.tex`;
* `tests/run_phase7c_starter_tests.ps1` and `tests/run_otbook_tests.ps1`;
* `tests/otbook_class_smoke.tex`; and
* `tests/powershell_log_helpers.ps1`.

If optional reference examples are included, keep them in their original
relative folders so paths remain predictable.

## 5. Exclude Generated Files

Before zipping or sharing, confirm the kit does not contain:

* `build/`;
* `.git/`;
* `tests/__pycache__/`;
* `examples/physicsquiz/indent.log`;
* `.aux`, `.log`, `.fls`, `.fdb_latexmk`, `.out`, `.toc`, or `.synctex.gz`
  files; or
* local instruction files that are not meant for collaborators.

## 6. Verify the Kit

Open a shell from the kit root and run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
powershell -ExecutionPolicy Bypass -File tests\run_otbook_tests.ps1
```

The Phase 7 runner covers the original seven starters. The otbook runner
builds the book starter, smoke document, and project template. Include
`otbook.cls` with the other classes and the complete OT package tree; no
standalone copy of the book class is sufficient.

Require exit status zero and `templates/otbook-project/build/pdf/main.pdf`.
Exclude this nested `build/` folder as well when packaging the kit.

## 7. Package the Kit

After verification, remove kit-local generated `build/` outputs, then zip the
kit folder. Or run the generator initially with `-Zip`, which creates the zip
beside the kit under ignored `build/author-kit/`.

Recommended zip name:

```text
latex-lab-author-kit-YYYY-MM-DD.zip
```

## 8. Attach or Share

For private collaborators, share the repository first and use the kit only if
they need a source snapshot without Git history.

For a GitHub release, attach the zip as a release asset. Do not commit it as an
ordinary source file.

## 9. Record the Source

When a kit is shared, record:

* commit hash used to build it;
* date built;
* whether optional examples were included;
* whether preview PDFs were attached separately; and
* verification command result.

Checkpoint 8H records the first source-derived kit in `docs/AUTHOR_KIT_AUDIT.md`.
