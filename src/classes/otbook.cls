% ============================================================
% OT Personal Book Class
% otbook.cls
% Version: 0.2
% ============================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{otbook}[2026/09/09 v0.2 OT Personal Book Class]

% -----------------------------
% Base class
% -----------------------------
\newif\ifotbook@chaptertheorems\otbook@chaptertheoremsfalse
\DeclareOption{chaptertheorems}{\otbook@chaptertheoremstrue}

\PassOptionsToClass{11pt,a4paper,oneside}{book}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
\LoadClass{book}

\ifotbook@chaptertheorems
  \PassOptionsToPackage{theorems=chapter}{otmath}
\fi

% -----------------------------
% Core packages
% -----------------------------
\RequirePackage{otcore}
\geometry{
  marginparwidth=1.8cm,
  marginparsep=0.4cm
}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{lmodern}
\RequirePackage{microtype}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{mathtools}
\RequirePackage{amsthm}
\RequirePackage{physics}
\RequirePackage{siunitx}

% Restore siunitx's \qty after physics has taken it.
\AtBeginDocument{\RenewCommandCopy\qty\SI}
\ExplSyntaxOn
\msg_redirect_name:nnn { siunitx } { physics-pkg } { none }
\ExplSyntaxOff

\RequirePackage{bm}
\RequirePackage{tikz}
\RequirePackage{graphicx}
\RequirePackage{booktabs}
\RequirePackage{needspace}
\RequirePackage{ottheme}
\RequirePackage{otboxes}
\RequirePackage{cleveref}

\tcbuselibrary{theorems,listings}

% -----------------------------
% Global settings
% -----------------------------
\sisetup{
  per-mode=symbol,
  separate-uncertainty=true,
  detect-all=true
}

\otcorelistdefaults

% -----------------------------
% Page style
% -----------------------------
\otcorepagestyle
  {\textcolor{OTMuted}{OT Book}}
  {\textcolor{OTMuted}{\leftmark}}
  {0.3pt}

% -----------------------------
% Chapter and section style
% -----------------------------
\titleformat{\chapter}[display]
  {\Huge\bfseries\color{OTDark}}
  {\textcolor{OTBlue}{\chaptertitlename\ \thechapter}}
  {0.5em}
  {}

\titlespacing*{\chapter}{0pt}{-10pt}{2.5em}

\otcoresectionstyles{0.75em}{OTPurple}

% -----------------------------
% Book metadata and title page
% -----------------------------
\makeatletter
\let\OTBookSubtitle\@empty
\let\OTBookEdition\@empty
\newcommand{\booksubtitle}[1]{\gdef\OTBookSubtitle{#1}}
\newcommand{\bookedition}[1]{\gdef\OTBookEdition{#1}}

\newcommand{\makeotbooktitle}{
  \begin{titlepage}
    \centering
    \vspace*{0.16\textheight}
    {\color{OTBlue}\rule{0.72\textwidth}{1.2pt}\par}
    \vspace{1.5cm}
    {\Huge\bfseries\color{OTDark}\@title\par}
    \ifx\OTBookSubtitle\@empty
    \else
      \vspace{0.5cm}
      {\Large\color{OTMuted}\OTBookSubtitle\par}
    \fi
    \vspace{1.5cm}
    {\Large\color{OTDark}\@author\par}
    \ifx\OTBookEdition\@empty
    \else
      \vspace{0.5cm}
      {\normalsize\color{OTMuted}\OTBookEdition\par}
    \fi
    \vfill
    {\color{OTBlue}\rule{0.72\textwidth}{1.2pt}\par}
    \vspace{0.8cm}
    {\normalsize\color{OTMuted}\@date\par}
  \end{titlepage}
}

\newcommand{\makeotbookdedication}[1]{
  \thispagestyle{empty}
  \vspace*{0.38\textheight}
  \begin{flushright}
    \itshape #1
  \end{flushright}
  \clearpage
}

\newcommand{\otbookepigraph}[2]{
  \par\medskip
  \noindent\hfill
  \begin{minipage}{0.68\textwidth}
    \itshape #1\par
    \vspace{0.5em}
    \raggedleft --- #2
  \end{minipage}\par\medskip
}
\makeatother

% -----------------------------
% Standard OT book boxes
% -----------------------------
\newenvironment{definitionbox}[1][Definition]
{\begin{otscibox}[#1]{OTBlue}}{\end{otscibox}}

\newenvironment{definitionboxnosplit}[1][Definition]
{\begin{otsciboxnosplit}[#1]{OTBlue}}{\end{otsciboxnosplit}}

\newenvironment{theorembox}[1][Theorem]
{\begin{otscibox}[#1]{OTPurple}}{\end{otscibox}}

\newenvironment{theoremboxnosplit}[1][Theorem]
{\begin{otsciboxnosplit}[#1]{OTPurple}}{\end{otsciboxnosplit}}

\newenvironment{lawbox}[1][Law / Principle]
{\begin{otscibox}[#1]{OTGreen}}{\end{otscibox}}

\newenvironment{lawboxnosplit}[1][Law / Principle]
{\begin{otsciboxnosplit}[#1]{OTGreen}}{\end{otsciboxnosplit}}

\newenvironment{formulabox}[1][Formula]
{\begin{otscibox}[{#1}]{OTTeal}}{\end{otscibox}}

\newenvironment{formulaboxnosplit}[1][Formula]
{\begin{otsciboxnosplit}[{#1}]{OTTeal}}{\end{otsciboxnosplit}}

\newenvironment{derivationbox}[1][Derivation]
{\begin{otscibox}[#1]{OTOrange}}{\end{otscibox}}

\newenvironment{derivationboxnosplit}[1][Derivation]
{\begin{otsciboxnosplit}[#1]{OTOrange}}{\end{otsciboxnosplit}}

\newenvironment{examplebox}[1][Worked Example]
{\begin{otscibox}[#1]{OTGreen}}{\end{otscibox}}

\newenvironment{exampleboxnosplit}[1][Worked Example]
{\begin{otsciboxnosplit}[#1]{OTGreen}}{\end{otsciboxnosplit}}

\newenvironment{warningbox}[1][Common Mistake]
{\begin{otscibox}[#1]{OTRed}}{\end{otscibox}}

\newenvironment{warningboxnosplit}[1][Common Mistake]
{\begin{otsciboxnosplit}[#1]{OTRed}}{\end{otsciboxnosplit}}

\newenvironment{intuitionbox}[1][Intuition]
{\begin{otscibox}[#1]{OTYellow}}{\end{otscibox}}

\newenvironment{intuitionboxnosplit}[1][Intuition]
{\begin{otsciboxnosplit}[#1]{OTYellow}}{\end{otsciboxnosplit}}

\newenvironment{summarybox}[1][Key Summary]
{\begin{otscibox}[{#1}]{OTDark}}{\end{otscibox}}

\newenvironment{summaryboxnosplit}[1][Key Summary]
{\begin{otsciboxnosplit}[{#1}]{OTDark}}{\end{otsciboxnosplit}}

\newenvironment{experimentbox}[1][Experiment / Observation]
{\begin{otscibox}[{#1}]{OTPurple}}{\end{otscibox}}

\newenvironment{experimentboxnosplit}[1][Experiment / Observation]
{\begin{otsciboxnosplit}[{#1}]{OTPurple}}{\end{otsciboxnosplit}}

\newenvironment{reflectionbox}[1][Reflection]
{\begin{otscibox}[#1]{OTOrange}}{\end{otscibox}}

\newenvironment{chaptergoals}[1][Chapter Goals]
{\begin{otscibox}[#1]{OTBlue}\begin{itemize}}
{\end{itemize}\end{otscibox}}

\newenvironment{chapteroverview}[1][Chapter Overview]
{\begin{otscibox}[#1]{OTTeal}}
{\end{otscibox}}

\makeatletter
\newcounter{otdesignrule}
\ifotbook@chaptertheorems
  \@addtoreset{otdesignrule}{chapter}
  \renewcommand{\theotdesignrule}{\thechapter.\arabic{otdesignrule}}
\else
  \@addtoreset{otdesignrule}{section}
  \renewcommand{\theotdesignrule}{\thesection.\arabic{otdesignrule}}
\fi
\makeatother

\newenvironment{designrule}[1][Design Rule]
{\refstepcounter{otdesignrule}\begin{otscibox}[#1\ \theotdesignrule]{OTPurple}}
{\end{otscibox}}

\newenvironment{designrulenosplit}[1][Design Rule]
{\refstepcounter{otdesignrule}\begin{otsciboxnosplit}[#1\ \theotdesignrule]{OTPurple}}
{\end{otsciboxnosplit}}

% -----------------------------
% Margin notes
% -----------------------------
\RequirePackage{marginnote}

\newcommand{\otmarginnote}[2]{%
  \marginpar{%
    \raggedright
    \footnotesize
    \color{#1}%
    #2%
  }%
}

\newcommand{\otremark}[1]{\otmarginnote{OTBlue}{\textbf{Note:}\\ #1}}
\newcommand{\otcaveat}[1]{\otmarginnote{OTOrange}{\textbf{Caveat:}\\ #1}}
\newcommand{\otsideinfo}[1]{\otmarginnote{OTDark}{\textbf{Info:}\\ #1}}
\newcommand{\otpracticehint}[1]{\otmarginnote{OTTeal}{\textbf{Hint:}\\ #1}}

% -----------------------------
% Load ecosystem modules if available
% -----------------------------
\IfFileExists{otnotation.sty}{\RequirePackage{otnotation}}{}
\IfFileExists{otmath.sty}{\RequirePackage{otmath}}{}
\IfFileExists{ottensors.sty}{\RequirePackage{ottensors}}{}
\IfFileExists{otphysics.sty}{\RequirePackage{otphysics}}{}
\IfFileExists{otcoordinates.sty}{\RequirePackage{otcoordinates}}{}
\IfFileExists{otpractice.sty}{\RequirePackage{otpractice}}{}
\IfFileExists{otfigures.sty}{\RequirePackage{otfigures}}{}
\IfFileExists{otcircuits.sty}{\RequirePackage{otcircuits}}{}
\IfFileExists{otplots.sty}{\RequirePackage{otplots}}{}
\IfFileExists{otcode.sty}{\RequirePackage{otcode}}{}
\IfFileExists{otsymbols.sty}{\RequirePackage{otsymbols}}{}
\IfFileExists{otprofiles.sty}{\RequirePackage{otprofiles}}{}
\IfFileExists{otbib.sty}{\RequirePackage{otbib}}{}
\IfFileExists{otindex.sty}{\RequirePackage{otindex}}{}
\IfFileExists{otaccess.sty}{\RequirePackage{otaccess}}{}

\endinput
