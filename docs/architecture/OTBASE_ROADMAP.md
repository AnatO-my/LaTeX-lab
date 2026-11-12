# `otbase` Roadmap

Status: **not created**. This document records when and how `otbase` should
come into existence. It expands decision 4 of
[`PLAN.md`](PLAN.md#architectural-decisions-to-adopt) and the Phase D note in
[`ARCHITECTURE_AUDIT.md`](ARCHITECTURE_AUDIT.md#phase-d-decisions-12-november-2026).

## The story of `otbase`

`otbase` should not begin as "the package everything loads." It should emerge
only after repeated non-visual needs prove that a shared foundation is real.

```text
Today
├─ Classes own composition
├─ Theme/layout/boxes have named owners
└─ Several packages independently solve small infrastructure problems

Next
├─ Identify repeated infrastructure
├─ Extract only the repeated, non-visual parts
└─ Give them one stable home: otbase

Later
├─ More packages consume that stable foundation
├─ Classes and templates gain consistent diagnostics
└─ otbase becomes useful without becoming mandatory everywhere
```

## Phase 1 — Observe repetition

At first, each package should remain independent. For example:

```text
otprofiles   → asks "which build mode is active?"
otaccess     → asks "which engine/capability is available?"
otreproduce  → asks "can this generated result be traced or explained?"
```

Each may need to:

- detect an engine or optional capability;
- store a feature status;
- emit a consistent informational message or warning;
- expose a small author-facing query;
- preserve predictable behaviour when a capability is unavailable.

If each package implements this separately, the project eventually gets
several slightly different message styles, fallback behaviours, option
interfaces and internal conventions. That is the moment to consider `otbase`.

The key test is not "could this code be shared?" Almost anything could be.
The test is:

> Do two or more independently useful packages need the same rule, with the
> same meaning, and without importing presentation?

## Phase 2 — Extract a narrow, non-visual kernel

Once repeated behaviour is confirmed, `otbase` gets only the shared mechanics.

```text
otbase
├─ capability registry
├─ engine/capability checks
├─ standard diagnostics
├─ version/capability metadata helpers
└─ lightweight l3keys configuration conventions
```

It should not contain:

```text
No colours
No hyperref policy
No geometry
No heading design
No boxes
No document class
No subject notation
```

A possible mental model:

```text
otbase   = "What is available, configured, or supported?"
otcolors = "Which colours exist?"
ottheme  = "How should links and the palette behave in an OT document?"
otlayout = "How should it occupy a page?"
otboxes  = "How should semantic content be framed?"
class    = "What kind of document is this?"
```

## Phase 3 — First real consumers: capability-aware packages

The first sensible consumers would be `otprofiles`, `otaccess` and
`otreproduce`. The names below are illustrative. Real public names follow the
repository's lowercase `\ot...` convention (plan decision 5), and internals use
`expl3` names.

```text
otbase
├─ declare a capability          (e.g. tagging)
├─ test a capability             (true/false branches)
├─ standard info message
└─ standard warning

otaccess
└─ declares and checks PDF tagging support

otprofiles
└─ declares the active build/profile capabilities

otreproduce
└─ declares whether a computational/snippet workflow is traceable
```

The benefit is one predictable author experience:

```text
Requested feature
  → available:   enable it and report the active mode
  → unavailable: use the documented fallback and emit one clear warning
  → unsupported: fail early with a precise explanation
```

This helps authors because the logs become readable and predictable.

Today's packages already approximate this with standard LaTeX messages, as
the evidence review below shows. `otbase` adds value here only if the shared
capability *status* (something another package can query) becomes necessary,
not just consistent wording.

## Phase 4 — Formal-document packages become a second family

`ot-projects` and `oteeereport` are a different kind of consumer. They do not
primarily need engine detection; they need reliable structured metadata.

```text
Project/report metadata
├─ title
├─ identifier
├─ version
├─ status
├─ author or team
├─ dates
├─ sign-off state
└─ validation rules
```

Today each package validates and stores these values itself. If their
requirements overlap, `otbase` may provide neutral infrastructure:

```text
otbase
├─ key-value declaration pattern
├─ required-field validation
├─ standard "missing metadata" diagnostics
├─ data normalisation helpers
└─ capability/version declarations

ot-projects
└─ project records, registers, milestones, evidence

oteeereport
└─ formal report metadata and report-specific views
```

`otbase` would not decide how a report title page looks; that belongs to
`oteeereport` or a theme or preset. It would only help both packages answer
questions such as:

- Is required metadata present?
- Is this identifier valid?
- Is the active profile compatible with this output?
- How should a missing field be reported?

## Phase 5 — Classes use it without losing identity

A future generic academic class (perhaps `otarticle`) and a modernised
`studentnotes` could share the same neutral compatibility layer.

```text
otarticle
├─ article-based academic workflow
├─ its own preset choices
└─ otbase for compatibility/diagnostics

studentnotes
├─ personal-note workflow
├─ note-specific margins, grid, and metadata
├─ its own notes preset
└─ otbase for compatibility/diagnostics
```

They would not become visually identical.

```text
Shared through otbase
├─ consistent option diagnostics
├─ engine/capability reporting
├─ common metadata validation
└─ stable configuration conventions

Kept distinct in each class/preset
├─ margins
├─ title format
├─ typography
├─ box choices
├─ dot-grid behaviour
└─ document workflow
```

This is the point of the layered model: reuse rules, not personality.
`studentnotes` is self-contained by decision today (see "Class composition" in
`docs/PUBLIC_INTERFACES.md`); `otbase` would be the first layer it could
adopt without changing its output.

## Phase 6 — External author kits become safer

Once author kits are copied outside this repository, they need good
diagnostics more than they need more styling.

```text
Author-kit document
├─ picks a class
├─ picks a theme/preset
├─ opts into capability packages
└─ receives clear checks from otbase
```

For example, an author could get useful feedback if:

- the selected PDF feature needs LuaLaTeX;
- a reproducible-result include file is missing;
- a project-record package needs metadata the document does not supply;
- a chosen profile conflicts with an enabled interactive-form feature.

The author kit stays free to use its own typography and layout. `otbase`
helps it fail clearly and behave predictably.

## Phase 7 — A modern configuration convention becomes established

New packages should not each invent a fresh option parser and internal
naming scheme.

```text
New package
  ├─ declares its package identity
  ├─ defines its keys using a project convention
  ├─ validates values consistently
  ├─ emits standard diagnostics
  └─ exports a minimal public API
```

This may become the clearest technical reason for `otbase`: a small
`expl3`/`l3keys` convention shared by several packages. But it must stay a
convention, not a giant framework. A package that does not need configuration
should not be forced to depend on it.

**First step, already adopted:** the convention is written down in
`docs/PACKAGE_AUTHOR_CHECKLIST.md` (new packages use `l3keys`) before any code
is shared. `otbase` follows only if two packages then repeat the same
validation or diagnostic code.

## Evidence review (12 November 2026)

| Candidate | Current code | Gate met? |
| --- | --- | --- |
| Engine/capability checks | `otaccess`, `otprofiles` and `otcode` each test the engine with the standard `iftex` package in a line or two. | No. `iftex` already is the shared helper, so extracting it would not simplify the consumers (requirement 5) and would duplicate a standard package (requirement 6). |
| Diagnostics | Two styles. The LaTeX2e kernel commands: `otaccess` and `otreproduce` use `\PackageWarning`/`\PackageInfo` for fallbacks (`otaccess` since the Phase C refactor; `otreproduce` when a snippet file is missing), and `otcode`, `oteeereport` and the class check in `ot-projects` use `\PackageError`. expl3 messages: `ot-projects` reports record-validation failures with `\msg_new:nnn`/`\msg_fatal:nnn`. | No. Each package uses a standard mechanism, and there is no queryable status yet. If the expl3 style spreads, the shared need is a message-naming convention, not an `otbase` helper. |
| Option and key–value handling | Three systems across four packages: `kvoptions` (`otprofiles`, `otmath`), `l3keys` (`ot-projects`), `pgfkeys` (`oteeereport`). | Not yet. This is the real divergence, so the convention comes first (Phase 7). |
| Metadata and requirement checks | `ot-projects` and `oteeereport` each stop with an error when used in the wrong class. Only `ot-projects` validates field values (record IDs). | No. There is one consumer for validation and the class checks are one line each. Revisit when `oteeereport` gains validated metadata. |

**Conclusion:** the gate is not met. Keep `otbase` as a written contract. The
likeliest trigger is the option convention: if `otprofiles` or `oteeereport`
moves to `l3keys` and repeats `ot-projects`' validation code, extract that
code.

## Decision gate: when to create it

Create `otbase` only when all of these hold:

```text
Requirement 1: at least two active packages need the same helper
Requirement 2: the helper is non-visual and not layout-related
Requirement 3: its public contract fits on one short documented page
Requirement 4: standalone smoke tests prove it works with article and book
Requirement 5: removing the duplicated code materially simplifies its consumers
Requirement 6: the helper is not already provided by the LaTeX kernel or a
               standard package (iftex, l3keys, kvoptions, ...)
```

Until then, keeping the contract in the architecture documents is the right
decision. It keeps the destination clear without introducing an empty
package just because the name sounds foundational.
