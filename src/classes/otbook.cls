% ============================================================
% OT Personal Book Class
% otbook.cls
% Version: 0.1
% ============================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{otbook}[2026/08/20 v0.1 OT Personal Book Class]

% -----------------------------
% Base class
% -----------------------------
\PassOptionsToClass{11pt,a4paper,oneside}{book}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
\LoadClass{book}

% -----------------------------
% Core packages
% -----------------------------
\RequirePackage{otcore}
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
{\begin{otsciboxnosplit}[#1]{OTBlue}\begin{itemize}}
{\end{itemize}\end{otsciboxnosplit}}

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

\endinput
