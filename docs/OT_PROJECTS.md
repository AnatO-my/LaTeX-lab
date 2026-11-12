# ot-projects v0.1

Additive project records and report/notebook views for otengineering.
Requires LaTeX2e 2022-06-01 or newer, the local otengineering class, longtable,
needspace, array and hyperref. Load the package explicitly:

    \documentclass{otengineering}
    \usepackage{ot-projects}
    \OTProjectSetup{style=report,show-organisations=false,show-signoff=true}

The first version has printable sign-off fields, not digital signatures or interactive forms.
It performs no budget arithmetic, exchange-rate lookup, scheduling or approval automation.

## One record set, two styles

Use the existing class setters: \projectname, \projectid, \projectversion,
\projectstatus, \projectcategory, \projectstarted and \projectupdated.
Use \OTMakeProjectTitle to show the corresponding report/notebook heading and dashboard.

Declare records in the preamble, usually in a shared records.tex file. Print them later.
The package stores these records in memory, so registers can appear before detailed
entries without copying data into a second table. Ordinary LaTeX cross-references
still need repeat compilation.

    \OTWorkstream[status=Planned]{WS-A}{Software}{Records platform.}
    \OTRequirement[
      workstream=WS-A,
      owner={Software lead},
      status=Draft,
      acceptance={An unauthorised identity match does not grant access.},
      related={TEST-01}
    ]{REQ-01}{Separate identity from access}{Describe the requirement here.}
    \OTTest[
      workstream=WS-A,
      related={REQ-01},
      result={Not run},
      method={Synthetic identity events}
    ]{TEST-01}{Access boundary test}{Describe the planned test here.}

    \begin{document}
    \OTMakeProjectTitle
    \OTPrintRegister{requirement}
    \OTPrintRecords{requirement}
    \OTPrintRecords{test}
    \end{document}

For a notebook, use style=notebook. Record content and meaning are unchanged:
report style uses plain headings and paragraphs; notebook style uses the existing
breakable OT boxes. No change to otengineering.cls is required.

## Record declarations

Each declaration takes optional fields, a stable ID, a title and a paragraph body:

    \OTRequirement[fields]{ID}{Title}{Body}

| Declaration | Print type | Purpose |
|---|---|---|
| \OTWorkstream | workstream | Software, hardware, integration or other streams |
| \OTRequirement | requirement | Requirement, owner, status and acceptance criteria |
| \OTPerson | person | Roles, individuals and organisations |
| \OTMaterial | material | Materials/BOM, quantities, supplier and unit cost |
| \OTCost | cost | Manually entered planned/actual line totals and currencies |
| \OTMilestone | milestone | Stage, dependencies and exit criteria |
| \OTAlternative | alternative | Advantages, disadvantages and rationale |
| \OTProblem | problem | Problem description and proposed/verified resolution |
| \OTTest | test | Method, acceptance, result and evidence |
| \OTEvidence | evidence | Source provenance and validation status |
| \OTRevision | revision | Version, date and change description |
| \OTSignatory | signatory | Name and optional signing title/capacity |

\OTSignatory is the exception: it takes [fields]{ID}{Name}, without a body.
A blank name is allowed and produces a blank line.

IDs are case-sensitive, start with a letter, and otherwise contain only letters,
digits or hyphens. IDs are unique across all types. Use stable IDs rather than
automatically renumbering requirements when another record is inserted.

Unknown fields, duplicate/invalid IDs, unknown related/dependency references and
unknown/non-workstream workstream IDs are errors. Forward references are allowed
because validation runs after all preamble declarations.

## Fields

Fields containing commas must be braced; bodies may contain paragraphs, lists,
math and ordinary robust LaTeX formatting.

| Fields | Meaning |
|---|---|
| workstream | ID of a declared workstream |
| owner, status, date, source | Owner and provenance; status defaults to Not specified |
| related, depends-on | Braced comma-separated lists of package record IDs |
| acceptance, method, result, evidence | Requirement/test criteria and supporting evidence |
| pros, cons, rationale | Alternative comparison |
| resolution | Proposed or verified resolution; distinguish these in status/body |
| version | Revision/version text |
| category | For people: role (default), individual or organisation |
| role, organisation | Optional people metadata |
| quantity, unit, unit-cost, supplier | BOM metadata; unknown values may remain TBD |
| currency, planned, actual | Three-letter currency and manually supplied line totals |
| rate, rate-date, rate-source | Manual NGN-per-foreign-unit rate and provenance |
| native-planned, native-actual | Manually supplied NGN equivalents for foreign costs |
| title, capacity, signature | Signatory's job title, signing capacity and optional signature text |

Owners, dates and source fields are display text; the package does not assert that
a person, source or institutional approval has been verified. Use \url or \href for
external sources. Only related, depends-on and workstream are validated record links.
Self-dependencies are rejected, but scheduling and general dependency-cycle analysis
are outside v0.1.

## Printing and references

- \OTPrintRegister{type}: automatically generated summary with ID, title,
  workstream/category and status. It spans pages with repeated headers.
- \OTPrintRecords{type}: detailed records in declaration order.
- \OTPrintRegister[workstream=WS-A]{requirement}: summary filtered by workstream.
- \OTPrintRecords[workstream=WS-A]{requirement}: filtered details.
- \OTRecordRef{REQ-01}: displays the stable ID and links to its first printed
  occurrence once the auxiliary references have settled.
- \OTPrintSignoffs: optional name/title/signature/date blocks.

Empty views produce no heading or blank register. Repeated views do not redefine
record IDs or create duplicate PDF destinations. The first printed occurrence is
the link target, whether it is a summary row or a detailed record.

A reference to a known but unprinted or hidden record is plain text rather than
a guaranteed PDF link. Print the corresponding view if a navigable target is needed.
Use ordinary LaTeX labels/hyperref for existing class environments; those are not
redeclared as package records.

## People categories

All three categories are supported. Empty categories are omitted automatically.
The following settings independently control them:

    \OTProjectSetup{
      show-roles=true,
      show-individuals=true,
      show-organisations=false
    }

Hiding organisations removes both organisation-category entries and organisation
metadata from the package's detailed views. The underlying record remains available
in the source. This is a presentation setting, not an anonymisation/redaction system.
Text you write independently in the report is not automatically hidden.

    \OTPerson[category=role,status=Unassigned]{ROLE-01}{Project lead}{Responsibilities.}
    \OTPerson[category=individual,role={Project lead}]{PER-01}{Example name}{Responsibilities.}
    \OTPerson[category=organisation]{ORG-01}{Department name}{Context.}

## Costs and manual exchange rates

NGN is the default. The package displays amounts exactly as supplied and does not
treat blanks/TBD as zero. Planned and actual are line totals, not unit prices;
quantity is descriptive and is not multiplied automatically. No grand total is generated.

    \OTCost[planned={120,000},actual=TBD]
      {COST-01}{Native line item}{Estimate awaiting confirmation.}

For a foreign line item, specify currency. A missing manual rate is allowed, but the
PDF explicitly states that no NGN conversion is supplied.

    \OTCost[currency=USD,planned=TBD,actual=TBD]
      {COST-02}{Imported item}{No quote or rate yet.}

When entering a rate, provide a positive number, date and source. Its direction is
always NGN per 1 foreign currency unit. Any NGN equivalents are manually entered:

    % Synthetic illustration only; not a current market rate.
    \OTCost[
      currency=USD,
      planned=100,
      actual=80,
      rate=1500,
      rate-date={2026-09-28},
      rate-source={Illustrative manual rate},
      native-planned={150,000},
      native-actual={120,000}
    ]{COST-03}{Foreign example}{All amounts are illustrative.}

Native equivalents without rate provenance are errors. A rate on an NGN record is
also an error. The package validates rate syntax/provenance, not whether manually
entered amounts are mathematically consistent or commercially accurate. Keep
shipping, taxes and other charges as separate line items when relevant.

## Optional sign-off

Sign-off is off by default. Enable it when needed:

    \OTProjectSetup{show-signoff=true}
    \OTSignatory[
      title={Head of Department},
      capacity={Reviewed by}
    ]{SIG-01}{Name of signatory}
    \OTSignatory[capacity={Prepared by}]{SIG-02}{}

Call \OTPrintSignoffs in the document. Multiple signatories are supported.
Name, title, date and signature can be omitted, leaving fillable-by-hand lines.
Typing a name/title does not change project status or mark a report approved.
The term used is "signatory".

## Existing engineering features

Continue using decision, risk, assumption, experiment, failure, lesson and their
class helpers. The new package neither replaces these interfaces nor duplicates
their decision/risk registers. If printing those older registers, follow their
previous-run compilation rules in ENGINEERING_REGISTRY_COMPATIBILITY.md.

## Examples and build

examples/otengineering/projects contains:

- project-records.tex: one shared OAU planning record set.
- project-body.tex: one shared narrative and selected views.
- report.tex: formal view, organisation category hidden, sign-off enabled.
- notebook.tex: notebook view, organisation category hidden, sign-off disabled.

The OAU examples are draft planning demonstrations. The foreign-currency line is
explicitly a format example; no rate, quote, personnel appointment or approval is invented.

From the repository root, with the existing MiKTeX/latexmk setup:

    latexmk -pdf examples/otengineering/projects/report.tex
    latexmk -pdf examples/otengineering/projects/notebook.tex

Regression checks use Python with pypdf and an installed pdfLaTeX:

    ./tests/run_projects_tests.ps1 -PdfLatex pdflatex -Python python

Executable paths may be supplied explicitly. Test outputs are isolated in a fresh
build directory by default. This is a multi-file custom-package project, so use
the repository build configuration rather than a standalone-document compiler.

## Version boundary

v0.1 provides printable views and validation of identifiers and required provenance.
It does not include automatic currency conversion, budget totals, scheduling,
digital signatures, interactive form creation, a database export, or an automatic
Markdown-to-LaTeX synchronisation step. Source content remains under author control.

