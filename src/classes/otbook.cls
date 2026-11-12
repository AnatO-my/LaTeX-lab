% ============================================================
% OT Personal Book Class
% otbook.cls
% Version: 0.3
%
% Composition (PLAN.md Phase D):
%   base class   book (11pt, A4, one-sided)
%   foundations  otcore (facade: otcolors + otlayout + table/date packages),
%                ottheme (palette + OT link policy)
%   preset       otscience-theme (shared with otscience), plus book chapter
%                headings and margin geometry set here
%   boxes        otboxes primitives, otsciboxes semantic family, book boxes
%   bundle       the otscience bundle plus otcircuits, otplots, otcode,
%                otsymbols, otprofiles, otbib, otindex, otaccess (skipped with
%                the `minimal' option)
% ============================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{otbook}[2026/11/11 v0.3 OT Personal Book Class]

% -----------------------------
% Base class
% -----------------------------
\newif\ifotbook@chaptertheorems\otbook@chaptertheoremsfalse
\DeclareOption{chaptertheorems}{\otbook@chaptertheoremstrue}
% minimal: skip the companion-package bundle loaded at the end of the class.
\newif\ifotbook@minimal\otbook@minimalfalse
\DeclareOption{minimal}{\otbook@minimaltrue}

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
\RequirePackage{otsciboxes}
\RequirePackage{cleveref}

\tcbuselibrary{theorems,listings}

% -----------------------------
% Visual preset
% -----------------------------
% otscience-theme supplies quantity formatting, list spacing and heading
% colours shared with otscience.
\RequirePackage{otscience-theme}

% -----------------------------
% Page style
% -----------------------------
\otsciencepagestyle{OT Book}

% -----------------------------
% Chapter and section style
% -----------------------------
\titleformat{\chapter}[display]
  {\Huge\bfseries\color{OTDark}}
  {\textcolor{OTBlue}{\chaptertitlename\ \thechapter}}
  {0.5em}
  {}

\titlespacing*{\chapter}{0pt}{-10pt}{2.5em}

% Section, subsection and subsubsection styles come from otscience-theme.

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
% The shared semantic science boxes come from otsciboxes.sty (loaded above).
% The boxes below are specific to otbook.

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
% Companion-package bundle
% -----------------------------
% These companions ship with the class in the LaTeX-lab author kit and are
% loaded unconditionally, so every installation yields the same commands.
% A missing companion now stops with a clear "File not found" error
% instead of silently removing its commands. The class option `minimal'
% skips this bundle; load the companions you need with \usepackage.
% (\makeatletter is needed because earlier blocks in this class end with
% \makeatother.)
\makeatletter
\ifotbook@minimal\else
  \RequirePackage{otnotation}
  \RequirePackage{otmath}
  \RequirePackage{ottensors}
  \RequirePackage{otphysics}
  \RequirePackage{otcoordinates}
  \RequirePackage{otpractice}
  \RequirePackage{otfigures}
  \RequirePackage{otcircuits}
  \RequirePackage{otplots}
  \RequirePackage{otcode}
  \RequirePackage{otsymbols}
  \RequirePackage{otprofiles}
  \RequirePackage{otbib}
  \RequirePackage{otindex}
  \RequirePackage{otaccess}
\fi

\endinput
