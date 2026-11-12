# Phase 3 Checkpoint 3B — Primary Output-Mode State

## Scope

This checkpoint adds the state layer for five mutually exclusive primary
assessment outputs:

- `full` — the existing complete output and the default;
- `student` — question content only;
- `teacher` — questions, compact answers, and teacher-only content;
- `solutions` — worked solutions only; and
- `answerkey` — the compact answer key only.

It deliberately does not yet add semantic content-gating environments, print
styling, version metadata, marks, difficulty labels, automatic answer
collection, or question-bank records.

## Architectural boundary

The class now separates three responsibilities:

1. class options select one primary mode;
2. internal mode booleans record that selection; and
3. derived content booleans state whether questions, the compact answer key,
   worked solutions, or teacher-only material should be rendered.

Checkpoint 3C can therefore implement semantic content environments against
the derived booleans without testing option names throughout the class.

## Files for the repository

Copy these files into the matching repository locations:

```text
src/classes/physicsquiz.cls
tests/physicsquiz_mode_default.tex
tests/physicsquiz_mode_student.tex
tests/physicsquiz_mode_teacher.tex
tests/physicsquiz_mode_solutions.tex
tests/physicsquiz_mode_answerkey.tex
tests/physicsquiz_mode_conflict.tex
```

Do not copy generated PDFs, logs, auxiliary files, or the local `build/`
directory.

## Assertions covered

- no primary option selects `full`;
- each explicit primary option selects the expected state;
- the five primary options are mutually exclusive;
- conflicting modes produce a descriptive class error;
- `student` shows questions and hides answers, solutions, and teacher content;
- `teacher` shows questions, compact answers, and teacher content but hides the
  solutions booklet;
- `solutions` selects worked solutions only;
- `answerkey` selects the compact answer key only;
- `12pt,a4paper` still passes through to `article`; and
- the existing Phase 2 choices compatibility output remains visually
  unchanged in the default mode.

## Verification completed in the review workspace

The five positive state tests compiled successfully. The conflict test failed
with:

```text
Class physicsquiz Error: Conflicting primary output modes.
```

The unchanged `physicsquiz_choices_compatibility.tex` was built against the
Phase 2 class and this amended class. Both rendered pages had identical pixel
hashes.

The review container did not include `siunitx`, so the state-only test run used
a temporary local shim for the class's `\sisetup` call. That shim is not part of
this checkpoint. Re-run the tests with the real `siunitx` package in the
canonical MiKTeX repository environment.

## Required local verification before committing

1. Confirm the pre-test working tree still shows only the independent change:

   ```text
    M examples/studentnotes/Optics.tex
   ```

2. Copy the checkpoint files into the repository.
3. Build the five positive tests through the repository `.latexmkrc`.
4. Run the conflict test and confirm that failure is expected and contains the
   descriptive class error.
5. Re-run `tests/physicsquiz_choices_compatibility.tex` unchanged.
6. Rebuild `examples/physicsquiz/PHY104_Exam revision.tex` in the default mode.
7. Confirm the representative document retains its established appearance and
   that Question 60 has the accepted Phase 2 pagination.
8. Confirm `examples/studentnotes/Optics.tex` is still unstaged and unchanged by
   the checkpoint.

Do not update `PROJECT_STATE.md`, `CHANGELOG.md`, or create a Git checkpoint
until these repository-local checks have passed and the 3B diff has been
reviewed.

## Next checkpoint

Checkpoint 3C should add semantic content-gating environments and one shared
synthetic assessment fixture. Separate mode drivers will compile that same
fixture and verify the actual presence or absence of questions, answers,
solutions, teacher notes, and reference material. This is still an output-mode
test; a structured miniature question bank remains a Phase 4 proof of concept.
