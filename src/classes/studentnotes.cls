\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{studentnotes}[2026/06/06 Student Personal Notes Class]

% Base class
\LoadClass[12pt,a4paper]{article}

% ------------------------------------------------
% PACKAGES
% ------------------------------------------------
\RequirePackage[a4paper,margin=1in,marginparwidth=1.8cm,marginparsep=0.3cm]{geometry}
\RequirePackage{amsmath,amssymb,amsthm}
\RequirePackage{xcolor}
\RequirePackage{tikz}
\usetikzlibrary{positioning}
\usetikzlibrary{decorations.pathmorphing}
\RequirePackage{eso-pic}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{tcolorbox}
\RequirePackage{marginnote}
\RequirePackage{hyperref}
\RequirePackage{enumitem}
\RequirePackage{lmodern}
\RequirePackage[T1]{fontenc}
\RequirePackage{microtype}
\RequirePackage{witharrows}
\RequirePackage{graphicx}
\RequirePackage{cancel}
\RequirePackage{booktabs}
\RequirePackage{array}

% ------------------------------------------------
% COLOURS
% ------------------------------------------------
\definecolor{NoteBlue}{RGB}{30,80,160}
\definecolor{SoftBlue}{RGB}{235,245,255}
\definecolor{SoftYellow}{RGB}{255,249,220}
\definecolor{SoftGreen}{RGB}{235,250,235}
\definecolor{DotGrey}{RGB}{210,210,210}

% ------------------------------------------------
% PAGE STYLE
% ------------------------------------------------
\setlength{\headheight}{15pt}

\pagestyle{fancy}
\fancyhf{}
\lhead{\textbf{\notecourse}}
\chead{\notetitle}
\rhead{\thepage}
\renewcommand{\headrulewidth}{0.4pt}

\setlength{\parindent}{0pt}
\setlength{\parskip}{0.65em}


% ------------------------------------------------
% DOCUMENT DETAILS
% ------------------------------------------------
\newcommand{\notetitle}{Student Notes}
\newcommand{\notecourse}{Course}
\newcommand{\noteauthor}{Name}
\newcommand{\notedate}{\today}

\newcommand{\setnotetitle}[1]{\renewcommand{\notetitle}{#1}}
\newcommand{\setnotecourse}[1]{\renewcommand{\notecourse}{#1}}
\newcommand{\setnoteauthor}[1]{\renewcommand{\noteauthor}{#1}}
\newcommand{\setnotedate}[1]{\renewcommand{\notedate}{#1}}

% ------------------------------------------------
% TITLE FORMAT
% ------------------------------------------------
\newcommand{\makenotetitle}{
    \begin{center}
        {\Large\bfseries \notetitle}\\[0.3em]
        {\large \notecourse}\\[0.3em]
        {\noteauthor}\\[0.3em]
        {\notedate}
    \end{center}
    \vspace{1em}
    \hrule
    \vspace{1em}
}

% ------------------------------------------------
% SECTION STYLE
% ------------------------------------------------
\titleformat{\section}
{\large\bfseries\color{NoteBlue}}
{\thesection}{0.8em}{}

\titleformat{\subsection}
{\normalsize\bfseries\color{NoteBlue}}
{\thesubsection}{0.8em}{}

% ------------------------------------------------
% DOTTED SQUARE PAPER BACKGROUND
% ------------------------------------------------
\newcommand{\dotgridbackground}{
    \AddToShipoutPictureBG{
        \begin{tikzpicture}[remember picture,overlay]
            \foreach \x in {0,0.5,...,21}
            \foreach \y in {0,0.5,...,29.7}
            \fill[DotGrey] ([xshift=\x cm,yshift=\y cm]current page.south west) circle (0.35pt);
        \end{tikzpicture}
    }
}

% Turn background on
\newcommand{\usedotgrid}{\dotgridbackground}

% ------------------------------------------------
% QUICK NOTE BOXES
% ------------------------------------------------
\newtcolorbox{quicknote}{
    colback=SoftYellow,
    colframe=orange!70!black,
    title=Quick Note,
    fonttitle=\bfseries,
    sharp corners,
    boxrule=0.6pt
}

\newtcolorbox{personalnote}{
    colback=SoftBlue,
    colframe=NoteBlue,
    title=Personal Note,
    fonttitle=\bfseries,
    sharp corners,
    boxrule=0.6pt
}

\newtcolorbox{importantnote}{
    colback=SoftGreen,
    colframe=green!50!black,
    title=Important,
    fonttitle=\bfseries,
    sharp corners,
    boxrule=0.6pt
}

% ------------------------------------------------
% THEOREMS AND FORMULAS
% ------------------------------------------------
\newtheorem{theorem}{Theorem}[section]
\newtheorem{definition}{Definition}[section]
\newtheorem{example}{Example}[section]

\newcounter{formula}[section]
\renewcommand{\theformula}{\thesection.\arabic{formula}}
\renewcommand{\theHformula}{formula.\thesection.\arabic{formula}}

\newenvironment{namedformula}[1]
{
    \refstepcounter{formula}
    \begin{equation*}
    \tag{F\theformula}
}
{
    \end{equation*}
}

% ------------------------------------------------
% MARGIN NOTES
% ------------------------------------------------
\setlength{\marginparwidth}{1.8cm}
\setlength{\marginparsep}{0.3cm}

\newcommand{\notebox}[2]{%
    \marginpar{%
        \raggedright
        \footnotesize
        \color{#1}
        #2
    }%
}

\newcommand{\refnote}[1]{%
    \notebox{NoteBlue}{\textbf{Ref:}\\ #1}%
}

\newcommand{\theoremnote}[1]{%
    \notebox{purple}{\textbf{Thm:}\\ #1}%
}

\newcommand{\formulanote}[1]{%
    \notebox{red!70!black}{\textbf{Formula:}\\ #1}%
}

\newcommand{\remembernote}[1]{%
    \notebox{green!50!black}{\textbf{Remember:}\\ #1}%
}

% ------------------------------------------------
% LIST STYLE
% ------------------------------------------------
\setlist[itemize]{leftmargin=1.5em}
\setlist[enumerate]{leftmargin=1.8em}

% ------------------------------------------------
% HYPERLINK SETUP
% ------------------------------------------------
\hypersetup{
    colorlinks=true,
    linkcolor=NoteBlue,
    urlcolor=NoteBlue,
    citecolor=NoteBlue
}

% ------------------------------------------------
% WITHARROWS SUPPORT
% ------------------------------------------------
\RequirePackage{witharrows}

\newcommand{\arrowcomment}[1]{%
    \Arrow{\mbox{\scriptsize #1}}%
}

\newcommand{\stepnote}[1]{%
    \Arrow{\mbox{\scriptsize #1}}%
}

\newcommand{\steparrow}[1]{%
    \Arrow{\mbox{\scriptsize\textbf{Step:} #1}}%
}

\newcommand{\reasonarrow}[1]{%
    \Arrow{\mbox{\scriptsize\textbf{Reason:} #1}}%
}

\newcommand{\subarrow}[1]{%
    \Arrow{\mbox{\scriptsize\textbf{Substitute:} #1}}%
}

% ------------------------------------------------
% CUSTOMS RECOMMANDS
% ------------------------------------------------
\newcommand{\colvec}[2]{%
    \begin{bmatrix}
        #1 \\
        #2
    \end{bmatrix}%
}