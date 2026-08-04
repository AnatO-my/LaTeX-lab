\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{physicsquiz}[2026/05/27 Stylish physics quiz class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass{article}

% -------------------------------------------------
% Packages
% -------------------------------------------------
\RequirePackage[english]{babel}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}

\RequirePackage[a4paper,top=1.57cm,bottom=1.57cm,left=1cm,right=1cm]{geometry}

\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{graphicx}
\RequirePackage{lmodern}
\RequirePackage{xcolor}
\RequirePackage{multicol}
\RequirePackage{enumitem}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{tcolorbox}
\RequirePackage{siunitx}
\RequirePackage{hyperref}
\RequirePackage{bookmark}
\RequirePackage{caption}
\RequirePackage{subcaption}
\RequirePackage{float}
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{hyphenat}

\sisetup{per-mode=symbol}

% -------------------------------------------------
% Global document font size
% -------------------------------------------------

\newcommand{\QuizFontSize}{10pt}
\newcommand{\QuizBaselineSkip}{12pt}

\newcommand{\quizfontsize}[2]{%
    \renewcommand{\QuizFontSize}{#1}%
    \renewcommand{\QuizBaselineSkip}{#2}%
}

\AtBeginDocument{%
    \fontsize{\QuizFontSize}{\QuizBaselineSkip}\selectfont
}

% -------------------------------------------------
% Theme colours
% -------------------------------------------------
\definecolor{QuizNavy}{HTML}{102A43}
\definecolor{QuizBlue}{HTML}{00008B}
\definecolor{QuizLightBlue}{HTML}{EFF6FF}
\definecolor{QuizGreen}{HTML}{166534}
\definecolor{QuizGold}{HTML}{DCD705}
\definecolor{QuizGrey}{HTML}{4B5563}
\definecolor{QuizLightGrey}{HTML}{F3F4F6}

\hypersetup{
    colorlinks=true,
    linkcolor=QuizBlue,
    urlcolor=QuizBlue,
    citecolor=QuizGreen
}

% -------------------------------------------------
% Document information
% -------------------------------------------------
\newcommand{\QuizTitle}{Pre-test Questions}
\newcommand{\QuizAuthor}{}
\newcommand{\QuizCourse}{Physics}
\newcommand{\QuizInstitution}{}
\newcommand{\QuizInstructions}{Choose the correct option for each question.}
\newcommand{\QuizConstants}{}

\newcommand{\quiztitle}[1]{\renewcommand{\QuizTitle}{#1}}
\newcommand{\quizauthor}[1]{\renewcommand{\QuizAuthor}{#1}}
\newcommand{\quizcourse}[1]{\renewcommand{\QuizCourse}{#1}}
\newcommand{\quizinstitution}[1]{\renewcommand{\QuizInstitution}{#1}}
\newcommand{\quizinstructions}[1]{\renewcommand{\QuizInstructions}{#1}}
\newcommand{\quizconstants}[1]{\renewcommand{\QuizConstants}{#1}}

% -------------------------------------------------
% Page header and footer
% -------------------------------------------------
\setlength{\headheight}{15pt}

\pagestyle{fancy}
\fancyhf{}
\lhead{\textcolor{QuizGrey}{\small \QuizCourse}}
\rhead{\textcolor{QuizGrey}{\small \QuizTitle}}
\cfoot{\textcolor{QuizGrey}{\small Page \thepage}}
\renewcommand{\headrulewidth}{0.3pt}

% -------------------------------------------------
% Section headings
% -------------------------------------------------
\titleformat{\section}
{\Large\bfseries\color{QuizNavy}}
{\thesection}{0.6em}{}

\titleformat{\subsection}
{\large\bfseries\color{QuizBlue}}
{\thesubsection}{0.6em}{}

% -------------------------------------------------
% Title page
% -------------------------------------------------
\newcommand{\makequiztitle}{
    \begin{titlepage}
        \centering
        \vspace*{1.8cm}

        {\Huge\bfseries\textcolor{QuizNavy}{\QuizTitle}\par}
        \vspace{0.35cm}

        {\Large\textcolor{QuizBlue}{\QuizCourse}\par}
        \vspace{0.6cm}

        \textcolor{QuizGold}{\rule{0.75\linewidth}{1pt}}

        \vspace{0.9cm}

        {\large\textcolor{QuizGrey}{\QuizAuthor}\par}
        \vspace{0.2cm}
        {\large\textcolor{QuizGrey}{\QuizInstitution}\par}

        \vfill

        \begin{tcolorbox}[
                colback=QuizLightBlue,
                colframe=QuizBlue,
                width=0.82\linewidth,
                arc=3mm,
                boxrule=0.8pt,
                left=10pt,
                right=10pt,
                top=10pt,
                bottom=10pt
            ]
            \textbf{Instructions:} \QuizInstructions
        \end{tcolorbox}

        \vspace*{1.5cm}
    \end{titlepage}
}
%
% Constants box
% -------------------------------------------------
\newcommand{\constantsbox}{
    \begin{tcolorbox}[
            colback=QuizLightGrey,
            colframe=QuizGrey,
            arc=2mm,
            boxrule=0.6pt,
            left=8pt,
            right=8pt,
            top=7pt,
            bottom=7pt
        ]
        \begingroup
        \hyphenpenalty=10000
        \exhyphenpenalty=10000
        \setlength{\emergencystretch}{3em}
        \noindent
        \sloppy
        \raggedright
        \nohyphens{\textbf{Where required, take:}\enspace
            \QuizConstants}
        \endgroup
    \end{tcolorbox}
}

% -------------------------------------------------
% Question environment
% -------------------------------------------------
\newenvironment{quizquestions}[1][2]
{
    \setlength\columnsep{1.9em}
    \setlength\columnseprule{0.5pt}
    \begin{multicols*}{#1}
    \begin{enumerate}[
        label=\textbf{\arabic*.},
        leftmargin=*,
        itemsep=1.0em,
        topsep=0.5em
    ]
}
{
    \end{enumerate}
    \end{multicols*}
}

% -------------------------------------------------
% Multiple-choice options
% -------------------------------------------------
% Flexible semantic interface: use one \item per option.
% The list may contain any number of options and may break
% across columns or pages when space is tight.
\newenvironment{choiceoptions}
{
    \begingroup
    \everymath{\displaystyle}
    \begin{enumerate}[
        label=\(\mathbf{\Alph*.}\),
        leftmargin=2.1em,
        labelwidth=1.6em,
        labelsep=0.5em,
        align=left,
        itemsep=6pt,
        topsep=0.35em,
        parsep=0pt,
        partopsep=0pt
    ]
}
{
    \end{enumerate}
    \endgroup
}

% Backward-compatible five-option interface.
\newcommand{\choices}[5]{%
    \begin{choiceoptions}
        \item #1
        \item #2
        \item #3
        \item #4
        \item #5
    \end{choiceoptions}%
}

% -------------------------------------------------
% Answer key
% -------------------------------------------------
\newenvironment{answerkey}
{
    \section*{Answer Key}
    \begin{tcolorbox}[
        colback=QuizLightBlue,
        colframe=QuizBlue,
        arc=2mm,
        boxrule=0.7pt,
        left=8pt,
        right=8pt,
        top=8pt,
        bottom=8pt
    ]
}
{
    \end{tcolorbox}
}

% -------------------------------------------------
% Utility command
% -------------------------------------------------
% Define \unit only if not already defined to avoid redefinition errors
\providecommand{\unit}[1]{\,\mathrm{#1}}