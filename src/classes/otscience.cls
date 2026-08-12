% ============================================================
% OT Science Notes Styler
% otscience.cls
% Version: 0.2
% ============================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{otscience}[2026/06/22 OT Science Notes Styler]

% -----------------------------
% Base class
% -----------------------------
\LoadClass[11pt,a4paper]{article}

% -----------------------------
% Core packages
% -----------------------------
\RequirePackage{otcore}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{mathtools}
\RequirePackage{amsthm}
% Silence the known siunitx/physics \qty warning.


\RequirePackage{physics}
\RequirePackage{siunitx}

% Restore siunitx's \qty after physics has taken it.
\AtBeginDocument{\RenewCommandCopy\qty\SI}
\ExplSyntaxOn
\msg_redirect_name:nnn { siunitx } { physics-pkg } { none }
\ExplSyntaxOff
\providecommand*{\definitionautorefname}{Definition}
\providecommand*{\exampleautorefname}{Example}
\RequirePackage{bm}
\RequirePackage{tikz}
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
  {\textcolor{OTMuted}{OT Science Notes}}
  {\textcolor{OTMuted}{\leftmark}}
  {0.3pt}

% -----------------------------
% Section style
% -----------------------------
\otcoresectionstyles{0.75em}{OTPurple}

% -----------------------------
% Standard science boxes
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
