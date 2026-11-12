# LaTeX-lab Architecture Refactor Plan

## Purpose

Evolve LaTeX-lab from a mixture of mature shared packages and earlier
all-in-one classes into a predictable layered toolkit. The work must preserve
existing author documents by default: new interfaces are additive, established
interfaces remain available as compatibility wrappers, and removals require an
explicit versioned deprecation decision.

This plan is a design and implementation roadmap. It does not itself change
any class or package behaviour.

## Target architecture

```text
Author document
  -> exactly one document class
       -> base class and document-genre workflow
       -> named document preset(s)
       -> shared foundations
       -> explicitly requested capability packages
```

### Responsibilities

| Layer | Owns | Must not own |
| --- | --- | --- |
| Class | Base class selection, class options, genre-specific structure and author workflow | Reusable general-purpose tools or duplicate shared semantics |
| Preset/theme package | A named family of visual and layout choices, including deliberate overrides | Document structure or optional content capabilities |
| `otbase` (proposed) | Dependency-light compatibility and implementation helpers | Margins, headings, colours, boxes, or document policy |
| `ottheme` | Shared design tokens and hyperlink policy | Page geometry, headers, document workflow, or domain notation |
| `otlayout` (proposed) | Reusable, opt-in page furniture and layout defaults | Palette ownership or class-specific semantics |
| `otboxes` | Shared box primitives and stable semantic box families | Book-only or notebook-only concepts |
| Capability/domain package | One focused optional capability or subject vocabulary | Implicit class loading or unrelated layout policy |

Classes are composition roots: they select and configure packages. Packages own
their reusable implementation.

## Architectural decisions to adopt

1. **`otboxes` owns common semantic science boxes, as an opt-in family.**

   `definitionbox`, `theorembox`, `lawbox`, `formulabox`, `derivationbox`,
   `examplebox`, `warningbox`, `intuitionbox`, `summarybox`, and
   `experimentbox`, including their `nosplit` variants, become stable
   author-facing interfaces owned by `otboxes`.

   These names are common, and `otpractice` already loads `otboxes`, so
   defining them unconditionally would break any standalone document that
   defines its own `examplebox` or `summarybox` (the vector workbook already
   guards against exactly this with `\@ifundefined`). The family is therefore
   opt-in: `\usepackage[semantic]{otboxes}` (or an equivalent companion
   package, e.g. `otsciboxes`, if a separate file proves cleaner). Plain
   `\usepackage{otboxes}` keeps today's surface: `otscibox` and
   `otsciboxnosplit` only.

   `otscibox` and `otsciboxnosplit` remain advanced primitives. `otscience`
   and `otbook` enable the semantic family rather than defining duplicate
   wrappers. `otbook` continues to own book-specific interfaces such as
   `chaptergoals`, `chapteroverview`, `reflectionbox`, and `designrule`.

   Out of scope for this decision, but recorded so they are not forgotten:
   the third copy of the family in `src/legacy/otscience.sty`; the separate
   `otbox` primitive and `experiment` environment in `otengineering`; the
   `quicknote`/`personalnote`/`importantnote`/`namedformula` family in
   `studentnotes`; and `proofbox`/`identitybox` in `otmath` (see Phase E).

2. **Classes select named presets, not ad-hoc collections of low-level code.**

   The eventual preset names should make their purpose plain, for example
   `otnotes-theme`, `otscience-theme`, and `otengineering-theme`. A preset may
   borrow shared theme, layout, and box rules while retaining explicit document
   differences. Student Notes may therefore keep its margin-note and dot-grid
   decisions without duplicating universal infrastructure.

3. **Every package load is deterministic; existing bundles are preserved.**

   No class or package uses filesystem discovery such as
   `\IfFileExists{x.sty}{\RequirePackage{x}}{}` to silently acquire author
   capabilities. Where a class already provides a bundle of OT companion
   packages, those packages ship in the same author kit, so the bundle is
   kept and made deterministic: each conditional load becomes an
   unconditional `\RequirePackage`. Removing a bundle would break every
   document that relies on, say, `\vect` or `\qitem` arriving with the class,
   so authors who want a lean build opt out with a documented class option
   (e.g. `minimal`) rather than everyone opting in.

   New capabilities are not added to class bundles by default; an author
   chooses them with `\usepackage{...}`. The current bundles are
   inconsistent (`otbook` loads 15 companions, `otscience` 7) and must be
   reconciled and documented in Phase C.

   A package may still probe for a *third-party* engine capability (e.g.
   `otaccess` testing for `tagpdf.sty`) only if the fallback is documented
   and emits a `\PackageWarning` or `\PackageInfo` so the difference is
   visible in the log.

4. **`otcore` is transitional, not the permanent home of every shared rule.**

   Preserve `otcore` as a compatibility facade. Gradually extract a small
   `otbase` and an opt-in `otlayout`; leave a compatibility layer in `otcore`
   until a major-version migration is deliberately approved.

5. **New public commands are namespaced by default.**

   Use `\ot...` for commands and an OT-specific environment/package namespace.
   Existing short commands remain supported where documented, but new short
   names require a clear collision analysis and compatibility justification.

6. **Notation is semantic first; visual pedagogy is separate.**

   Domain notation must work without a theme, class, or preset unless its
   declared purpose is presentation. Branded prose emphasis belongs in a
   theme-dependent package, not in a neutral notation package.

7. **Colour tokens and hyperlink policy are separate concerns.**

   Today `ottheme` both defines the palette and loads `hyperref` with a
   global `\hypersetup{colorlinks=true,...}`. Every package that needs only
   colours (`otboxes`, `otnotation`, `otmath`, `otfigures`, `otcode`, and
   others) therefore changes link behaviour in a plain `article` document,
   contrary to rule 7 below. The palette moves to a tokens-only package (e.g.
   `otcolors`); `ottheme` remains a compatibility facade that loads the tokens
   and applies the link policy exactly as now. Capability packages require the
   tokens package only. Because standalone documents may rely on `hyperref`
   arriving transitively, this switch is a recorded behaviour change that
   needs explicit approval, a changelog entry, and a migration note.

8. **A public command has one meaning regardless of load order.**

   Public commands must not be defined with `\providecommand` where an
   already-loaded package may supply a different definition. Today
   `otnotation` does this for `\dd`, `\grad`, `\tr`, and `\rank` (the
   `physics` package wins under `otscience`/`otbook`, OT's definitions win
   under plain `article`), and its `\providecommand{\unit}` is dead code once
   `siunitx` v3, which `otnotation` itself loads, has defined `\unit`. Where
   OT intends to defer to a third-party definition, that deferral is
   documented as the contract; otherwise OT uses a namespaced command.

## Work phases

### Phase A — Contract and dependency audit

**Goal:** establish the exact current public and internal surface before any
move.

- Inventory all public commands, environments, options, counters, colours, and
  load-time effects in every `.cls` and `.sty` file.
- Classify each item as stable author interface, advanced ecosystem hook, or
  internal implementation detail.
- Produce a dependency graph marking required, optional, and implicit
  filesystem-discovered dependencies.
- Identify package-order requirements and third-party collisions.
- Update `docs/PUBLIC_INTERFACES.md` with companion-package contracts; it
  currently excludes most detailed package APIs (for `otboxes` it documents
  only `otscibox` and `otsciboxnosplit`).
- Record hidden load-order dependencies. Known so far: `otcore`'s section
  styles use `OTDark` and `OTBlue` without loading `ottheme`; `otcore` loads
  `geometry` with `margin=1in` at load time, so a later class cannot pass
  different `geometry` options without an option clash; `otnotation`'s
  `\providecommand` definitions vary with `physics`/`siunitx` load order.
- Inventory every box family and theorem-like environment across classes
  and packages, including `src/legacy/otscience.sty`, so Phase B and Phase E
  have a complete overlap map.

**Exit criteria:** each proposed move has an owner, compatibility status,
representative documents, and regression targets.

### Phase B — Centralise the semantic science-box family

**Goal:** make `otboxes` the single implementation and public owner of common
semantic boxes, without exposing new names to documents that did not ask
for them.

- Add the shared semantic wrappers to `otboxes` behind the `semantic` option
  (or in a companion package; decide in this phase), using its existing
  primitives.
- Retain exact defaults, titles, colours, breakability, and syntax from the
  current `otscience` and `otbook` implementations.
- Make the move **one atomic change**: in the same commit, add the family to
  `otboxes`, switch `otscience` and `otbook` to enable it, and delete their
  wrapper definitions. Both classes load `otboxes` before their own
  `\newenvironment` calls, so any intermediate state fails with
  "environment already defined".
- Leave `otpractice`'s `\RequirePackage{otboxes}` unchanged, so standalone
  `otpractice` documents gain no new names.
- Keep book-specific boxes inside `otbook`.
- Decide and record the fate of `src/legacy/otscience.sty` (freeze as-is,
  or reduce to a wrapper around `otboxes`); do not leave it as an unmentioned
  third copy.
- Extend the existing tests rather than starting new ones:
  `tests/ot_boxes_package_smoke.tex` (plain and `semantic` modes),
  `tests/otscience_boxes_compatibility.tex`, `tests/otbook_class_smoke.tex`,
  and `tests/otpractice_standalone.tex`. Add a test document that defines its
  own `examplebox` after `\usepackage{otboxes}` and `\usepackage{otpractice}`
  to prove the default surface has not grown.
- Rebuild the vector workbook and `examples/otscience` starter as visual
  review targets.

**Exit criteria:** one canonical definition per shared semantic environment;
existing examples and regression checks retain their rendered meaning;
standalone `otboxes` and `otpractice` users see no new names unless they
opt in.

### Phase C — Make dependencies explicit

**Goal:** eliminate environment-dependent feature acquisition without breaking
existing class documents.

- Replace each `\IfFileExists{x.sty}{\RequirePackage{x}}{}` in `otscience`
  and `otbook` with an unconditional `\RequirePackage{x}`. Existing documents
  keep the same feature set; partial installations now fail loudly instead of
  silently losing commands.
- Reconcile the two bundles (`otbook`: 15 companions; `otscience`: 7) and
  document the intended bundle for each class, with the reason for every
  difference.
- Add a documented opt-out class option (e.g. `minimal`) that loads only
  the required foundations, for authors who want to choose capabilities with
  `\usepackage`.
- Review third-party probes inside packages (e.g. `otaccess` and `tagpdf`)
  and make each fallback log a warning or info message.
- Document recommended package loading patterns in starter documents.

**Exit criteria:** compiling the same source in two installations with
different incidental package availability either yields the same feature set
or stops with a clear missing-package error; no existing starter or example
changes output under default class options.

### Phase D — Establish foundation and preset boundaries

**Goal:** separate universal rules from layout choices and document-family
variation without visual regressions.

- Define a minimal proposed `otbase` contract before creating the package.
- Identify which `otcore` responsibilities are layout choices and prototype an
  `otlayout` API only where a real second consumer exists.
- Keep `ottheme` as the token/link-policy owner; decide whether hyperlink
  policy should become an opt-in companion while retaining current behaviour.
- Introduce named presets incrementally, starting with the class where the
  benefit is largest and regression coverage is strongest.
- Keep `otcore` as a compatibility facade throughout the transition.
- Resolve `otcore`'s load-time `\RequirePackage[margin=1in]{geometry}`:
  move page geometry into `otlayout` (or a class-time hook) so classes can
  set their own geometry without option clashes, keeping `otcore`'s default
  output unchanged.
- Make `otcore`'s dependency on the colour tokens explicit, so it no longer
  relies on the class loading `ottheme` first.
- State the position of `physicsquiz` and `studentnotes`, which currently
  load none of `otcore`, `ottheme`, or `otboxes`: either they stay
  deliberately self-contained (and say so), or this phase names the preset
  that brings them into the layering. `physicsquiz` has the heaviest
  regression suite and should not move without it.

**Exit criteria:** each class can state which foundation, layout, and preset
packages it deliberately loads, and why.

### Phase E — Rationalise mathematical and subject notation

**Goal:** make notation packages composable, predictable, and safe outside OT
classes.

Proposed package roles:

| Package | Proposed responsibility |
| --- | --- |
| `otnotation` | Neutral general notation: vectors, matrices, operators, delimiters |
| `otmath` | Neutral general mathematical concepts and identities |
| `otphysics` | Physics-specific symbols, quantities, and laws |
| `otcoordinates` | Coordinate-system notation and transformations |
| `ottensors` | Tensor/index notation and continuum-mechanics vocabulary |
| `otemphasis` (proposed) | Theme-dependent prose emphasis such as important concepts/results |

- Map duplicate and overlapping commands before changing their implementation.
- Move theme-dependent presentation helpers out of neutral notation packages:
  `\important`, `\keyterm`, `\concept`, and `\result` from `otnotation`
  (to `otemphasis`), and `proofbox`/`identitybox` from `otmath` (to
  `otboxes` or a presentation companion).
- Fix load-order-dependent meanings (decision 8): `\dd`, `\grad`, `\tr`,
  `\rank`, and the dead `\unit` definition in `otnotation`.
- Reconcile `otmath`'s `otplaindesignrule` with `otbook`'s `designrule`.
- Complete the colour-token/link-policy split (decision 7) before this
  phase's exit check, since `otnotation` and `otmath` currently pull in
  `hyperref` through `ottheme`.
- Make domain packages depend only on neutral notation or basic math packages,
  unless a visual dependency is explicitly part of their public purpose.
- Introduce canonical namespaced commands such as `\otMean`, `\otInverse`,
  `\otForce`, `\otGiven`, and `\otResult` where appropriate.
- Preserve established short commands as compatibility aliases until a future,
  explicit deprecation decision.

**Exit criteria:** domain packages can be loaded with standard `article` or
`book` without importing unrelated OT visual policy.

### Phase F — Documentation, migration, and release discipline

**Goal:** make the architecture understandable and safe for authors.

- Update the public interface reference, author manual, starter documents,
  changelog, and release notes together with each interface change.
- Publish a migration table: old interface, canonical interface, status,
  compatibility window, and examples.
- Add a package-author checklist based on the rules below.
- Perform visual PDF review wherever layout, headings, boxes, or pagination
  may change.

**Exit criteria:** an author can choose a class and optional packages without
needing to know internal package order or class implementation history.

## Rules for every new class or package

1. Create a class only for a distinct document genre, base-class model, or
   author workflow—not merely a visual variation.
2. Create a package for reusable capability that can plausibly serve more than
   one class or a standard LaTeX class.
3. Give each public command/environment one owner and one documented stability
   level.
4. Load required foundations deterministically; never discover optional
   features from the filesystem.
5. Keep semantic/domain packages independent of presentation wherever possible.
6. Use namespaced public names by default; preserve short legacy names only as
   explicit compatibility interfaces.
7. Do not silently change global layout, colours, link behaviour, counters, or
   third-party package configuration from an optional capability package.
8. Declare third-party dependencies and package-order constraints in the
   package documentation.
9. Add a minimal standalone smoke test, a representative integration test, and
   a visual review target when output appearance is affected.
10. Add a changelog and migration note in the same change that modifies an
    author-facing contract.
11. Do not define a public command with `\providecommand` when another
    loaded package may already define it differently; one command, one
    meaning, regardless of load order.
12. Adding commonly named public interfaces to a package that other packages
    already load must be opt-in (option or companion package), so existing
    documents that use those names keep compiling.
13. Move or rename a definition atomically: the new owner gains it and the
    old owner loses it in the same change.

## Implementation order

1. Phase A: audit and public contracts, including the hidden load-order
   dependencies and the full box/theorem overlap map.
2. Phase B: opt-in shared semantic boxes in `otboxes`, as one atomic change.
3. Phase C: deterministic bundle loading with an opt-out option.
4. Colour-token/link-policy split (decision 7), after explicit approval of
   the behaviour change for standalone package users.
5. Phase D: foundation/layout/preset separation, including `otcore`'s
   geometry and the position of `physicsquiz` and `studentnotes`.
6. Phase E: notation rationalisation and namespaced canonical APIs.
7. Phase F: migration documentation and release preparation.

The first implementation change should still be Phase B. It adds no new
link-policy exposure (`otboxes` already loads `ottheme`), has the narrowest
scope, and, with the opt-in option and atomic move, a straightforward
compatibility story.

## Revision notes

**2026-11-11 — review against source.** Revised after checking the plan
against `src/`:

- Phase B made atomic and opt-in (the original order would fail to compile;
  unconditional names would break standalone `otboxes`/`otpractice` users).
- Phase C changed from removing class bundles to making them deterministic
  with an opt-out, preserving existing documents.
- Added decision 7 (colour tokens vs. link policy) and decision 8 (one
  meaning per command), with matching rules 11–13.
- Recorded gaps: `src/legacy/otscience.sty`, other box families,
  `otcore`'s geometry and hidden colour dependency, and the position of
  `physicsquiz` and `studentnotes`.
