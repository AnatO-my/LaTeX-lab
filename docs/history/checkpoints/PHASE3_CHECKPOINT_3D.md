# Phase 3 Checkpoint 3D — Presentation and Metadata

## Scope

This checkpoint adds the independent presentation axis, version metadata, and
optional per-question display hooks promised for Phase 3. It builds on the
validated 3C semantic gates without changing their content-selection matrix.

It does not create question records, calculate marks, collect answers, shuffle
questions, select questions by version, or migrate the representative quiz.

## Public interface added

### Presentation options

`colour` is the default. `color` is an alias. `print` maps the established
public theme names to high-contrast greys and hides hyperlink decoration.

```latex
\documentclass[student,print]{physicsquiz}
```

The presentation option is orthogonal to the primary output mode. Selecting
both `colour`/`color` and `print` produces a descriptive class error.

### Version metadata

```latex
\quizversion{A}
```

When supplied, the class displays `Version A` on `\makequiztitle` and in the
running right header. An empty `\quizversion{}` clears the visible label.
Version metadata does not select, reorder, or shuffle questions.

### Optional question labels

```latex
\item A question stem.\quizmarks{2}\quizdifficulty{Intermediate}
```

The visibility policy is:

| Primary mode | Marks | Difficulty |
| --- | ---: | ---: |
| default / `full` | yes | yes |
| `student` | yes | no |
| `teacher` | yes | yes |
| `solutions` | no | no |
| `answerkey` | no | no |

The labels are display-only. They do not create Phase 4 metadata or calculate a
total. When both labels cannot fit beside a stem, LaTeX may move them to the next
line without producing an overfull box.

## Test matrix

The existing five colour content drivers remain. Five print drivers exercise the
same semantic body, giving ten content/presentation combinations. The marker
checker now verifies marks and difficulty in addition to the five semantic
sections.

Additional tests cover:

- default colour state;
- explicit `colour`;
- the `color` alias;
- explicit `print`;
- conflicting presentation options as an expected failure;
- Version A in teacher/colour output;
- Version B in answer-key/print output; and
- the original conflicting-primary-mode expected failure.

## Repository files

Copy this checkpoint tree into the matching repository locations. In addition
to the 3C files, Checkpoint 3D adds:

```text
tests/physicsquiz_content_default_print.tex
tests/physicsquiz_content_student_print.tex
tests/physicsquiz_content_teacher_print.tex
tests/physicsquiz_content_solutions_print.tex
tests/physicsquiz_content_answerkey_print.tex
tests/physicsquiz_presentation_default.tex
tests/physicsquiz_presentation_colour.tex
tests/physicsquiz_presentation_color_alias.tex
tests/physicsquiz_presentation_print.tex
tests/physicsquiz_presentation_conflict.tex
tests/physicsquiz_version_a.tex
tests/physicsquiz_version_b_print.tex
tests/run_physicsquiz_phase3d_tests.ps1
```

The amended files are:

```text
src/classes/physicsquiz.cls
tests/physicsquiz_output_modes_content.tex
tests/check_physicsquiz_output_modes.py
tests/physicsquiz_mode_default.tex
tests/physicsquiz_mode_student.tex
tests/physicsquiz_mode_teacher.tex
tests/physicsquiz_mode_solutions.tex
tests/physicsquiz_mode_answerkey.tex
```

Do not copy generated PDFs, logs, auxiliary files, or local build directories.

## PowerShell verification

From the repository root, run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_physicsquiz_phase3d_tests.ps1
```

The runner compiles all 21 positive drivers, rejects LaTeX warnings and box
diagnostics, runs the Python marker checker, and confirms both deliberate
conflict tests fail with the intended class errors. The conflict tests can leave
expected LaTeX Workshop diagnostics until a normal test becomes the root file.

Then rebuild and visually inspect:

```text
tests/physicsquiz_choices_compatibility.tex
examples/physicsquiz/PHY104_Exam revision.tex
```

The representative source must remain unchanged and should still produce the
accepted 23-page default output with Question 60 and all five choices together.

## Verification completed in the checkpoint mirror

- All 21 positive drivers compiled.
- All ten semantic colour/print combinations passed the exact marker matrix.
- Positive logs contained no LaTeX warnings, overfull boxes, or underfull boxes.
- Both conflict tests failed with their intended class errors.
- Version A and Version B appeared on the title and running header.
- Colour and print PDFs were visually inspected for alignment and legibility.
- The Phase 2 choices page was pixel-identical under 3C and 3D.
- All 23 pages of the representative default output were pixel-identical under
  3C and 3D using the same local test environment.

The local TeX Live installation required a temporary `siunitx` compatibility
shim. That shim is not included in this checkpoint. Final acceptance remains a
repository-local MiKTeX build with the real `siunitx` package.

## Deferred work

The structured question bank remains Phase 4. Checkpoint 3E should update
`docs/PUBLIC_INTERFACES.md`, `PROJECT_STATE.md`, and `CHANGELOG.md` after the 3D
repository-local verification is accepted, then perform the final Phase 3
integration review and commit while excluding `examples/studentnotes/Optics.tex`.
