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
\RequirePackage[margin=1in]{geometry}
\RequirePackage{xcolor}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{mathtools}
\RequirePackage{amsthm}
% Silence the known siunitx/physics \qty warning.
\RequirePackage{silence}
\WarningFilter{siunitx}{Detected the ``physics'' package}

\RequirePackage{physics}
\RequirePackage{siunitx}

% Restore siunitx's \qty after physics has taken it.
\AtBeginDocument{\RenewCommandCopy\qty\SI}
\RequirePackage{bm}
\RequirePackage{tcolorbox}
\RequirePackage{tikz}
\RequirePackage{enumitem}
\RequirePackage{booktabs}
\RequirePackage{tabularx}
\RequirePackage{array}
\RequirePackage{titlesec}
\RequirePackage{fancyhdr}
\RequirePackage{needspace}
\RequirePackage{datetime2}
\RequirePackage{hyperref}
\RequirePackage{cleveref}

\tcbuselibrary{skins,breakable,theorems,listings}

% -----------------------------
% Colour palette
% -----------------------------
\definecolor{OTDark}{HTML}{1F2937}
\definecolor{OTMuted}{HTML}{6B7280}
\definecolor{OTLight}{HTML}{F9FAFB}
\definecolor{OTBlue}{HTML}{2563EB}
\definecolor{OTGreen}{HTML}{059669}
\definecolor{OTOrange}{HTML}{D97706}
\definecolor{OTRed}{HTML}{DC2626}
\definecolor{OTPurple}{HTML}{7C3AED}
\definecolor{OTTeal}{HTML}{0891B2}
\definecolor{OTYellow}{HTML}{CA8A04}

% -----------------------------
% Hyperlinks
% -----------------------------
\hypersetup{
  colorlinks=true,
  linkcolor=OTBlue,
  urlcolor=OTBlue,
  citecolor=OTGreen
}

% -----------------------------
% Global settings
% -----------------------------
\sisetup{
  per-mode=symbol,
  separate-uncertainty=true,
  detect-all=true
}

\setlist[itemize]{topsep=3pt,itemsep=2pt}
\setlist[enumerate]{topsep=3pt,itemsep=2pt}

% -----------------------------
% Page style
% -----------------------------
\pagestyle{fancy}
\fancyhf{}
\lhead{\textcolor{OTMuted}{OT Science Notes}}
\rhead{\textcolor{OTMuted}{\leftmark}}
\cfoot{\thepage}
\renewcommand{\headrulewidth}{0.3pt}

% -----------------------------
% Section style
% -----------------------------
\titleformat{\section}
{\Large\bfseries\color{OTDark}}
{\thesection}{0.75em}{}

\titleformat{\subsection}
{\large\bfseries\color{OTBlue}}
{\thesubsection}{0.75em}{}

\titleformat{\subsubsection}
{\normalsize\bfseries\color{OTPurple}}
{\thesubsubsection}{0.75em}{}

% -----------------------------
% Base box
% -----------------------------
\newtcolorbox{otscibox}[2][]{
  enhanced,
  breakable,
  before={\Needspace{8\baselineskip}},
  colback=OTLight,
  colframe=#2,
  boxrule=0.8pt,
  arc=2mm,
  left=6pt,
  right=6pt,
  top=6pt,
  bottom=6pt,
  fonttitle=\bfseries,
  title={#1}
}

\newtcolorbox{otsciboxnosplit}[2][]{
  enhanced,
  before={\Needspace{12\baselineskip}},
  colback=OTLight,
  colframe=#2,
  boxrule=0.8pt,
  arc=2mm,
  left=6pt,
  right=6pt,
  top=6pt,
  bottom=6pt,
  fonttitle=\bfseries,
  title={#1}
}

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
