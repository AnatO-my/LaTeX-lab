# Phase 3 Checkpoint 3E — Documentation and Completion

## Scope

This checkpoint closes Phase 3 after the repository-local Phase 3D test runner
has passed. It updates the public-interface reference, changelog, and project
state. It makes no further production-code or test changes.

Phase 3 established the rendering and output-selection boundary for a future
question-bank system. It did not create question records, collect answers,
calculate totals, shuffle questions, select questions by version, or migrate the
representative 60-question quiz. Those decisions remain Phase 4 work.

## Files to integrate

Copy these files to the matching repository locations:

```text
docs/PUBLIC_INTERFACES.md
CHANGELOG.md
PROJECT_STATE.md
```

`PHASE3_CHECKPOINT_3E.md` is a review and integration guide. It need not be
committed.

## Final verification

From the repository root, run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_physicsquiz_phase3d_tests.ps1
latexmk -pdf -g "examples/physicsquiz/PHY104_Exam revision.tex"
latexmk -pdf -g tests/physicsquiz_choices_compatibility.tex
git diff --check
git status --short
```

Accept Phase 3 only when:

- all 21 positive Phase 3D drivers compile without LaTeX warnings or box
  diagnostics;
- both deliberate conflict tests fail with their intended class errors;
- all ten semantic colour/print matrices pass;
- the Phase 2 choices compatibility document remains correct;
- the representative quiz retains the accepted 23-page default rendering, with
  Question 60 and all five choices together;
- generated PDFs, logs, and auxiliary files remain outside the source-focused
  commit; and
- `examples/studentnotes/Optics.tex` remains modified but unstaged and absent
  from the Phase 3 diff.

## Selective staging

Do not use `git add .`. Stage the reviewed Phase 3 source, tests, and governance
files explicitly. The two earlier checkpoint guides are local review notes and
need not be committed.

```powershell
git add -- src/classes/physicsquiz.cls
git add -- docs/PUBLIC_INTERFACES.md CHANGELOG.md PROJECT_STATE.md
git add -- tests/check_physicsquiz_output_modes.py
git add -- tests/physicsquiz_mode_*.tex
git add -- tests/physicsquiz_content_*.tex
git add -- tests/physicsquiz_output_modes_content.tex
git add -- tests/physicsquiz_presentation_*.tex
git add -- tests/physicsquiz_version_*.tex
git add -- tests/run_physicsquiz_phase3d_tests.ps1

git diff --cached --check
git status --short
```

Before committing, confirm that this line is not staged:

```text
 M examples/studentnotes/Optics.tex
```

Suggested commit:

```powershell
git commit -m "Complete Phase 3 assessment output modes"
```

After the commit, run:

```powershell
git status --short
```

The independent `Optics.tex` modification may remain in the working tree.

## Phase 4 boundary

Begin Phase 4 with a read-only comparison of a lightweight custom question
record and `xsim`. Use a small structured proof of concept before any migration
of the representative 60-question quiz. The `otscience` workbook practice bank
is not a `physicsquiz` question-bank precedent.
