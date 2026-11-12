# Project report and notebook example

Both entry points use project-records.tex and project-body.tex.

- report.tex: formal report; organisations hidden; optional sign-off displayed.
- notebook.tex: working notebook; organisations hidden; sign-off omitted.

This is a draft OAU EEE planning example, not an approved report or evidence of
implementation. Prices, assignments and approvals remain unconfirmed.
The USD cost record illustrates formatting only.

Build from the LaTeX-lab root with its .latexmkrc:

    latexmk -pdf examples/otengineering/projects/report.tex
    latexmk -pdf examples/otengineering/projects/notebook.tex

See docs/OT_PROJECTS.md for the package interface and test command.

