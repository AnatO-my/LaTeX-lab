# LaTeX Skill Library

This directory keeps reusable, source-controlled skill bundles for the
LaTeX-lab workflow. They are instructions and optional helper scripts, not
part of a document build and not generated output.

| Family | Purpose | Contents |
| --- | --- | --- |
| `build-diagnostics` | Compile failures, warnings, and safe repair workflow | `latex-build-logs` |
| `academic-writing` | Review and improve existing English LaTeX papers | `latex-paper-en` |
| `latex-toolkit` | General typesetting, bibliography, drawing, template, and collaboration guides | `latex-skills` |

## Using a skill

Open the target `SKILL.md` first. Read only the referenced module or support
file needed for the request, resolving relative paths from that skill's folder.
Treat bundled scripts as opt-in tools: inspect their inputs and follow the
repository's `AGENTS.md` and build conventions before running them. Never
assume a third-party command may edit source or access the network without
authorization.

## Third-party material

Each imported bundle remains in its own folder with `SOURCE.md` and its
upstream `LICENSE`. Do not remove or weaken those notices. `latex-paper-en` is
PolyForm Noncommercial material; do not use or distribute that subtree for a
commercial purpose. `latex-skills` is MIT-licensed. Imported bundles are
snapshots, not automatically updated dependencies; review the upstream source,
license, and changes before replacing one.
