# Phase 3 Checkpoint 3C — Semantic Output Gates

## Scope

This checkpoint adds five semantic environments that conditionally render
complete assessment sections:

- `quizquestioncontent`;
- `quizanswerkeycontent`;
- `quizsolutioncontent`;
- `quizteachercontent`; and
- `quizreferencecontent`.

The gates use the derived content state introduced in Checkpoint 3B. They do
not store questions, collect answers, generate an answer key, select content,
or define question-bank records.

## Agreed rendering matrix

| Primary mode | Questions | Answer key | Solutions | Teacher notes | References |
| --- | ---: | ---: | ---: | ---: | ---: |
| default / `full` | yes | yes | yes | no | yes |
| `student` | yes | no | no | no | yes |
| `teacher` | yes | yes | no | yes | yes |
| `solutions` | no | no | yes | no | yes |
| `answerkey` | no | yes | no | no | no |

Reference material is included in the solutions booklet so that worked
solutions remain usable as a self-contained study document. This policy can be
changed later by altering only the derived `reference` state.

## Shared synthetic assessment

`tests/physicsquiz_output_modes_content.tex` is one small assessment body used
by all five content drivers. It includes:

- one legacy five-option `\choices` question;
- one flexible four-option `choiceoptions` question;
- a manual compact answer key;
- a worked-solution block;
- teacher-only guidance; and
- reference material.

Each gated section emits a unique `PQ-CONTENT:<name>` log marker. The Python
checker compares the markers actually executed in each build with the matrix
above. This verifies the output structure while avoiding premature
question-bank design.

## Files for the repository

Copy the checkpoint tree into the matching repository locations. It includes
the 3B class/tests plus these new or amended 3C files:

```text
src/classes/physicsquiz.cls
tests/physicsquiz_output_modes_content.tex
tests/physicsquiz_content_default.tex
tests/physicsquiz_content_student.tex
tests/physicsquiz_content_teacher.tex
tests/physicsquiz_content_solutions.tex
tests/physicsquiz_content_answerkey.tex
tests/check_physicsquiz_output_modes.py
```

Do not copy generated PDFs, logs, auxiliary files, or local build directories.

## Required repository-local verification

1. Confirm the independent modification is still the only unrelated change:

   ```text
    M examples/studentnotes/Optics.tex
   ```

2. Integrate the checkpoint files without touching or staging `Optics.tex`.
3. Build the five 3B positive state tests and confirm the conflict test fails
   with the expected class error.
4. Build the five new content drivers through the repository `.latexmkrc`.
5. Run the marker checker against the directory containing their logs, for
   example:

   ```text
   python tests/check_physicsquiz_output_modes.py build/tests
   ```

6. Visually inspect the five content-driver PDFs. Each must agree with the
   rendering matrix.
7. Re-run `tests/physicsquiz_choices_compatibility.tex` unchanged.
8. Rebuild `examples/physicsquiz/PHY104_Exam revision.tex` in the default mode.
9. Confirm the representative 23-page output retains its accepted appearance,
   including Question 60 and all choices together in the right column.
10. Confirm `examples/studentnotes/Optics.tex` remains unstaged and unchanged by
    the checkpoint.

## Acceptance baseline received

The supplied representative source is identical to the earlier canonical
source after line-ending normalisation. The fresh MiKTeX PDF was created on
5 August 2026, contains 23 pages rather than the earlier 24, and resolves the
Question 60 split. The supplied compilation transcript belongs to
`physicsquiz_mode_teacher.tex`; it contains no warnings or errors.

## Deferred work

Checkpoint 3C does not add print styling, version metadata, marks, difficulty
labels, automatic answer generation, or a structured question bank. Those
remain later Phase 3/Phase 4 work. The representative 60-question quiz is not
migrated in this checkpoint.

## Next checkpoint

After repository-local review, Checkpoint 3D can add the independent
`colour`/`print` presentation axis, version metadata, and optional display-only
marks/difficulty hooks.
