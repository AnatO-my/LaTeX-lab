% ============================================================
% OT Engineering Notebook Class
% Version: 0.1
% Purpose: Informal engineering design + personal R&D notebook
% ============================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{otengineering}[2026/06/09 OT Engineering Notebook Class]

% ============================================================
% 1. Base Class
% ============================================================

\LoadClass[11pt,a4paper]{article}

% ============================================================
% 2. Required Packages
% ============================================================

\RequirePackage{otcore}
\RequirePackage{tcolorbox}
\RequirePackage{amssymb}
\RequirePackage{amsmath}
\RequirePackage{ottheme}

% otengineering keeps its slightly darker notebook background while sharing the
% rest of the OT palette with otscience.
\definecolor{OTLight}{HTML}{F3F4F6}

\tcbuselibrary{skins,breakable}

% ============================================================
% 5. Page Style
% ============================================================

\otcorepagestyle
    {\textbf{OT Engineering Notebook}}
    {\leftmark}
    {0.4pt}

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
        \begin{tabularx}{\textwidth}{>{\bfseries}l X}
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
% 9. Base Box Style
% ============================================================

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

% ============================================================
% 10. Core Engineering Environments
% ============================================================

\newenvironment{idea}[1][Idea]
{\begin{otbox}[#1]{OTBlue}}
{\end{otbox}}

\newenvironment{questionbox}[1][Engineering Question]
{\begin{otbox}[#1]{OTPurple}}
{\end{otbox}}

\newenvironment{decision}[1][Design Decision]
{\begin{otbox}[#1]{OTGreen}}
{\end{otbox}}

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

\newenvironment{risk}[1][Risk Register Entry]
{\begin{otbox}[#1]{OTRed}}
{\end{otbox}}

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
% End of Class
% ============================================================
