# Public Interfaces of the OT LaTeX Classes

## Purpose

This document records the supported public interfaces of:

* `physicsquiz.cls`;
* `studentnotes.cls`;
* `otengineering.cls`; and
* `otscience.cls`.

It also records the shared OT ecosystem hooks that these classes and their
companion packages expose deliberately, including the Phase 5 `ottheme.sty`
palette package, `otboxes.sty` base boxes, and `otcore.sty` class-support
helpers.

It describes commands and environments intended for document authors, identifies
advanced ecosystem hooks, and distinguishes them from internal implementation
details. It is an interface contract, not a catalogue of every command made
available by packages loaded by the classes.

## Interface stability levels

### Stable author interface

These commands and environments are intended for ordinary document use. Existing
syntax, defaults, numbering behaviour, and established visual output should remain
available unless a documented migration path is introduced.

### Advanced ecosystem hook

These interfaces support generic boxes, theme integration, workbook wrappers, or
companion packages. They should not be removed without auditing their dependants,
but ordinary documents should prefer the semantic author-facing interfaces.

### Internal implementation detail

Internal metadata storage commands, package configuration, counters, and formatting
machinery are not part of the supported author interface. Documents should use the
corresponding public setter or semantic command.

## Verification basis

The interface baseline uses three forms of evidence:

* **Regression-verified:** exercised by a dedicated compatibility document and,
  where visual behaviour matters, checked in the rendered PDF.
* **Representative-use verified:** found in an existing document that was rebuilt
  successfully during the Phase 2 audit.
* **Source-verified:** its declaration, argument count, default, and deterministic
  expansion were checked directly in the canonical class source. This label does
  not imply that every possible layout or third-party-package interaction has been
  tested.

The major semantic interfaces have regression coverage. The Phase 4 structured question-bank interface is regression-verified: its
records, validation errors, deterministic selection, seeded selection, and
generated outputs are exercised by the 4C, 4D, 4E, 4F, and 4G drivers and
checked by Python checkers against both semantic markers and the legacy
question source.
The Phase 3 assessment
options, semantic gates, and display hooks are covered by state assertions and a
shared synthetic assessment matrix. Small metadata, label,
rating, margin-note, arrow-annotation, and field helpers are documented from their
source contracts and representative uses. The distinction prevents the reference
from claiming broader test coverage than the project has established.

## General compatibility policy

* Existing stable interfaces remain available throughout the controlled refactor.
* Additive interfaces are preferred to breaking replacements.
* Established defaults, titles, colours, numbering, and pagination behaviour are
  preserved.
* A public interface must not be renamed or removed without deprecation and
  migration guidance.
* Commands merely made available by a loaded package are not automatically class
  interfaces.
* Standard LaTeX commands and package-owned commands retain the contracts of their
  respective classes or packages.
* Internal implementation commands may change provided that documented public
  behaviour remains unchanged.
* Generic names and shared colour names require a collision audit before reuse in
  another class or package.

## Shared package support policy

The Phase 5 shared OT packages, `ottheme.sty`, `otboxes.sty`, and `otcore.sty`,
declare package version `v0.2` and require LaTeX2e dated 2022-06-01 or newer.
pdfLaTeX is the supported engine. LuaLaTeX and XeLaTeX are expected to work, but
they are not part of the public support claim until the regression runners test
them directly.

The shared packages are ecosystem hooks. Ordinary documents should still prefer
the semantic class interfaces unless they are intentionally building a companion
package, compatibility wrapper, or class-level integration.

# `physicsquiz.cls`

## Class declaration and output options

```latex
\documentclass[<primary mode>,<presentation mode>,<article options>]{physicsquiz}
```

`physicsquiz` owns two independent option axes. Options it does not own continue
to the underlying `article` class, so declarations such as
`\documentclass[12pt,a4paper]{physicsquiz}` remain valid.

### Primary output mode

Exactly one primary output mode may be selected:

| Option | Selected semantic content |
| --- | --- |
| `full` | questions, answer key, worked solutions, references; marks and difficulty when supplied |
| `student` | questions and references; marks when supplied |
| `teacher` | questions, answer key, teacher notes, and references; marks and difficulty when supplied |
| `solutions` | worked solutions and references |
| `answerkey` | compact answer-key content only |

With no primary option, `full` is selected. Selecting more than one primary
mode produces a class error rather than silently choosing one.

### Presentation mode

Exactly one presentation mode may be selected:

| Option | Effect |
| --- | --- |
| `colour` | established colour appearance; the default |
| `color` | alias for `colour` |
| `print` | high-contrast greys, economical backgrounds, and hidden hyperlink decoration |

The presentation mode is independent of the primary output mode. For example:

```latex
\documentclass[student,print,12pt,a4paper]{physicsquiz}
```

Selecting `print` together with either spelling of `colour` produces a class
error. The default declaration `\documentclass{physicsquiz}` remains equivalent
to `full,colour` and preserves the established output.

## Quiz configuration commands

These commands form the stable author interface. Setters should normally be used in
the preamble, before `\makequiztitle` or other content that consumes their values.

| Command | Arguments | Default or effect |
| --- | ---: | --- |
| `\quizfontsize{<size>}{<baseline skip>}` | 2 required | Sets the document font at `\begin{document}`; defaults are `10pt` and `12pt` |
| `\quiztitle{<title>}` | 1 required | Replaces `Pre-test Questions` |
| `\quizauthor{<author>}` | 1 required | Replaces the empty author value |
| `\quizcourse{<course>}` | 1 required | Replaces `Physics` |
| `\quizinstitution{<institution>}` | 1 required | Replaces the empty institution value |
| `\quizinstructions{<instructions>}` | 1 required | Replaces `Choose the correct option for each question.` |
| `\quizconstants{<constants>}` | 1 required | Stores the author-supplied constants content; empty by default |
| `\quizversion{<label>}` | 1 required | Adds `Version <label>` to the title and running header; empty by default |
| `\makequiztitle` | none | Produces the configured title page and instructions box |
| `\constantsbox` | none | Produces the configured constants box |

Minimal configuration:

```latex
\documentclass{physicsquiz}

\quiztitle{PHY 104 Revision Quiz}
\quizcourse{Waves and Optics}
\quizauthor{OT}
\quizinstitution{Obafemi Awolowo University}
\quizinstructions{Choose the best answer in each case.}
\quizconstants{
  \(g=9.81\,\mathrm{m\,s^{-2}}\),
  \(c=3.00\times10^8\,\mathrm{m\,s^{-1}}\)
}
\quizversion{A}

\begin{document}
\makequiztitle
\constantsbox
\end{document}
```

The metadata values also feed the running header where applicable. An empty
`\quizversion{}` clears the visible version label. Versioning is metadata-only:
it does not select, reorder, or shuffle questions. The uppercase storage commands
described below are not the supported way to change metadata.

## Semantic output gates

The following stable environments include or suppress complete document sections
according to the selected primary mode:

| Environment | Intended content |
| --- | --- |
| `quizquestioncontent` | question booklet |
| `quizanswerkeycontent` | compact answer-key section |
| `quizsolutioncontent` | worked-solutions section |
| `quizteachercontent` | teacher-only guidance or annotations |
| `quizreferencecontent` | formula sheet or other reference material |

Example:

```latex
\begin{quizquestioncontent}
  \begin{quizquestions}
    \item Which quantity has SI unit hertz?
      \choices{Frequency}{Wavelength}{Amplitude}{Phase}{Speed}
  \end{quizquestions}
\end{quizquestioncontent}

\begin{quizanswerkeycontent}
  \begin{answerkey}
    1. A
  \end{answerkey}
\end{quizanswerkeycontent}
```

The gates select already-authored blocks. They do not store questions, collect
answers, or define a question-bank record. Existing documents remain valid without
these wrappers and therefore require no immediate migration.

## Optional question labels

```latex
\quizmarks{<value>}
\quizdifficulty{<label>}
```

These display-only hooks may follow a question stem. Marks are visible in `full`,
`student`, and `teacher`; difficulty is visible in `full` and `teacher`. Neither
command stores metadata, validates its argument, nor calculates totals.

```latex
\item Determine the fundamental frequency.
  \quizmarks{3}\quizdifficulty{Intermediate}
```

When horizontal space is limited, the labels may move together to the next line.

## Question and option interfaces

### `quizquestions`

```latex
\begin{quizquestions}[<columns>]
  \item <question>
\end{quizquestions}
```

The optional column count defaults to `2`. Questions are numbered with bold Arabic
labels. Authors may select another positive column count when the page layout permits
it.

### `choiceoptions`

```latex
\begin{choiceoptions}
  \item <first option>
  \item <second option>
  \item <additional options as required>
\end{choiceoptions}
```

`choiceoptions` is the preferred semantic option interface. It accepts an arbitrary
number of alphabetically labelled options and applies display style to mathematics.
The list can break across available column or page space.

Example:

```latex
\begin{quizquestions}[2]
  \item Which expression gives the angular frequency of a mass--spring
        oscillator?

  \begin{choiceoptions}
    \item \(\sqrt{k/m}\)
    \item \(k/m\)
    \item \(2\pi k\)
    \item \(m/k\)
  \end{choiceoptions}
\end{quizquestions}
```

### Legacy `\choices`

```latex
\choices{<A>}{<B>}{<C>}{<D>}{<E>}
```

The five-argument command remains a stable backward-compatible interface. It
delegates to `choiceoptions`; existing five-option quizzes require no migration.
New documents that need any number other than five options should use
`choiceoptions` directly.

The option interfaces are regression-verified for four, five, and six options,
prose, display-style mathematics, limited column space, and the representative
60-question quiz.

## Structured question-bank interface

*Stability: stable author interface. Regression-verified.*

The structured interface stores each question once, with its metadata, stem,
choices, and worked solution, and derives the booklet, answer key, topic report,
solutions, and mark totals from those records. It is additive: the manual
`quizquestions`, `choiceoptions`, `\choices`, and `answerkey` interfaces remain
fully supported and no existing document requires migration.

`xsim` provides the storage engine. Raw `xsim` syntax is an implementation
detail and is not a `physicsquiz` author interface. Both `xsim` and `siunitx`
must be installed.

### Declaring a bank

```latex
\begin{quizbank}
  \input{banks/<bank file>.tex}
\end{quizbank}
```

`quizbank` declares records without rendering anything. It is the normal way to
bring in a bank file.

### `quizquestion` and `quizsolution`

```latex
\begin{quizquestion}[
  id=phy104-osc-001,
  topic=oscillations,
  difficulty=foundation,
  marks=1,
  correct=C,
  tags={shm,restoring-force},
  outcome={Identify the direction of a restoring force}
]
  <question stem>
  \choices{<A>}{<B>}{<C>}{<D>}{<E>}
\end{quizquestion}
\begin{quizsolution}
  <worked solution>
\end{quizsolution}
```

| Key | Required | Contract |
| --- | --- | --- |
| `id` | yes | Stable identifier. Lowercase letters, digits, and single hyphens only. Must be unique across the document. |
| `topic` | yes | Free-form label used by filters and the topic report. |
| `difficulty` | yes | Exactly one of `foundation`, `applied`, or `challenge`. |
| `marks` | yes | Positive integer or decimal. Zero is rejected. |
| `correct` | yes | One option letter. Lowercase input is normalised to uppercase. |
| `tags` | yes | Comma-separated list. |
| `outcome` | no | Free-form learning outcome. |

Every `quizquestion` must be followed immediately by exactly one
`quizsolution`. The class raises a descriptive error for a missing required key,
a malformed or duplicate `id`, an invalid `marks` value, an invalid `correct`
label, an orphan solution, a duplicate solution, or a solution that does not
immediately follow its question.

Choices inside a record use the existing `\choices` or `choiceoptions`
interfaces, so a migrated question keeps its established rendering.

### Selection

```latex
\quizselectids{<comma-separated stable IDs>}
\quizselect[topic=...,difficulty=...,marks=...,tags={...}]
\quizselectall
\quizselectrandom[<same filter keys>]{<count>}{<seed>}
\quizclearselection
```

Selection semantics:

* explicit ID selection follows the order the author wrote;
* metadata selection follows declaration order in the bank;
* multiple filter keys combine with AND semantics;
* a tag filter requires every requested tag to be present on the record;
* `marks` uses exact numeric equality;
* selection commands append, and a record already selected is not added again,
  keeping its first selected position; and
* `\quizclearselection` starts a new selection and restores eligibility.

`\quizselectrandom` takes a positive integer count and a seed from 1 to
2147483646. The same bank, declaration order, existing selection state, filter,
count, and seed always produce the same ordered stable IDs. The implementation
uses a class-owned Park-Miller generator with Schrage's update, rejection
sampling, and a Fisher-Yates permutation; it depends on no clock, job name, or
engine random primitive. Its algorithm marker is `park-miller-v1`, and changing
that algorithm would be a documented compatibility change. Different seeds are
permitted to coincide by chance.

Errors are raised for unknown IDs, empty ID lists, empty metadata filters, an
empty selection at render time, invalid difficulty or marks filters, filters
matching nothing, non-positive or non-integer counts, out-of-range seeds, and
candidate pools too small for the requested count.

### Generated output

```latex
\printquizquestions[<columns>]
\printquizanswerkey
\printquiztopicreport
\printquizsolutions
\printquizteacherreport
```

All five consume only the current selection, in selection order, so booklet
numbering, answer-key numbering, solution numbering, topic reports, and mark
totals agree even when stable IDs are selected out of bank order.
`\printquizquestions` defaults to two columns. It also renders the established
constants box immediately after its section heading whenever `\quizconstants`
has been set, so a structured document does not call `\constantsbox` itself.
Manually authored quizzes continue to call `\constantsbox` directly and are
unaffected.

Place these inside the Phase 3 semantic gates. Each gate still governs whether
its section appears in the selected primary mode.

Two caveats follow from selection being document-global state. A gate that
changes the selection leaves that change in place for later gates, so a document
that filters inside its answer-key gate must re-select before printing
solutions. And `quizquestionbank` clears the current selection before printing,
so mixing it with explicit selection commands discards the earlier selection.

A generated 60-entry answer key is taller than one page;
`\printquizanswerkey` does not yet paginate a long key. Split a long key by
printing one band at a time, as
`examples/physicsquiz/PHY104_structured_revision.tex` does.

### Option shuffling

```latex
\quizshuffleoptions{<seed>}
\quizcorrectletter
```

*Stability: stable author interface. Regression-verified.*

`\quizshuffleoptions` permutes the five slots of the `\choices` interface for
every currently selected record. Call it after the selection is complete and
before anything is rendered: the permutation is computed up front so that an
`answerkey` compile, which typesets no booklet, still reports the letters of the
paper it belongs to.

A record's permutation derives from the seed and the record's declaration index
in the bank, not from its position in the selection, so the same bank, seed and
record always give the same permutation. The generator is the `park-miller-v1`
implementation already used by `\quizselectrandom`.

`\quizcorrectletter` expands to the effective answer letter for the record being
rendered: the shuffled letter when shuffling is active, the declared `correct`
key otherwise. Worked solutions should cite it rather than a literal letter.
Outside a rendered record it raises a class error.

Shuffling supports the five-option `\choices` interface. A record whose options
use `choiceoptions` raises a class error under shuffling, because the class
cannot know how many items the author will write. No option can be pinned to a
fixed position, so a bank containing none-of-the-above style options must not be
shuffled.

Calling `\quizshuffleoptions` twice, with an invalid seed, or with an empty
selection raises a class error. `\quizclearselection` discards the shuffle
along with the selection.

### Version manifest

```latex
\quizdefineversion{<label>}{<selection recipe>}
\quizuseversion{<label>}
```

*Stability: stable author interface. Regression-verified.*

A version names a selection recipe -- any combination of the selection commands,
optionally ending in `\quizshuffleoptions` -- and is activated by
`\quizuseversion`, which clears the current selection and shuffle, runs the
recipe, records the active label, and sets the Phase 3 `\quizversion` header
metadata. A version label therefore denotes a genuinely different paper rather
than a decoration.

One compile produces one version, which keeps pagination, question numbering and
the answer key unambiguous. The label argument is expanded, so a build script may
pass a macro. Duplicate labels, unknown labels, and a second `\quizuseversion`
in one document each raise a class error.

`\quizshuffleassert{<ordered letters>}` and `\quizversionassert{<label>}` are
advanced ecosystem hooks for regression fixtures.

### `quizquestionbank` compatibility wrapper

```latex
\begin{quizquestionbank}[<columns>]
  % quizquestion and quizsolution records
\end{quizquestionbank}
```

Declares, selects, and prints the records it encloses, with two columns by
default. It exists so that documents written against the Checkpoint 4C
interface need no rewrite. New documents should prefer the explicit
declare-then-select-then-print form.

### Regression assertions

```latex
\quizbankassert{<question count>}{<marks total>}
\quizselectionassert{<count>}{<marks>}{<ordered stable IDs>}
```

*Stability: advanced ecosystem hook.* These support project test fixtures.
Ordinary assessment documents do not need them, and they emit typeout markers
intended for the automated checkers rather than for readers.

## Answer-key environment

```latex
\begin{answerkey}
  <author-supplied answer-key content>
\end{answerkey}
```

The environment creates an unnumbered `Answer Key` heading and a styled container.
It does not calculate, collect, or validate answers automatically. Tables, lists,
and other answer-key content remain author supplied. The established representative
answer-key table is regression-verified.

## Theme palette

The following names are advanced theme hooks because representative quizzes and
class styling use them directly:

| Colour | Definition |
| --- | --- |
| `QuizNavy` | `#102A43` |
| `QuizBlue` | `#00008B` |
| `QuizLightBlue` | `#EFF6FF` |
| `QuizGreen` | `#166534` |
| `QuizGold` | `#DCD705` |
| `QuizGrey` | `#4B5563` |
| `QuizLightGrey` | `#F3F4F6` |

In `colour` mode, their names and values retain the table above. In `print` mode,
the same public names remain defined but map to high-contrast greys, allowing
existing document-owned styling to become print-friendly without changing colour
references. Authors may use these names with ordinary `xcolor` commands, but a
semantic class interface should be preferred where one exists.

## Internal and package-owned interfaces

The following are internal metadata storage and are not stable setters:

```latex
\QuizFontSize
\QuizBaselineSkip
\QuizTitle
\QuizAuthor
\QuizCourse
\QuizInstitution
\QuizInstructions
\QuizConstants
\QuizVersion
```

The internal mode, presentation, visibility, and version-state conditionals use
the private `\ifpq@...` namespace. Documents should use class options, semantic
gates, and public metadata commands rather than testing those internals directly.

Commands supplied by `siunitx` and other loaded packages remain package-owned. The
class-level `\unit{<unit>}` provision is only a compatibility safeguard when no
existing `\unit` command is available; authors should follow the active `siunitx`
contract for new unit formatting.

# `studentnotes.cls`

## Class declaration

```latex
\documentclass{studentnotes}
```

The class uses fixed 12-point A4 `article` settings. It does not currently expose a
class-option forwarding interface.

## Note metadata and title commands

| Command | Arguments | Default or effect |
| --- | ---: | --- |
| `\setnotetitle{<title>}` | 1 required | Replaces `Student Notes` |
| `\setnotecourse{<course>}` | 1 required | Replaces `Course` |
| `\setnoteauthor{<author>}` | 1 required | Replaces `Name` |
| `\setnotedate{<date>}` | 1 required | Replaces `\today` |
| `\makenotetitle` | none | Produces the configured note heading |
| `\usedotgrid` | none | Enables the dotted page background |

Example:

```latex
\documentclass{studentnotes}

\setnotetitle{Normal Modes in Coupled Systems}
\setnotecourse{PHY 104}
\setnoteauthor{OT}
\setnotedate{\today}
\usedotgrid

\begin{document}
\makenotetitle
\end{document}
```

The metadata setters, title command, and `\usedotgrid` are representative-use
verified. `\usedotgrid` should be called at most once: repeated calls can install
the shipout background repeatedly. The grid is intentionally drawing-intensive.

The commands `\notetitle`, `\notecourse`, `\noteauthor`, and `\notedate` are
metadata storage. Authors should change them through the corresponding setters.
`\dotgridbackground` is an implementation hook behind `\usedotgrid`, not the
preferred author command.

## Semantic note environments

| Environment | Syntax | Fixed title | Appearance |
| --- | --- | --- | --- |
| `quicknote` | `\begin{quicknote}...\end{quicknote}` | Quick Note | soft-yellow background, orange frame |
| `personalnote` | `\begin{personalnote}...\end{personalnote}` | Personal Note | soft-blue background, `NoteBlue` frame |
| `importantnote` | `\begin{importantnote}...\end{importantnote}` | Important | soft-green background, green frame |

These environments do not currently accept an optional replacement title. They are
non-splitting boxes: a short box moves intact when insufficient page space remains.
Their syntax, appearance, representative use, and page-boundary behaviour are
regression-verified.

## Theorem interfaces

| Environment | Printed name | Numbering |
| --- | --- | --- |
| `theorem` | Theorem | independent counter reset by section |
| `definition` | Definition | independent counter reset by section |
| `example` | Example | independent counter reset by section |

The environments follow ordinary `amsthm` syntax, including an optional heading:

```latex
\begin{theorem}[Pythagorean theorem]
  \label{thm:pythagoras}
  For a right-angled triangle,
  \[
    a^2+b^2=c^2.
  \]
\end{theorem}
```

Labels may be used with standard `\ref`, `\autoref`, and `\nameref` behaviour.
The three counters do not share a common sequence. Their independent numbering,
section resets, optional headings, and cross-references are regression-verified.

## Named-formula interface

```latex
\begin{namedformula}{<descriptive title>}
  <mathematical content>
  \label{<label>}
\end{namedformula}
```

The required descriptive-title argument forms part of the stable syntax. The
canonical Phase 2 interface:

* prints a tag in the form `F<section>.<formula>`;
* resets the formula counter at each section;
* keeps the descriptive title visually hidden;
* stores that title as reference metadata for `\nameref`;
* supports standard `\label` and `\ref` behaviour; and
* provides `\formularef{<label>}` for a reference matching the visible `F...` tag.

Example:

```latex
\begin{namedformula}{Energy of a simple harmonic oscillator}
  E=\frac{1}{2}m\omega^2A^2
  \label{formula:sho-energy}
\end{namedformula}

Formula \formularef{formula:sho-energy} gives the oscillator's energy.
Its descriptive name is \nameref{formula:sho-energy}.
```

The syntax, tags, section resets, `\formularef`, `\nameref`, and absence of
undefined references are regression-verified.

## Margin-note commands

| Command | Arguments | Output |
| --- | ---: | --- |
| `\notebox{<colour>}{<content>}` | 2 required | Generic small, ragged-right coloured margin note |
| `\refnote{<content>}` | 1 required | `Ref:` note in `NoteBlue` |
| `\theoremnote{<content>}` | 1 required | `Thm:` note in purple |
| `\formulanote{<content>}` | 1 required | `Formula:` note in dark red |
| `\remembernote{<content>}` | 1 required | `Remember:` note in dark green |

`\notebox` is an advanced generic interface; the semantic wrappers are preferred
for ordinary use. These commands use LaTeX margin-paragraph placement. Long content
can wrap tightly or collide with another nearby margin note, so authors should keep
margin notes concise. Their syntax and fixed labels are source-verified, while
`\refnote` and `\remembernote` also have representative uses.

## `WithArrows` helpers

These commands are stable convenience wrappers around the `witharrows` package's
`\Arrow` command and are intended for use inside `WithArrows`.

| Command | Inserted annotation |
| --- | --- |
| `\arrowcomment{<text>}` | plain annotation |
| `\stepnote{<text>}` | plain annotation; currently equivalent to `\arrowcomment` |
| `\steparrow{<text>}` | bold `Step:` prefix followed by the text |
| `\reasonarrow{<text>}` | bold `Reason:` prefix followed by the text |
| `\subarrow{<text>}` | bold `Substitute:` prefix followed by the text |

Example:

```latex
\[
\begin{WithArrows}
  kx &= m\omega^2x \reasonarrow{equation of motion} \\
  \omega^2 &= \frac{k}{m} \subarrow{divide by (mx)} \\
  \omega &= \sqrt{\frac{k}{m}} \steparrow{take the positive root}
\end{WithArrows}
\]
```

The argument shapes and prefixes are source-verified; `\arrowcomment` is also
representative-use verified.

## Vector helper

```latex
\colvec{<first component>}{<second component>}
```

This produces a two-row `bmatrix` column vector. It is specifically a
two-component helper, not a variable-length vector constructor. Its behaviour is
source-verified and representative-use verified.

## Theme palette

The following colour names are advanced theme hooks:

| Colour | Definition |
| --- | --- |
| `NoteBlue` | `RGB(30,80,160)` |
| `SoftBlue` | `RGB(235,245,255)` |
| `SoftYellow` | `RGB(255,249,220)` |
| `SoftGreen` | `RGB(235,250,235)` |
| `DotGrey` | `RGB(210,210,210)` |

Representative note sources use several of these names directly. Their names and
values therefore remain available during Phase 2.

## Naming and placement risks

The names `theorem`, `definition`, `example`, `notebox`, and `colvec` are generic
and may collide with other package or document definitions. They remain supported
for compatibility and must not be renamed during Phase 2. Margin-note commands also
depend on available margin space and should not be treated as ordinary in-text boxes.

# `otengineering.cls`

## Class declaration

```latex
\documentclass{otengineering}
```

The class uses fixed 11-point A4 `article` settings. It does not currently expose a
class-option forwarding interface.

## Project metadata commands

| Command | Arguments | Default |
| --- | ---: | --- |
| `\projectname{<name>}` | 1 required | `Untitled Project` |
| `\projectid{<identifier>}` | 1 required | `ENG-000` |
| `\projectversion{<version>}` | 1 required | `0.1` |
| `\projectstatus{<status>}` | 1 required | `Idea` |
| `\projectcategory{<category>}` | 1 required | `General Engineering` |
| `\projectstarted{<date>}` | 1 required | `\today` |
| `\projectupdated{<date>}` | 1 required | `\today` |
| `\makeprojectdashboard` | none | Produces the configured project dashboard |
| `\makeotengtitle` | none | Produces the notebook title followed by the dashboard |

The seven setters and two output commands are stable author interfaces. Setters
should normally appear in the preamble.

Example:

```latex
\documentclass{otengineering}

\projectname{Solar Charge Controller}
\projectid{ENG-POWER-01}
\projectversion{0.3}
\projectstatus{\statusprototype}
\projectcategory{Power Electronics}
\projectstarted{1 July 2026}
\projectupdated{5 August 2026}

\begin{document}
\makeotengtitle
\end{document}
```

Commands beginning with `\OTProject...` are internal metadata storage and are not
supported setters.

## Generic box interface

```latex
\begin{otbox}[<title>]{<frame colour>}
  <content>
\end{otbox}
```

`otbox` is an advanced author and ecosystem hook. The title is optional and the
frame colour is required. It retains the established light background, sharp
corners, border weight, and breakable behaviour. Ordinary authors should prefer a
semantic wrapper when one matches the content.

## Semantic environments

Every semantic environment accepts an optional replacement title:

```latex
\begin{decision}[<replacement title>]
  <content>
\end{decision}
```

| Environment | Default title | Default frame |
| --- | --- | --- |
| `idea` | Idea | `OTBlue` |
| `questionbox` | Engineering Question | `OTPurple` |
| `decision` | Design Decision | `OTGreen` |
| `experiment` | Experiment | `OTOrange` |
| `failure` | Failure / Problem | `OTRed` |
| `discovery` | Discovery | `OTPurple` |
| `lesson` | Lesson Learned | `OTGreen` |
| `futurememo` | Note to Future Self | `OTOrange` |
| `thought` | Random Thought | `OTMuted` |
| `rabbithole` | Rabbit Hole Tracker | `OTOrange` |
| `researchqueue` | Future Research Queue | `OTBlue` |
| `wisdom` | What I Wish I Knew Earlier | `OTGreen` |
| `risk` | Risk Register Entry | `OTRed` |
| `assumption` | Assumption Tracker | `OTOrange` |
| `calculation` | Engineering Calculation | `OTBlue` |

Example:

```latex
\begin{decision}[Selected Motor Driver]
  The prototype will use a driver rated above the measured starting current.
\end{decision}
```

The generic box, all fifteen wrappers, default and custom titles, established
colours, short-box movement, and long-box splitting are regression-verified.

## Calculation and sketch helpers

### `\calcfield`

```latex
\calcfield{<label>}{<content>}
```

This prints a bold label followed by the supplied content, ends the paragraph, and
adds the established vertical space. It is intended primarily inside `calculation`.

```latex
\begin{calculation}[Motor Current]
  \calcfield{Given}{\(V=12\,\mathrm{V}\), \(R=4\,\Omega\)}
  \calcfield{Calculation}{\(I=V/R\)}
  \calcfield{Result}{\(I=3\,\mathrm{A}\)}
\end{calculation}
```

The command is regression-verified with the `calculation` environment.

### `\sketchbox`

```latex
\sketchbox[<height>]{<content>}
```

The optional height defaults to `6cm`. The command produces a white, muted-frame,
centred box with the fixed title `Sketch Placeholder`. Its argument contract,
default height, and fixed title are source-verified.

## Status labels

The following zero-argument commands produce the corresponding value in bold:

| Command | Output text |
| --- | --- |
| `\statusseed` | Seed |
| `\statusconcept` | Concept |
| `\statusdesign` | Design |
| `\statusprototype` | Prototype |
| `\statustesting` | Testing |
| `\statusdeployment` | Deployment |
| `\statusarchived` | Archived |

They may be used as standalone labels or as values supplied to `\projectstatus`.
Their expansions are source-verified.

## Rating commands

| Command | Output pattern |
| --- | --- |
| `\successrating{<value>}` | **Success Rating:** `<value>/10` |
| `\confidencerating{<value>}` | **Confidence Rating:** `<value>/10` |
| `\pursuerating{<value>}` | **Worth Pursuing:** `<value>` |

The class formats but does not validate values. Authors are responsible for keeping
numeric ratings within the intended scale and for choosing consistent pursuit
values such as `Yes`, `No`, or `Revisit`. The expansions are source-verified.

## Field helpers

Each helper accepts one argument, prints a fixed bold label, and ends the paragraph.

| Command | Fixed label |
| --- | --- |
| `\entrydate{<content>}` | Date: |
| `\context{<content>}` | Context: |
| `\observation{<content>}` | Observation: |
| `\reason{<content>}` | Reason: |
| `\tradeoff{<content>}` | Trade-off: |
| `\nextstep{<content>}` | Next Step: |
| `\linkedproject{<content>}` | Linked Project: |

These helpers perform no storage, indexing, or automatic linking. Their labels and
expansions are source-verified.

## Theme palette

The `otengineering` palette is an advanced theme interface. Since Phase 5B, the
shared values are supplied by `ottheme.sty`; `otengineering.cls` deliberately
re-declares `OTLight` to keep its established notebook background.

| Colour | Definition |
| --- | --- |
| `OTDark` | `#1F2937` |
| `OTMuted` | `#6B7280` |
| `OTLight` | `#F3F4F6` |
| `OTBlue` | `#2563EB` |
| `OTGreen` | `#059669` |
| `OTOrange` | `#D97706` |
| `OTRed` | `#DC2626` |
| `OTPurple` | `#7C3AED` |

These names are shared with `otscience`, but the `OTLight` value is not identical
between the two classes. Code that depends on an exact background must use the
value belonging to the active class.

## Naming risks

The commands `\context`, `\observation`, `\reason`, and `\nextstep`, and the
environments `experiment` and `calculation`, have generic names. They remain
supported for backward compatibility but should not be copied into another class
or package without a deliberate namespace policy.

# `otscience.cls`

## Class declaration

```latex
\documentclass{otscience}
```

The class uses fixed 11-point A4 `article` settings. It does not currently expose a
class-option forwarding interface or class-owned title-metadata commands.

## Semantic box families

Every semantic environment accepts an optional replacement title.

| Breakable environment | Non-splitting environment | Default title | Frame |
| --- | --- | --- | --- |
| `definitionbox` | `definitionboxnosplit` | Definition | `OTBlue` |
| `theorembox` | `theoremboxnosplit` | Theorem | `OTPurple` |
| `lawbox` | `lawboxnosplit` | Law / Principle | `OTGreen` |
| `formulabox` | `formulaboxnosplit` | Formula | `OTTeal` |
| `derivationbox` | `derivationboxnosplit` | Derivation | `OTOrange` |
| `examplebox` | `exampleboxnosplit` | Worked Example | `OTGreen` |
| `warningbox` | `warningboxnosplit` | Common Mistake | `OTRed` |
| `intuitionbox` | `intuitionboxnosplit` | Intuition | `OTYellow` |
| `summarybox` | `summaryboxnosplit` | Key Summary | `OTDark` |
| `experimentbox` | `experimentboxnosplit` | Experiment / Observation | `OTPurple` |

Example:

```latex
\begin{formulabox}[Divergence in Cartesian Coordinates]
  \[
    \nabla\cdot\mathbf{A}
    =
    \frac{\partial A_x}{\partial x}
    +
    \frac{\partial A_y}{\partial y}
    +
    \frac{\partial A_z}{\partial z}.
  \]
\end{formulabox}
```

Breakable environments request enough space for a useful opening portion and may
continue across pages. Their `nosplit` counterparts are indivisible and move intact
when insufficient page space remains. All twenty wrappers, default and custom
titles, established colours, breakable continuation, and non-splitting movement are
regression-verified.

## Generic ecosystem box interfaces

These interfaces are supplied by `otboxes.sty`.

```latex
\begin{otscibox}[<title>]{<frame colour>}
  <content>
\end{otscibox}

\begin{otsciboxnosplit}[<title>]{<frame colour>}
  <content>
\end{otsciboxnosplit}
```

These are advanced ecosystem hooks. The frame colour is required; the title is
optional. `otscibox` is breakable and requests at least eight baseline lines before
starting. `otsciboxnosplit` is indivisible and requests at least twelve baseline
lines before starting. The requests guide page placement but do not reserve a fixed
box height.

Ordinary authors should prefer the semantic wrappers. Both generic interfaces and
their pagination behaviour are regression-verified.

## Shared class-support helpers

`otcore.sty` is a class-support package for shared OT page furniture and setup.
It is not intended as ordinary author syntax.

The class-facing helper commands are:

```latex
\otcorelistdefaults
\otcorepagestyle{<left head>}{<right head>}{<rule width>}
\otcoresectionstyles{<label separation>}{<subsubsection colour>}
```

`otscience.cls` and `otengineering.cls` pass different values to these helpers,
so their established visual identities remain separate.

## Theme palette

The science palette is an advanced theme interface supplied by `ottheme.sty`.

| Colour | Definition |
| --- | --- |
| `OTDark` | `#1F2937` |
| `OTMuted` | `#6B7280` |
| `OTLight` | `#F9FAFB` |
| `OTBlue` | `#2563EB` |
| `OTGreen` | `#059669` |
| `OTOrange` | `#D97706` |
| `OTRed` | `#DC2626` |
| `OTPurple` | `#7C3AED` |
| `OTTeal` | `#0891B2` |
| `OTYellow` | `#CA8A04` |

Companion packages, shared box packages, and workbook compatibility wrappers may
depend on these names. Since Checkpoint 5B, `otnotation`, `otmath`, and
`otfigures` load `ottheme` directly when they need these names. Since Checkpoint
5C, `otboxes` also loads `ottheme` directly for the base science box palette.
The science value of `OTLight` (`#F9FAFB`) differs from the engineering value
(`#F3F4F6`).

## `physics` and `siunitx` quantity compatibility

The class loads both `physics` and `siunitx`, which otherwise compete for the name
`\qty`. At `\begin{document}`, `otscience` deliberately makes `\qty` a copy of
`siunitx`'s `\SI` command.

Therefore, in an `otscience` document:

```latex
\qty{9.81}{\metre\per\second\squared}
```

follows the `siunitx` quantity contract. Authors who need the `physics` package's
automatic delimiter command should use its unambiguous `\quantity` form rather than
assuming `\qty` retains the `physics` meaning. This resolution is a documented
compatibility behaviour and should not be changed silently.

Other commands supplied by `physics` and `siunitx` remain package-owned interfaces.

## Companion-package boundary

`otscience.cls` loads `otboxes` directly for the shared base science boxes. It
conditionally loads these companion packages when they are available:

* `otnotation`;
* `otmath`;
* `ottensors`;
* `otphysics`;
* `otcoordinates`;
* `otpractice`; and
* `otfigures`.

Commands defined by those packages are ecosystem interfaces, not definitions owned
directly by `otscience.cls`. Their detailed APIs belong in separate companion-package
references. Because loading is conditional, an author must not infer that a
companion command exists merely from the class name without ensuring that the
relevant package is installed. `otnotation`, `otmath`, `otfigures`, `otboxes`,
and `otpractice` now load their shared dependencies directly.

`\standalonetitle`, `practicebox`, and `practiceboxnosplit` belong to the vector
workbook's `00_common_setup.tex` compatibility layer. They are not direct
`otscience.cls` interfaces. Their successful interaction with the class has been
regression-verified, but their contract must be documented with the workbook layer.

## Naming risks

The semantic science-box names are less collision-prone than the generic names in
the other classes, but `examplebox`, the two generic base-box names, and the shared
`OT...` colour names still require coordination with the wider OT ecosystem.

# Cross-class ownership and collision notes

| Name or family | Owner | Classification | Important qualification |
| --- | --- | --- | --- |
| `choiceoptions`, `\choices` | `physicsquiz` | stable | `\choices` is the five-option compatibility wrapper |
| `quizquestioncontent`, `quizanswerkeycontent`, `quizsolutioncontent`, `quizteachercontent`, `quizreferencecontent` | `physicsquiz` | stable | section gates controlled by the primary output mode |
| `\quizversion`, `\quizmarks`, `\quizdifficulty` | `physicsquiz` | stable | display-only Phase 3 metadata and labels; no question storage or mark calculation |
| `theorem`, `definition`, `example` | `studentnotes` | stable | generic names; independent section-based counters |
| `namedformula`, `\formularef` | `studentnotes` | stable | descriptive title remains visually hidden |
| `\notebox` | `studentnotes` | advanced | semantic margin-note wrappers are preferred |
| `otbox` | `otengineering` | advanced | semantic engineering wrappers are preferred |
| `otscibox`, `otsciboxnosplit` | `otboxes` | advanced | semantic science wrappers are preferred |
| `\otcorelistdefaults`, `\otcorepagestyle`, `\otcoresectionstyles` | `otcore` | advanced | class-support helpers, not ordinary author syntax |
| `OT...` colours | `ottheme` | advanced | `otengineering.cls` deliberately overrides `OTLight` to preserve its established `#F3F4F6` value |
| `practicebox`, `practiceboxnosplit` | vector-workbook setup | external to class | defined by `00_common_setup.tex` |
| `\standalonetitle` | vector-workbook setup | external to class | not defined by `otscience` |
| OT companion commands | individual `.sty` packages | external to class | loaded conditionally by `otscience` |
| `\qty` in `otscience` | compatibility rule | stable behaviour | resolves to the `siunitx`/`\SI` meaning at document start |

# Interfaces excluded from this document

This reference does not define contracts for:

* commands inherited unchanged from `article`;
* commands supplied by third-party packages, except where a class explicitly
  resolves a collision such as `otscience`'s `\qty` behaviour;
* detailed APIs in the seven OT companion packages;
* workbook-only wrappers in `00_common_setup.tex`;
* internal counters and hyperlink-anchor commands;
* uppercase or otherwise class-private metadata-storage commands;
* `expl3` internal functions and variables in the `__pq` namespace, and the
`PQ4C-` and `PQ4D-` typeout markers, which exist for the automated checkers
and may change with the tests;
* raw `xsim` commands, environments, keys, and properties, which back the
structured question interface as an implementation detail rather than a
`physicsquiz` author API;
* package loading order as a general author API; or
* incidental visual implementation details that do not affect documented public
  behaviour.

# Maintenance checklist

When changing any class interface documented here:

1. identify all representative and test call sites;
2. preserve existing syntax and defaults unless a migration is explicitly approved;
3. add or update isolated regression coverage;
4. rebuild representative documents;
5. inspect rendered pagination when layout behaviour is affected;
6. update this reference and the changelog in the same checkpoint; and
7. record any deprecation, collision, or migration requirement before release.
