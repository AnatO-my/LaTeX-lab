# EEE departmental report

Use `\documentclass[eee-report]{otengineering}`. Ordinary engineering notebooks
retain their article base; the report option uses extbook and automatically loads
oteeereport. Existing engineering helpers remain available.

See `examples/otengineering/eee_report_example.tex` for cover metadata, ordered
prefatory lists, abstract, chapters, booktabs tables, figures, plates, IEEE
references and appendices. Compile with pdfLaTeX, Biber, then pdfLaTeX twice.
Use the report's biblatex directly; do not load otbib (its numeric-comp default
would conflict with the IEEE report bibliography).

`\oteeereportsetup{left=1.5in,right=1in,top=1in,bottom=1in}` centralizes margins.
These are provisional defaults pending exact department dimensions. The report
defaults to one-sided pages; `twoside` uses the wider inner binding margin.

`\oteeereportsetup{table-start=0,figure-start=0,plate-start=0}` switches displayed
float numbers to .0 in every chapter, including appendices. Defaults are 1.
Set these keys in the preamble, before any captions; values other than 0/1 are
rejected. Real counters and hyperlink destinations remain distinct.

`\frontmatter` starts lowercase Roman numbering at i, bottom-centred.
`\mainmatter` starts Arabic numbering at 1, top-centred, including chapter
opening pages. The cover has no page number. Major headings and chapter TOC
entries are uppercased; subordinate titles retain the supplied capitalization.
Chapter names and chapter count are unrestricted.

Body text is exactly 14pt with double spacing. Cover names are 12pt; other cover
text is 14pt. Bibliography entries and quotations remain double spaced. Table
contents and float captions use single spacing. Use booktabs top/mid/bottom
rules with column specifications such as `ll` or `lX` without vertical bars;
the package does not rewrite user-authored table column specifications.

Run `tests/run_eee_report_tests.ps1` to compile both numbering policies with
Biber and check float references and duplicate PDF destinations. Also run
`tests/run_engineering_tests.ps1` for notebook regression coverage.
