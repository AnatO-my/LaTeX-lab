# Phase-Specific Starter Prompts

Use these only when beginning a new chat at a phase boundary. Attach the files listed in `FILE_CHECKLIST.md` and the latest `PROJECT_STATE.md`.

---

## Phase 0: Baseline Audit

Continue the LaTeX Workspace Learning and Class Refactoring Project from the attached `PROJECT_STATE.md`.

Work on Phase 0 only: baseline audit and safety. Inspect every attached source file before responding. Do not modify code yet. Produce the source-tree inventory, public-interface inventory, dependency audit, missing-file list, risk-ranked issues, baseline folder structure, and first local verification task.

---

## Phase 1: LaTeX Workshop Workflow

Continue the project from the attached `PROJECT_STATE.md`.

Teach and implement Phase 1 only: LaTeX Workshop as a serious local IDE with MiKTeX and latexmk. Inspect my current `.vscode/settings.json`, any `.latexmkrc`, representative root and child `.tex` files, and relevant logs. Preserve my working setup. Make one small change at a time and give an exact local test after each change.

---

## Phase 2: Semantic Interfaces

Continue the project from the attached `PROJECT_STATE.md`.

Work on Phase 2 only. Audit and improve the public interfaces in `studentnotes.cls` and `physicsquiz.cls`, especially the rigid `\choices` command and the `namedformula` environment. Explain semantic interface design, preserve compatibility where practical, and provide minimal tests before changing production documents.

---

## Phase 3: Multiple Assessment Outputs

Continue the project from the attached `PROJECT_STATE.md`.

Work on Phase 3 only. Upgrade `physicsquiz.cls` so one question source can generate student, teacher, solution, answer-key, colour, print, and versioned outputs. Teach class options and conditionals before implementation. Preserve the existing appearance as the default mode.

---

## Phase 4: Question Bank

Continue the project from the attached `PROJECT_STATE.md`.

Work on Phase 4 only. Using my real question files, compare a lightweight custom question-bank architecture with `xsim` or another suitable established solution. Recommend one based on maintainability and my needs. Do not migrate the full bank until a small proof-of-concept compiles successfully.

---

## Phase 5: Shared OT Packages

Continue the project from the attached `PROJECT_STATE.md`.

Work on Phase 5 only. Audit duplicated code across all attached classes and styles. Propose a minimal shared-package architecture. Move one coherent concern at a time, keep classes compilable, and maintain compatibility.

---

## Phase 6: Modern LaTeX Programming

Continue the project from the attached `PROJECT_STATE.md`.

Work on Phase 6 only. Teach `\NewDocumentCommand`, keys, and selected `expl3` concepts through small examples, then apply them only where they improve the existing public interface, validation, or maintainability. Do not perform a wholesale rewrite.

---

## Phase 7: Modular Documents

Continue the project from the attached `PROJECT_STATE.md`.

Work on Phase 7 only. Inspect the complete workbook source tree, including its class, shared setup, all input modules, figures, and compiled PDFs. Compare `\input`, `\include`, and `subfiles` against the actual requirements. Preserve both combined and standalone compilation.

---

## Phase 8: Publishing Ecosystem

Continue the project from the attached `PROJECT_STATE.md`.

Work on Phase 8 only. Introduce one publishing tool at a time through a minimal example, then decide whether it belongs in a class, a package, or an individual document. Prioritise tools that directly support my physics, electronics, programming, research, and teaching work.

---

## Phase 9: Automation and Performance

Continue the project from the attached `PROJECT_STATE.md`.

Work on Phase 9 only. Audit build time, generated files, TikZ usage, the dot-grid background, and build recipes. Establish measurements before optimisation. Implement only changes that produce clear reliability, speed, or reproducibility gains.

---

## Phase 10: Testing and Releases

Continue the project from the attached `PROJECT_STATE.md`.

Work on Phase 10 only. Treat my classes as maintained software. Establish documentation, test documents, change logs, versioning, Git practices, and a small `l3build` regression suite. Teach each tool while implementing it.
