% ============================================================
% OT Engineering Notebook Class
% Version: 0.3
% Purpose: Informal engineering design + personal R&D notebook
% ============================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{otengineering}[2026/09/28 v0.3 OT Engineering Notebook Class]

% ============================================================
% 1. Base Class
% ============================================================

\newif\ifoteng@eeereport
\DeclareOption{eee-report}{\oteng@eeereporttrue}
\DeclareOption*{%
  \ifoteng@eeereport\PassOptionsToClass{\CurrentOption}{extbook}%
  \else\PassOptionsToClass{\CurrentOption}{article}\fi}
\ProcessOptions\relax
\ifoteng@eeereport
  \LoadClass[14pt,a4paper,oneside,openany]{extbook}
\else
  \LoadClass[11pt,a4paper]{article}
\fi

% ============================================================
% 2. Required Packages
% ============================================================

\RequirePackage{otcore}
\RequirePackage{tcolorbox}
\RequirePackage{amssymb}
\RequirePackage{amsmath}
\RequirePackage{ottheme}
\RequirePackage{marginnote}
\RequirePackage{tabularx}
\RequirePackage{hyperref}
\RequirePackage{etoolbox}

% Optional companion packages are loaded explicitly by the document.
% This keeps output independent of which extra packages happen to be installed.

\tcbuselibrary{skins,breakable}

% ============================================================
% 5. Page Style
% ============================================================

\otcorepagestyle
    {\textbf{OT Engineering Notebook}}
    {\parbox[b]{0.55\textwidth}{\raggedleft\small\leftmark}}
    {0.4pt}
\setlength{\headheight}{28pt}

% ============================================================
% 6. Section Styling
% ============================================================

\otcoresectionstyles{1em}{OTMuted}

% ============================================================
% 7. Project Metadata Commands
% ============================================================

\newcommand{\projectname}[1]{\def\OTProjectName{#1}}
\newcommand{\projectid}[1]{\def\OTProjectID{#1}}
\newcommand{\projectversion}[1]{\def\OTProjectVersion{#1}}
\newcommand{\projectstatus}[1]{\def\OTProjectStatus{#1}}
\newcommand{\projectcategory}[1]{\def\OTProjectCategory{#1}}
\newcommand{\projectstarted}[1]{\def\OTProjectStarted{#1}}
\newcommand{\projectupdated}[1]{\def\OTProjectUpdated{#1}}

\projectname{Untitled Project}
\projectid{ENG-000}
\projectversion{0.1}
\projectstatus{Idea}
\projectcategory{General Engineering}
\projectstarted{\today}
\projectupdated{\today}

% ============================================================
% 8. Project Dashboard
% ============================================================

\newcommand{\makeprojectdashboard}{
    \begin{tcolorbox}[
            enhanced,
            breakable,
            colback=OTLight,
            colframe=OTDark,
            title=\textbf{Project Dashboard},
            fonttitle=\large\bfseries
        ]
        \begin{tabularx}{\linewidth}{>{\bfseries}l X}
            Project Name: & \OTProjectName     \\
            Project ID:   & \OTProjectID       \\
            Version:      & \OTProjectVersion  \\
            Status:       & \OTProjectStatus   \\
            Category:     & \OTProjectCategory \\
            Started:      & \OTProjectStarted  \\
            Last Updated: & \OTProjectUpdated  \\
        \end{tabularx}
    \end{tcolorbox}
}

% ============================================================
% 9. Base Box Style and Registry Infrastructure
% ============================================================

% Read the previous completed run before opening new output streams.
% Cached tokens allow registers to be printed repeatedly, including in front matter.
\newwrite\otdecisionlog
\newwrite\otrisklog
\newcommand{\oteng@decisions}{}
\newcommand{\oteng@risks}{}
\AtBeginDocument{%
    \begingroup
        \long\def\otlogentry#1#2#3{%
            \gappto\oteng@decisions{\otlogentry{#1}{#2}{#3}}}%
        \InputIfFileExists{\jobname.decisions}{}{}%
    \endgroup
    \begingroup
        \long\def\otlogentry#1#2#3{%
            \gappto\oteng@risks{\otlogentry{#1}{#2}{#3}}}%
        \InputIfFileExists{\jobname.risks}{}{}%
    \endgroup
    \immediate\openout\otdecisionlog=\jobname.decisions
    \immediate\openout\otrisklog=\jobname.risks
}
% Flush deferred page writes before closing either stream.
\AtEndDocument{%
    \clearpage
    \immediate\closeout\otdecisionlog
    \immediate\closeout\otrisklog
}
\newcommand{\oteng@record}[3]{%
    % This write node is placed INSIDE the box, so its page is the shipped page.
    \protected@write#1{}{\string\otlogentry{#2}{#3}{\thepage}}%
}

% Status markers
\newcommand{\otstatusmarker}[1]{%
    \marginnote{\footnotesize #1}%
}

\newtcolorbox{otbox}[2][]{
    enhanced,
    breakable,
    colback=OTLight,
    colframe=#2,
    fonttitle=\bfseries,
    title=#1,
    sharp corners,
    boxrule=0.8pt
}

% Style for registry entries
\tcbset{
    ot-registry-style/.style={
        enhanced,
        breakable,
        colback=white,
        colframe=OTMuted,
        boxrule=0.5pt,
        fontupper=\small,
        top=2pt,
        bottom=2pt,
        left=4pt,
        right=4pt,
        before skip=4pt,
        after skip=4pt
    }
}

% ============================================================
% 10. Core Engineering Environments
% ============================================================

\newenvironment{idea}[1][Idea]
{\begin{otbox}[#1]{OTBlue}}
{\end{otbox}}

\newenvironment{questionbox}[1][Engineering Question]
{\begin{otbox}[#1]{OTPurple}}
{\end{otbox}}

\NewDocumentEnvironment{decision}{O{Design Decision} O{}}{%
    \begin{otbox}[#1]{OTGreen}%
    \oteng@record{\otdecisionlog}{#1}{#2}%
    \ifstrempty{#2}{}{\otstatusmarker{\textbf{Status:} #2}}%
}{%
    \end{otbox}%
}

\newenvironment{experiment}[1][Experiment]
{\begin{otbox}[#1]{OTOrange}}
{\end{otbox}}

\newenvironment{failure}[1][Failure / Problem]
{\begin{otbox}[#1]{OTRed}}
{\end{otbox}}

\newenvironment{discovery}[1][Discovery]
{\begin{otbox}[#1]{OTPurple}}
{\end{otbox}}

\newenvironment{lesson}[1][Lesson Learned]
{\begin{otbox}[#1]{OTGreen}}
{\end{otbox}}

\newenvironment{futurememo}[1][Note to Future Self]
{\begin{otbox}[#1]{OTOrange}}
{\end{otbox}}

% ============================================================
% 11. Informal R&D Environments
% ============================================================

\newenvironment{thought}[1][Random Thought]
{\begin{otbox}[#1]{OTMuted}}
{\end{otbox}}

\newenvironment{rabbithole}[1][Rabbit Hole Tracker]
{\begin{otbox}[#1]{OTOrange}}
{\end{otbox}}

\newenvironment{researchqueue}[1][Future Research Queue]
{\begin{otbox}[#1]{OTBlue}}
{\end{otbox}}

\newenvironment{wisdom}[1][What I Wish I Knew Earlier]
{\begin{otbox}[#1]{OTGreen}}
{\end{otbox}}

% ============================================================
% 12. Risk and Assumption Tracking
% ============================================================

\NewDocumentEnvironment{risk}{O{Risk Register Entry} O{}}{%
    \begin{otbox}[#1]{OTRed}%
    \oteng@record{\otrisklog}{#1}{#2}%
    \ifstrempty{#2}{}{\otstatusmarker{\textbf{Status:} #2}}%
}{%
    \end{otbox}%
}

\newenvironment{assumption}[1][Assumption Tracker]
{\begin{otbox}[#1]{OTOrange}}
{\end{otbox}}

% ============================================================
% 13. Engineering Calculation Template
% ============================================================

\newenvironment{calculation}[1][Engineering Calculation]
{\begin{otbox}[#1]{OTBlue}}
{\end{otbox}}

\newcommand{\calcfield}[2]{
    \textbf{#1:} #2\par\vspace{0.5em}
}

% ============================================================
% 14. Sketch Placeholder
% ============================================================

\newcommand{\sketchbox}[2][6cm]{
    \begin{tcolorbox}[
            enhanced,
            colback=white,
            colframe=OTMuted,
            height=#1,
            valign=center,
            halign=center,
            title=\textbf{Sketch Placeholder}
        ]
        #2
    \end{tcolorbox}
}

% ============================================================
% 15. Status and Maturity Labels
% ============================================================

\newcommand{\statusseed}{\textbf{Seed}}
\newcommand{\statusconcept}{\textbf{Concept}}
\newcommand{\statusdesign}{\textbf{Design}}
\newcommand{\statusprototype}{\textbf{Prototype}}
\newcommand{\statustesting}{\textbf{Testing}}
\newcommand{\statusdeployment}{\textbf{Deployment}}
\newcommand{\statusarchived}{\textbf{Archived}}

% ============================================================
% 16. Rating Commands
% ============================================================

\newcommand{\successrating}[1]{\textbf{Success Rating:} #1/10\par}
\newcommand{\confidencerating}[1]{\textbf{Confidence Rating:} #1/10\par}
\newcommand{\pursuerating}[1]{\textbf{Worth Pursuing:} #1\par}

% ============================================================
% 17. Common Field Helpers
% ============================================================

\newcommand{\entrydate}[1]{\textbf{Date:} #1\par}
\newcommand{\context}[1]{\textbf{Context:} #1\par}
\newcommand{\observation}[1]{\textbf{Observation:} #1\par}
\newcommand{\reason}[1]{\textbf{Reason:} #1\par}
\newcommand{\tradeoff}[1]{\textbf{Trade-off:} #1\par}
\newcommand{\nextstep}[1]{\textbf{Next Step:} #1\par}
\newcommand{\linkedproject}[1]{\textbf{Linked Project:} #1\par}

% ============================================================
% 18. Document Title Helper
% ============================================================

\newcommand{\makeotengtitle}{
    \begin{center}
        {\Huge\bfseries \OTProjectName \par}
        \vspace{0.5em}
        {\Large Engineering Notebook \par}
        \vspace{0.5em}
        {\normalsize Project ID: \OTProjectID \quad Version: \OTProjectVersion \par}
        \vspace{1em}
    \end{center}
    \makeprojectdashboard
    \vspace{1em}
}

% ============================================================
% 19. Project Registry Printing
% ============================================================

\newcommand{\otlogentry}[3]{%
    \begin{tcolorbox}[ot-registry-style, title={#1}]
        \textbf{Status:} \ifstrempty{#2}{Not specified}{#2} \hfill \textbf{Page:} #3
    \end{tcolorbox}
}

\newcommand{\printprojectdecisionlog}[1][Project Decision Log]{%
    \section*{#1}%
    \ifdefempty{\oteng@decisions}{%
        \begin{otbox}[No Decisions Recorded]{OTMuted}
            No entries are available from the previous run.
            After adding or removing entries, compile until the registers settle.
        \end{otbox}%
    }{%
        \oteng@decisions
    }%
}

\newcommand{\printprojectriskregister}[1][Project Risk Register]{%
    \section*{#1}%
    \ifdefempty{\oteng@risks}{%
        \begin{otbox}[No Risks Recorded]{OTMuted}
            No entries are available from the previous run.
            After adding or removing entries, compile until the registers settle.
        \end{otbox}%
    }{%
        \oteng@risks
    }%
}

\newcommand{\makeprojectstatusreport}{%
    \begin{tcolorbox}[
        enhanced,
        colback=OTLight,
        colframe=OTPurple,
        title=\textbf{Project Status Report},
        fonttitle=\bfseries
    ]
        This notebook contains design decisions and risks tracked in the back matter.
        Current project status: \OTProjectStatus.
    \end{tcolorbox}%
}

% ============================================================
% End of Class
% ============================================================
\ifoteng@eeereport\RequirePackage{oteeereport}\fi
