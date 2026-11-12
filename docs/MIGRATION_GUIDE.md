# Migration Guide: Architecture Refactor (2026)

This guide is for authors updating to the LaTeX-lab architecture refactor in
`PLAN.md` (phases A to E, 11–12 November 2026).

**In short:** documents that use `otscience`, `otbook` or `otengineering`
compile unchanged. Only two changes are visible:

1. **`OTLight` is `#F3F4F6` in every OT class**, so science and book box
   backgrounds are slightly darker. Nothing to do unless you need the old
   tint (see below).
2. **In a standard class (`article`, `book`), OT packages no longer load
   `hyperref`.** If you relied on that, add `\usepackage{ottheme}`.

Everything else is additive. Old names keep working, and the canonical names
are the recommended spelling for new documents.

## Who needs to act

| You use… | Action |
| --- | --- |
| An OT class (`otscience`, `otbook`, `otengineering`) | None. |
| `studentnotes` or `physicsquiz` | None. These classes are self-contained and were not changed. |
| A standard class with OT packages, and you use links, `\url`, `\autoref`, or OT link colours | Add `\usepackage{ottheme}`, or load `hyperref` yourself. |
| A standard class with your own `examplebox`/`summarybox`/… and `otboxes` or `otpractice` | None. These packages still do not define those names. |
| `\marks{n}` from `otpractice` | Replace it with `\otmarks{n}`. `\marks` never worked: it is a TeX primitive and stopped with "Missing number". |
| You need the old science background `#F9FAFB` | Add `\definecolor{OTLight}{HTML}{F9FAFB}` after the class or packages load. |
| `\usepackage{geometry}` with options **after** `otcore` | Load `geometry` with your options **before** `otcore`, or use `\geometry{...}` afterwards. Loading it after `otcore` still clashes; loading it before now works. |

## Old interface → canonical interface

Status values:

* **alias**: the old name is an exact copy of the canonical name and is
  kept with no removal date.
* **moved**: same name, new owning package, loaded automatically as before.
* **changed**: behaviour differs; see the note.

Any removal would need a separate, versioned deprecation decision
(`docs/VERSIONING_RELEASE_POLICY.md`).

| Old interface | Canonical interface | Package | Status | Note |
| --- | --- | --- | --- | --- |
| `\important{x}` | `\otimportant{x}` | `otemphasis` | alias, moved | `otnotation` still loads `otemphasis` unless you give `noemphasis` |
| `\keyterm{x}` | `\otkeyterm{x}` | `otemphasis` | alias, moved | as above |
| `\concept{x}` | `\otconcept{x}` | `otemphasis` | alias, moved | as above |
| `\result{x}` | `\otresult{x}` | `otemphasis` | alias, moved | as above |
| `\mean{x}` | `\otmean{x}` | `otnotation` | alias | |
| `\dd` | `\otdiff` | `otnotation` | alias | `\dd` keeps an earlier definition; in OT classes that is `physics`'s `\dd` |
| `\grad` | `\otgrad` | `otnotation` | alias | as above |
| `\tr` | `\ottrace` | `otnotation` | alias | as above |
| `\rank` | `\otrank` | `otnotation` | alias | as above |
| `\inv{A}` | `\otinverse{A}` | `otmath` | alias | |
| `proofbox`, `identitybox` | unchanged | `otmathboxes` | moved | `otmath` still loads it unless you give `noboxes` |
| `\force` | `\otforce` | `otphysics` | alias | |
| `\given{x}` | `\otgiven{x}` | `otpractice` | alias | |
| `\blank[w]`, `\bigblank`, `\longblank`, `\componentblank` | `\otblank[w]`, `\otbigblank`, `\otlongblank`, `\otcomponentblank` | `otpractice` | alias | the short names keep an earlier definition (`xsim` defines `\blank`) |
| `\marks{n}` | `\otmarks{n}` | `otpractice` | changed | the old name never worked |
| `\unit{...}` in `otnotation` | `\unit` from `siunitx` | `siunitx` | changed (no effect) | OT's fallback was dead code and was removed |
| `definitionbox` … `experimentbox` (+ `nosplit`) | unchanged | `otsciboxes` | moved | `otscience`/`otbook` load it; it can also be used with a standard class |
| `\otcorelistdefaults`, `\otcorepagestyle`, `\otcoresectionstyles` | unchanged | `otlayout` | moved | `otcore` still provides them |
| `OT...` colour names | unchanged | `otcolors` | moved | `ottheme` still provides them, plus link policy |
| `OTLight` = `#F9FAFB` (science) | `OTLight` = `#F3F4F6` (all) | `otcolors` | changed | visible tint change |
| Link policy from any OT package | link policy from `ottheme` only | `ottheme` | changed | standard-class documents only |
| Companions loaded only if installed (`\IfFileExists`) | always loaded | `otscience`, `otbook` | changed | missing files now stop with "File not found" |

## New options

| Option | Effect |
| --- | --- |
| `\documentclass[minimal]{otscience}` / `{otbook}` | Skip the companion bundle (notation, math, physics, …); load what you need with `\usepackage`. |
| `\usepackage[noemphasis]{otnotation}` | Notation without OT colours or emphasis commands. |
| `\usepackage[noboxes]{otmath}` | Theorems and helpers without `tcolorbox` or OT colours. |

## Examples

Lean science notes:

```latex
\documentclass[minimal]{otscience}
\usepackage{otnotation}           % load only what this document needs
\usepackage{otphysics}
\begin{document}
\begin{lawbox}[Newton's second law]
  $\otforce = m\vect{a}$
\end{lawbox}
\end{document}
```

Standalone article that used OT link styling through a capability package:

```latex
\documentclass{article}
\usepackage{ottheme}              % new: restores OT link colours and hyperref
\usepackage{otnotation}
```

Exam sheet:

```latex
\usepackage{otpractice}
\qitem State Newton's second law. \otmarks{4}   % was \marks{4}
```

## Verification references

* `tests/run_architecture_refactor_tests.ps1` runs every refactor fixture,
  the interface-inventory check, the Phase 5 baseline and the otbook runner.
* `docs/ARCHITECTURE_AUDIT.md` records the before-and-after evidence for
  each phase.
