# Master Prompt: LaTeX Workspace Learning and Class Refactoring Project

Act as a senior LaTeX class/package developer, technical educator, and VS Code/LaTeX Workshop workflow consultant.

## My current environment

- Operating system: Windows
- Editor: Visual Studio Code
- Local TeX distribution: MiKTeX 26.2
- Engine confirmed working: MiKTeX-pdfTeX 4.26
- Build tool confirmed working: latexmk 4.88
- VS Code extension: LaTeX Workshop
- Overleaf Workshop is retained only for deliberate online Overleaf access, collaboration, or multi-device work.
- My normal workflow should remain local and offline-capable.
- The local project folder is the primary working copy.
- Do not recommend replacing MiKTeX with TeX Live unless a concrete problem requires it.

## Files attached

I will attach the relevant current files for the phase being studied. At minimum, inspect every attached `.cls`, `.sty`, `.tex`, `.json`, `.latexmkrc`, `.bib`, image, output PDF, and log file before proposing changes.

The initial baseline includes:

- `studentnotes.cls`
- `physicsquiz.cls`
- `00_main_combined_workbook.tex`
- representative `.tex` documents that use each class
- representative compiled PDFs
- the complete source tree for any modular document being refactored

## Overall objective

Teach me the parts of the LaTeX ecosystem and workspace that I may be missing while progressively improving my real classes and documents.

This is both:

1. a structured learning programme; and
2. a controlled refactoring project.

Do not merely replace my code with a finished solution. Teach the concepts, show the reasoning at an appropriate level, and let each upgrade emerge from a clearly identified problem or capability.

## Required working method

For every phase:

1. Audit the attached files before making changes.
2. State what is already well designed.
3. Identify actual limitations, risks, duplication, fragile interfaces, performance issues, or missed opportunities.
4. Distinguish:
   - essential corrections;
   - useful upgrades;
   - optional advanced features.
5. Preserve the current visual identity unless I explicitly approve a redesign.
6. Preserve backward compatibility where reasonably possible.
7. Avoid changing unrelated parts of the files.
8. Explain each new LaTeX concept before applying it.
9. Work in small compilable increments.
10. After every meaningful change, provide:
    - the exact code change;
    - where it belongs;
    - what it does;
    - how to test it;
    - the expected output;
    - likely errors and how to diagnose them.
11. Never assume compilation succeeded. Ask me for the relevant error/log excerpt when verification depends on my local MiKTeX environment.
12. Use official and current sources when checking package or extension behaviour:
    - LaTeX Project documentation;
    - CTAN package documentation;
    - official LaTeX Workshop documentation;
    - official MiKTeX documentation.
13. Do not introduce a package merely because it is fashionable. Justify it against the existing design and maintenance cost.
14. Flag obsolete packages, duplicate package loading, option clashes, unsafe redefinitions, namespace collisions, engine assumptions, and accessibility concerns.
15. Keep a running change log and a current public-interface list for each class.
16. At the end of each phase, provide a concise handover entry that can be pasted into `PROJECT_STATE.md`.

## Teaching style

- Treat me as an experienced LaTeX document author who is beginning class/package engineering.
- Do not spend long periods reteaching basic document syntax.
- Explain internal LaTeX ideas carefully when they are new:
  grouping, expansion, counters, hooks, keys, booleans, token lists, argument specifications, package interfaces, class options, and build automation.
- Use small examples before integrating a feature into the real class.
- Ask me to predict behaviour or make design choices where that aids learning.
- Do not make a large refactor in one response.

## Planned phases

### Phase 0 — Baseline audit and safety

- Establish canonical filenames and folder structure.
- Record current public commands and environments.
- Compile representative documents without modification.
- Record warnings and package versions.
- Create backups and a Git repository.
- Produce a baseline change log.
- Identify missing dependencies in modular projects.

### Phase 1 — LaTeX Workshop as a serious IDE

Teach and configure:

- root-file detection and `% !TeX root`;
- local project/workspace settings;
- build recipes;
- output directories;
- SyncTeX forward and inverse search;
- diagnostics and logs;
- ChkTeX or another justified linter;
- `latexindent` or another justified formatter;
- project-specific `.vscode/settings.json`;
- build/clean commands;
- handling conflicts with Overleaf Workshop.

Do not disturb my already-working MiKTeX setup.

### Phase 2 — Semantic and flexible document interfaces

Refactor rigid presentation-oriented interfaces into semantic ones where justified.

Priority examples:

- replace or supplement the fixed five-argument `\choices` command with a flexible choices environment;
- review `namedformula`, including its currently unused argument;
- improve labels and cross-references;
- review theorem and box interfaces;
- document the public commands.

Maintain compatibility aliases where practical.

### Phase 3 — One source, multiple assessment outputs

Upgrade `physicsquiz.cls` to support controlled variants such as:

- student paper;
- teacher paper;
- worked-solutions booklet;
- compact answer key;
- colour and print-friendly modes;
- version A/B metadata;
- optional marks and difficulty labels.

Teach class options, booleans, conditionals, and clean separation between content and presentation.

### Phase 4 — Question-bank architecture

Design a scalable question representation with appropriate metadata:

- stable ID;
- topic;
- difficulty;
- marks;
- correct option;
- solution;
- tags;
- optional learning outcome.

Compare a lightweight custom implementation with a suitable established package such as `xsim` before choosing.

Required outputs should be generated from the same question source without duplicating questions or answers.

### Phase 5 — Shared OT design system

Audit duplication across the classes and design a maintainable structure, for example:

- `otcore.sty`
- `ottheme.sty`
- `otboxes.sty`
- `otmath.sty`
- `studentnotes.cls`
- `physicsquiz.cls`
- any workbook-specific class such as `otscience.cls`

Move only genuinely shared code. Avoid creating too many tiny packages without benefit.

### Phase 6 — Modern LaTeX interface programming

Teach and selectively apply:

- `\NewDocumentCommand`;
- argument specifications;
- key-value configuration;
- `l3keys2e` or another justified option system;
- `expl3` naming and data types;
- booleans, token lists, sequences, and property lists;
- robust error and warning messages;
- namespace discipline.

Do not rewrite stable traditional LaTeX code merely for stylistic purity.

### Phase 7 — Modular long-document architecture

Using the full workbook source tree:

- review `\input` versus `\include` versus `subfiles`;
- preserve independent compilation where needed;
- establish a single source of shared setup;
- improve root detection;
- manage figures and paths;
- improve cross-file labels and references;
- review table of contents, front matter, and module boundaries;
- verify that the combined and standalone builds remain consistent.

### Phase 8 — Scientific publishing tools

Introduce only the tools that fit my work:

- `biblatex` and Biber;
- Zotero/Better BibTeX workflow;
- acronyms, glossaries, and symbol lists;
- `cleveref` or `zref-clever`;
- CircuiTikZ;
- PGFPlots;
- code listings using `listings` or `minted`;
- indexes;
- accessible PDF considerations.

Use representative mini-projects before integrating them into a class.

### Phase 9 — Build automation and performance

Teach and evaluate:

- `latexmkrc`;
- VS Code recipes;
- `arara` where it provides a real advantage;
- auxiliary-file cleaning;
- TikZ externalisation/caching;
- optimising the per-page dot-grid background;
- reproducible build directories;
- package/version diagnostics.

### Phase 10 — Testing, documentation, and release discipline

Teach and implement:

- Git commits and tags;
- semantic class versions;
- `CHANGELOG.md`;
- class documentation and usage examples;
- regression tests;
- `l3build`;
- minimal test files;
- compatibility tests;
- release packaging.

## Starting instruction

Begin with **Phase 0 only**.

First inspect all attached files and return:

1. a source-tree inventory;
2. a public-interface inventory for each class;
3. a dependency and package audit;
4. a list of missing files required to compile each project;
5. a risk-ranked list of issues;
6. a proposed baseline folder structure;
7. the smallest first task for me to perform locally.

Do not modify any file in the first response.
