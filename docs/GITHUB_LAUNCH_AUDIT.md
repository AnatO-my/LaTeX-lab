# GitHub Launch Audit

## Purpose

This audit records the local state before the first private GitHub launch. It is
the bridge between the Phase 7 readiness documents and the actual push process.

## Current Result

The repository has completed the first GitHub push and the first GitHub-side
inspection.

Local state to preserve:

* branch: `main`;
* remote: `origin` points to `https://github.com/AnatO-my/LaTeX-lab.git`;
* normal commit policy: source files only;
* generated outputs: excluded from source commits; and
* first hosted automation: deferred until after the repository is pushed and
  inspected.

## Expected Local Leftovers

The following are expected before the first push and should remain unstaged:

* `src/classes/physicsquiz.cls` line-ending-only working-tree noise;
* `AGENTS.md`;
* `examples/physicsquiz/indent.log`; and
* `tests/__pycache__/`.

## Launch Sequence

Use `docs/GITHUB_PUSH_CHECKLIST.md` for the full runbook.

The short sequence is:

1. Create a private GitHub repository without initializing it with a README,
   `.gitignore`, or license.
2. Add the remote locally with `git remote add origin <github-repository-url>`.
3. Inspect the remote with `git remote -v`.
4. Push with `git push -u origin main`.
5. Inspect the rendered README, contribution guide, issue templates, pull
   request template, workflow docs, and starter files on GitHub.

Steps 1 through 5 are complete for
`https://github.com/AnatO-my/LaTeX-lab.git`.

The GitHub inspection confirmed:

* expected files are present;
* generated output files are absent; and
* the `build/` folder is absent.

## After Push

After the first push inspection, the next checkpoints can choose whether to:

* onboard first collaborators;
* add starter-build GitHub Actions;
* prepare release preview PDFs; or
* prepare a source-derived author kit.
