\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{physicsquiz}[2026/08/12 v0.1 Stylish physics quiz class]

% Public version and capability markers. These are intentionally simple
% expandable values so documents and tests can check class capabilities without
% relying on the \ProvidesClass date string.
\newcommand{\physicsquizclassversion}{0.1}
\newcommand{\physicsquizstructuredinterfaceversion}{1}
\newcommand{\physicsquizstructuredinterfaceid}{physicsquiz-structured-v1}

% -------------------------------------------------
% Primary assessment-output modes
% -------------------------------------------------
% Exactly one primary mode may be selected. With no explicit
% mode option, the class preserves its established full output.
\newif\ifpq@mode@full
\newif\ifpq@mode@student
\newif\ifpq@mode@teacher
\newif\ifpq@mode@solutions
\newif\ifpq@mode@answerkey

% The presentation axis is independent of the primary output mode.
% With no explicit presentation option, the established colour theme remains.
\newif\ifpq@presentation@colour
\newif\ifpq@presentation@print

\newcount\pq@primarymodecount
\pq@primarymodecount=0
\def\pq@primarymodename{full}

\newcount\pq@presentationmodecount
\pq@presentationmodecount=0

\def\pq@selectprimarymode#1#2{%
    \advance\pq@primarymodecount by 1\relax
    \def\pq@primarymodename{#1}%
    #2%
}

\DeclareOption{full}{%
    \pq@selectprimarymode{full}{\pq@mode@fulltrue}%
}
\DeclareOption{student}{%
    \pq@selectprimarymode{student}{\pq@mode@studenttrue}%
}
\DeclareOption{teacher}{%
    \pq@selectprimarymode{teacher}{\pq@mode@teachertrue}%
}
\DeclareOption{solutions}{%
    \pq@selectprimarymode{solutions}{\pq@mode@solutionstrue}%
}
\DeclareOption{answerkey}{%
    \pq@selectprimarymode{answerkey}{\pq@mode@answerkeytrue}%
}

\def\pq@selectpresentationmode#1{%
    \advance\pq@presentationmodecount by 1\relax
    #1%
}

\DeclareOption{colour}{%
    \pq@selectpresentationmode{\pq@presentation@colourtrue}%
}
\DeclareOption{color}{%
    \pq@selectpresentationmode{\pq@presentation@colourtrue}%
}
\DeclareOption{print}{%
    \pq@selectpresentationmode{\pq@presentation@printtrue}%
}

% Options not owned by physicsquiz remain article options.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\ifnum\pq@primarymodecount=0\relax
    \pq@mode@fulltrue
\else
    \ifnum\pq@primarymodecount>1\relax
        \ClassError{physicsquiz}
          {Conflicting primary output modes}
          {Select exactly one of full, student, teacher, solutions, or answerkey.}%
    \fi
\fi

\ifnum\pq@presentationmodecount=0\relax
    \pq@presentation@colourtrue
\else
    \ifnum\pq@presentationmodecount>1\relax
        \ClassError{physicsquiz}
          {Conflicting presentation modes}
          {Select exactly one of colour (or color) and print.}%
    \fi
\fi

% Derived content state. Later semantic rendering environments use
% these booleans rather than testing class-option names directly.
\newif\ifpq@show@questions
\newif\ifpq@show@answerkey
\newif\ifpq@show@solutions
\newif\ifpq@show@teacher
\newif\ifpq@show@reference
\newif\ifpq@show@marks
\newif\ifpq@show@difficulty

\ifpq@mode@full
    \pq@show@questionstrue
    \pq@show@answerkeytrue
    \pq@show@solutionstrue
    \pq@show@referencetrue
    \pq@show@markstrue
    \pq@show@difficultytrue
\fi
\ifpq@mode@student
    \pq@show@questionstrue
    \pq@show@referencetrue
    \pq@show@markstrue
\fi
\ifpq@mode@teacher
    \pq@show@questionstrue
    \pq@show@answerkeytrue
    \pq@show@teachertrue
    \pq@show@referencetrue
    \pq@show@markstrue
    \pq@show@difficultytrue
\fi
\ifpq@mode@solutions
    \pq@show@solutionstrue
    \pq@show@referencetrue
\fi
\ifpq@mode@answerkey
    \pq@show@answerkeytrue
\fi

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
\RequirePackage{xsim}

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
% Theme colours and presentation modes
% -------------------------------------------------
\ifpq@presentation@print
    % Preserve the public colour names while mapping them to economical,
    % high-contrast greys for monochrome printing.
    \definecolor{QuizNavy}{gray}{0}
    \definecolor{QuizBlue}{gray}{0}
    \definecolor{QuizLightBlue}{gray}{0.97}
    \definecolor{QuizGreen}{gray}{0}
    \definecolor{QuizGold}{gray}{0.35}
    \definecolor{QuizGrey}{gray}{0.25}
    \definecolor{QuizLightGrey}{gray}{0.95}

    \hypersetup{hidelinks}
\else
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
\fi

% -------------------------------------------------
% Document information
% -------------------------------------------------
\newcommand{\QuizTitle}{Pre-test Questions}
\newcommand{\QuizAuthor}{}
\newcommand{\QuizCourse}{Physics}
\newcommand{\QuizInstitution}{}
\newcommand{\QuizInstructions}{Choose the correct option for each question.}
\newcommand{\QuizConstants}{}
\newcommand{\QuizVersion}{}
\newif\ifpq@versioned

\newcommand{\quiztitle}[1]{\renewcommand{\QuizTitle}{#1}}
\newcommand{\quizauthor}[1]{\renewcommand{\QuizAuthor}{#1}}
\newcommand{\quizcourse}[1]{\renewcommand{\QuizCourse}{#1}}
\newcommand{\quizinstitution}[1]{\renewcommand{\QuizInstitution}{#1}}
\newcommand{\quizinstructions}[1]{\renewcommand{\QuizInstructions}{#1}}
\newcommand{\quizconstants}[1]{\renewcommand{\QuizConstants}{#1}}
\newcommand{\quizversion}[1]{%
    \renewcommand{\QuizVersion}{#1}%
    \if\relax\detokenize{#1}\relax
        \pq@versionedfalse
    \else
        \pq@versionedtrue
    \fi
}

% -------------------------------------------------
% Page header and footer
% -------------------------------------------------
\setlength{\headheight}{15pt}

\pagestyle{fancy}
\fancyhf{}
\lhead{\textcolor{QuizGrey}{\small \QuizCourse}}
\rhead{\textcolor{QuizGrey}{\small \QuizTitle%
    \ifpq@versioned\enspace|\enspace Version \QuizVersion\fi}}
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
        \ifpq@versioned
            \vspace{0.25cm}
            {\large\bfseries\textcolor{QuizGrey}{Version \QuizVersion}\par}
        \fi
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
% multicol requires at least two columns.  Keep the established two-column
% default while allowing the documented one-column form to use the same list
% interface without multicol.
\newif\ifpq@quizquestions@multicol
\newenvironment{quizquestions}[1][2]
{
    \setlength\columnsep{1.9em}
    \setlength\columnseprule{0.5pt}
    \ifnum#1=1\relax
        \pq@quizquestions@multicolfalse
    \else
        \pq@quizquestions@multicoltrue
        \begin{multicols*}{#1}
    \fi
    \begin{enumerate}[
        label=\textbf{\arabic*.},
        leftmargin=*,
        itemsep=1.0em,
        topsep=0.5em
    ]
}
{
    \end{enumerate}
    \ifpq@quizquestions@multicol
        \end{multicols*}
    \fi
}

% -------------------------------------------------
% Multiple-choice options
% -------------------------------------------------
% Flexible semantic interface: use one \item per option.
% The list may contain any number of options and may break
% across columns or pages when space is tight.
\newenvironment{choiceoptions}
{
    \pqchoiceoptionsguard
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
% Optional per-question presentation hooks
% -------------------------------------------------
% Marks appear on full, student, and teacher papers. Difficulty appears
% on full and teacher papers only. The supplied values are display-only;
% Phase 3 does not store metadata or calculate mark totals.
\newcommand{\quizmarks}[1]{%
    \ifpq@show@marks
        \unskip\hfill
        \mbox{\textcolor{QuizGrey}{\footnotesize\bfseries[Marks: #1]}}%
    \fi
}

\newcommand{\quizdifficulty}[1]{%
    \ifpq@show@difficulty
        \unskip\hspace{0.6em}%
        \mbox{\textcolor{QuizGrey}{\footnotesize\bfseries[Difficulty: #1]}}%
    \fi
}

% -------------------------------------------------
% Semantic output gates
% -------------------------------------------------
% These environments select complete document sections from the
% derived content state. They do not store questions, collect
% answers, or define a question-bank record.
\NewDocumentEnvironment{quizquestioncontent}{+b}
{%
    \ifpq@show@questions
        #1%
    \fi
}
{}

\NewDocumentEnvironment{quizanswerkeycontent}{+b}
{%
    \ifpq@show@answerkey
        #1%
    \fi
}
{}

\NewDocumentEnvironment{quizsolutioncontent}{+b}
{%
    \ifpq@show@solutions
        #1%
    \fi
}
{}

\NewDocumentEnvironment{quizteachercontent}{+b}
{%
    \ifpq@show@teacher
        #1%
    \fi
}
{}

\NewDocumentEnvironment{quizreferencecontent}{+b}
{%
    \ifpq@show@reference
        #1%
    \fi
}
{}

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
% Structured question-bank interface
% -------------------------------------------------
% xsim owns record storage, identity, points, topics, and solution replay.
% The public author syntax and every rendered section remain class-owned.
\DeclareExerciseProperty{stable-id}
\DeclareExerciseProperty{topic-label}
\DeclareExerciseProperty{tag-labels}
\DeclareExerciseProperty{difficulty}
\DeclareExerciseProperty{correct}
\DeclareExerciseProperty{outcome}

% Store every record without printing it at the declaration site.  Phase 4D
% renders only the deterministic selection assembled by class-owned commands.
\xsimsetup{exercise/print=false}

\newcounter{pqselectedquestion}

\DeclareExerciseEnvironmentTemplate{physicsquiz-question}
  {\item}
  {%
    \par\smallskip\noindent
    \quizmarks{\GetExerciseProperty{points}}%
    \quizdifficulty{\GetExerciseProperty{difficulty}}%
  }

\DeclareExerciseEnvironmentTemplate{physicsquiz-solution}
  {%
    \typeout{PQ4C-SOLUTION:\GetExerciseProperty{stable-id}=\GetExerciseProperty{correct}}%
    \begin{tcolorbox}[
      colback=white,
      colframe=QuizBlue,
      colbacktitle=QuizLightBlue,
      coltitle=QuizNavy,
      fonttitle=\bfseries,
      title={Question \arabic{pqselectedquestion} --- Correct option \quizcorrectletter},
      arc=2mm,
      boxrule=0.65pt,
      left=8pt,right=8pt,top=6pt,bottom=6pt,
      before skip=8pt,after skip=8pt
    ]
    \textbf{Topic:} \GetExerciseProperty{topic-label}.\par
  }
  {\end{tcolorbox}}

\xsimsetup{
  exercise/template=physicsquiz-question,
  solution/template=physicsquiz-solution
}

\ExplSyntaxOn

\tl_new:N \l__pq_id_tl
\tl_new:N \l__pq_topic_tl
\tl_new:N \l__pq_difficulty_tl
\tl_new:N \l__pq_marks_tl
\tl_new:N \l__pq_correct_tl
\tl_new:N \l__pq_tags_tl
\tl_new:N \l__pq_outcome_tl
\tl_new:N \g__pq_last_id_tl
\seq_new:N \g__pq_question_ids_seq
\seq_new:N \g__pq_solution_ids_seq
\seq_new:N \g__pq_selected_ids_seq
\seq_new:N \l__pq_random_candidates_seq
\seq_new:N \l__pq_random_pool_seq
\prop_new:N \g__pq_topic_prop
\prop_new:N \g__pq_difficulty_prop
\prop_new:N \g__pq_marks_prop
\prop_new:N \g__pq_correct_prop
\prop_new:N \g__pq_tags_prop
\prop_new:N \g__pq_outcome_prop
\tl_new:N \l__pq_filter_topic_tl
\tl_new:N \l__pq_filter_difficulty_tl
\tl_new:N \l__pq_filter_marks_tl
\clist_new:N \l__pq_filter_tags_clist
\clist_new:N \l__pq_record_tags_clist
\bool_new:N \l__pq_filter_match_bool
\int_new:N \l__pq_filter_match_int
\int_new:N \g__pq_compat_start_int
\int_new:N \l__pq_random_count_int
\int_new:N \l__pq_random_seed_int
\int_new:N \l__pq_random_state_int
\int_new:N \l__pq_random_index_int
\int_new:N \l__pq_random_limit_int
\fp_new:N \l__pq_selection_total_fp
\fp_new:N \l__pq_assert_total_fp

\keys_define:nn { physicsquiz / question }
  {
    id         .tl_set:N = \l__pq_id_tl,
    topic      .tl_set:N = \l__pq_topic_tl,
    difficulty .choices:nn =
      { foundation, applied, challenge }
      { \tl_set_eq:NN \l__pq_difficulty_tl \l_keys_choice_tl },
    marks      .tl_set:N = \l__pq_marks_tl,
    correct    .tl_set:N = \l__pq_correct_tl,
    tags       .tl_set:N = \l__pq_tags_tl,
    outcome    .tl_set:N = \l__pq_outcome_tl
  }

\keys_define:nn { physicsquiz / selection }
  {
    topic      .tl_set:N    = \l__pq_filter_topic_tl,
    difficulty .tl_set:N    = \l__pq_filter_difficulty_tl,
    marks      .tl_set:N    = \l__pq_filter_marks_tl,
    tags       .clist_set:N = \l__pq_filter_tags_clist
  }

\cs_new_protected:Npn \__pq_reset_question_keys:
  {
    \tl_clear:N \l__pq_id_tl
    \tl_clear:N \l__pq_topic_tl
    \tl_clear:N \l__pq_difficulty_tl
    \tl_clear:N \l__pq_marks_tl
    \tl_clear:N \l__pq_correct_tl
    \tl_clear:N \l__pq_tags_tl
    \tl_clear:N \l__pq_outcome_tl
  }

\cs_new_protected:Npn \__pq_missing_metadata:n #1
  {
    \typeout{PQ4C-VALIDATION:MISSING-#1}
    \ClassError{physicsquiz}
      {Missing~required~question~metadata:~#1}
      {Supply the #1 key in the quizquestion option list.}
  }

\cs_new_protected:Npn \__pq_validate_nonblank:nN #1#2
  { \tl_if_blank:VT #2 { \__pq_missing_metadata:n {#1} } }

\cs_new_protected:Npn \__pq_validate_question:
  {
    \__pq_validate_nonblank:nN {id}         \l__pq_id_tl
    \__pq_validate_nonblank:nN {topic}      \l__pq_topic_tl
    \__pq_validate_nonblank:nN {difficulty} \l__pq_difficulty_tl
    \__pq_validate_nonblank:nN {marks}      \l__pq_marks_tl
    \__pq_validate_nonblank:nN {correct}    \l__pq_correct_tl
    \__pq_validate_nonblank:nN {tags}       \l__pq_tags_tl

    \tl_if_blank:VF \l__pq_id_tl
      {
        \exp_args:NnV \regex_match:nnF
          { \A [a-z0-9]+ (?: -[a-z0-9]+ )* \Z }
          \l__pq_id_tl
          {
            \typeout{PQ4C-VALIDATION:INVALID-ID:\tl_use:N \l__pq_id_tl}
            \ClassError{physicsquiz}
              {Invalid~stable~question~ID:~\tl_use:N \l__pq_id_tl}
              {Use lowercase letters, digits, and single hyphens.}
          }
        \seq_if_in:NVTF \g__pq_question_ids_seq \l__pq_id_tl
          {
            \typeout{PQ4C-VALIDATION:DUPLICATE-ID:\tl_use:N \l__pq_id_tl}
            \ClassError{physicsquiz}
              {Duplicate~stable~question~ID:~\tl_use:N \l__pq_id_tl}
              {Every quizquestion id must be unique.}
          }
          { \seq_gput_right:NV \g__pq_question_ids_seq \l__pq_id_tl }
      }

    \tl_if_blank:VF \l__pq_marks_tl
      {
        \exp_args:NnV \regex_match:nnF
          { \A (?: [1-9][0-9]* (?: [.] [0-9]+ )? | 0[.] [0-9]*[1-9][0-9]* ) \Z }
          \l__pq_marks_tl
          {
            \typeout{PQ4C-VALIDATION:INVALID-MARKS:\tl_use:N \l__pq_marks_tl}
            \ClassError{physicsquiz}
              {Invalid~marks~value:~\tl_use:N \l__pq_marks_tl}
              {Use a positive integer or decimal number.}
          }
      }

    \tl_if_blank:VF \l__pq_correct_tl
      {
        \tl_set:Nx \l__pq_correct_tl
          { \text_uppercase:n { \tl_use:N \l__pq_correct_tl } }
        \exp_args:NnV \regex_match:nnF { \A [A-Z] \Z } \l__pq_correct_tl
          {
            \typeout{PQ4C-VALIDATION:INVALID-CORRECT:\tl_use:N \l__pq_correct_tl}
            \ClassError{physicsquiz}
              {Invalid~correct~option:~\tl_use:N \l__pq_correct_tl}
              {Use one option letter, for example correct=C.}
          }
      }
  }

\cs_new_protected:Npn \__pq_store_question:nn #1#2
  { \begin{exercise}[#1]#2\end{exercise} }

\cs_new_protected:Npn \__pq_validate_previous_solution:
  {
    \tl_if_blank:VF \g__pq_last_id_tl
      {
        \seq_if_in:NVF \g__pq_solution_ids_seq \g__pq_last_id_tl
          {
            \typeout{PQ4C-VALIDATION:MISSING-SOLUTION:\tl_use:N \g__pq_last_id_tl}
            \ClassError{physicsquiz}
              {Missing~solution~for~question:~\tl_use:N \g__pq_last_id_tl}
              {Place one quizsolution after that quizquestion before starting another.}
          }
      }
  }

\NewDocumentEnvironment{quizquestion}{ O{} +b }
  {
    \__pq_validate_previous_solution:
    \__pq_reset_question_keys:
    \keys_set:nn { physicsquiz / question } {#1}
    \__pq_validate_question:
    \tl_gset_eq:NN \g__pq_last_id_tl \l__pq_id_tl
    \prop_gput:NVV \g__pq_topic_prop      \l__pq_id_tl \l__pq_topic_tl
    \prop_gput:NVV \g__pq_difficulty_prop \l__pq_id_tl \l__pq_difficulty_tl
    \prop_gput:NVV \g__pq_marks_prop      \l__pq_id_tl \l__pq_marks_tl
    \prop_gput:NVV \g__pq_correct_prop    \l__pq_id_tl \l__pq_correct_tl
    \prop_gput:NVV \g__pq_tags_prop       \l__pq_id_tl \l__pq_tags_tl
    \prop_gput:NVV \g__pq_outcome_prop    \l__pq_id_tl \l__pq_outcome_tl
    \exp_args:Nx \__pq_store_question:nn
      {
        ID={\exp_not:V \l__pq_id_tl},
        stable-id={\exp_not:V \l__pq_id_tl},
        points={\exp_not:V \l__pq_marks_tl},
        topics={\exp_not:V \l__pq_topic_tl},
        topic-label={\exp_not:V \l__pq_topic_tl},
        difficulty={\exp_not:V \l__pq_difficulty_tl},
        correct={\exp_not:V \l__pq_correct_tl},
        tags={\exp_not:V \l__pq_tags_tl},
        tag-labels={\exp_not:V \l__pq_tags_tl},
        outcome={\exp_not:V \l__pq_outcome_tl}
      }
      {#2}
  }
  {}

\NewDocumentEnvironment{quizsolution}{ +b }
  {
    \tl_if_blank:VTF \g__pq_last_id_tl
      {
        \typeout{PQ4C-VALIDATION:ORPHAN-SOLUTION}
        \ClassError{physicsquiz}
          {A~quizsolution~has~no~preceding~quizquestion}
          {Place each quizsolution immediately after its quizquestion.}
      }
      {
        \seq_if_in:NVTF \g__pq_solution_ids_seq \g__pq_last_id_tl
          {
            \typeout{PQ4C-VALIDATION:DUPLICATE-SOLUTION:\tl_use:N \g__pq_last_id_tl}
            \ClassError{physicsquiz}
              {Duplicate~solution~for~question:~\tl_use:N \g__pq_last_id_tl}
              {Supply exactly one quizsolution for each quizquestion.}
          }
          {
            \seq_gput_right:NV \g__pq_solution_ids_seq \g__pq_last_id_tl
            \begin{solution}#1\end{solution}
          }
      }
  }
  {}

\cs_new_protected:Npn \__pq_validate_solutions:
  {
    \seq_map_inline:Nn \g__pq_question_ids_seq
      {
        \seq_if_in:NnF \g__pq_solution_ids_seq {##1}
          {
            \typeout{PQ4C-VALIDATION:MISSING-SOLUTION:##1}
            \ClassError{physicsquiz}
              {Missing~solution~for~question:~##1}
              {Supply one quizsolution immediately after that quizquestion.}
          }
      }
  }

\cs_new_protected:Npn \__pq_selection_add:n #1
  {
    \seq_if_in:NnF \g__pq_selected_ids_seq {#1}
      {
        \seq_gput_right:Nn \g__pq_selected_ids_seq {#1}
        \typeout{PQ4D-SELECT:#1}
      }
  }

\cs_generate_variant:Nn \__pq_selection_add:n {V}

% Selection needs an expandable stable-ID index.  xsim remains the canonical
% body/solution store; these class-owned property indices support deterministic
% filtering and reporting without exposing xsim's numeric internal IDs.
\cs_new:Npn \__pq_property:nn #1#2
  {
    \str_case:nn {#2}
      {
        {topic-label} { \prop_item:Nn \g__pq_topic_prop      {#1} }
        {difficulty}  { \prop_item:Nn \g__pq_difficulty_prop {#1} }
        {points}      { \prop_item:Nn \g__pq_marks_prop      {#1} }
        {correct}     { \prop_item:Nn \g__pq_correct_prop    {#1} }
        {tag-labels}  { \prop_item:Nn \g__pq_tags_prop       {#1} }
        {outcome}     { \prop_item:Nn \g__pq_outcome_prop    {#1} }
      }
  }

\cs_new_protected:Npn \__pq_unknown_selection_id:n #1
  {
    \typeout{PQ4D-VALIDATION:UNKNOWN-ID:#1}
    \ClassError{physicsquiz}
      {Unknown~question~ID~in~selection:~#1}
      {Declare the question before selecting its stable ID.}
  }

\cs_new_protected:Npn \__pq_require_selection:
  {
    \seq_if_empty:NT \g__pq_selected_ids_seq
      {
        \typeout{PQ4D-VALIDATION:EMPTY-SELECTION}
        \ClassError{physicsquiz}
          {The~question~selection~is~empty}
          {Select records before printing questions, answers, solutions, or reports.}
      }
  }

\cs_new_protected:Npn \__pq_reset_filter_keys:
  {
    \tl_clear:N \l__pq_filter_topic_tl
    \tl_clear:N \l__pq_filter_difficulty_tl
    \tl_clear:N \l__pq_filter_marks_tl
    \clist_clear:N \l__pq_filter_tags_clist
  }

\cs_new_protected:Npn \__pq_validate_filter_values:
  {
    \tl_if_blank:VF \l__pq_filter_difficulty_tl
      {
        \exp_args:NnV \regex_match:nnF
          { \A (?: foundation | applied | challenge ) \Z }
          \l__pq_filter_difficulty_tl
          {
            \typeout{PQ4D-VALIDATION:INVALID-FILTER-DIFFICULTY:\tl_use:N \l__pq_filter_difficulty_tl}
            \ClassError{physicsquiz}
              {Invalid~difficulty~filter:~\tl_use:N \l__pq_filter_difficulty_tl}
              {Use foundation, applied, or challenge.}
          }
      }
    \tl_if_blank:VF \l__pq_filter_marks_tl
      {
        \exp_args:NnV \regex_match:nnF
          { \A (?: [1-9][0-9]* (?: [.] [0-9]+ )? | 0[.] [0-9]*[1-9][0-9]* ) \Z }
          \l__pq_filter_marks_tl
          {
            \typeout{PQ4D-VALIDATION:INVALID-FILTER-MARKS:\tl_use:N \l__pq_filter_marks_tl}
            \ClassError{physicsquiz}
              {Invalid~marks~filter:~\tl_use:N \l__pq_filter_marks_tl}
              {Use a positive integer or decimal number.}
          }
      }
  }

\cs_new_protected:Npn \__pq_validate_filter:
  {
    \__pq_validate_filter_values:
    \bool_lazy_all:nT
      {
        { \tl_if_blank_p:V \l__pq_filter_topic_tl }
        { \tl_if_blank_p:V \l__pq_filter_difficulty_tl }
        { \tl_if_blank_p:V \l__pq_filter_marks_tl }
        { \clist_if_empty_p:N \l__pq_filter_tags_clist }
      }
      {
        \typeout{PQ4D-VALIDATION:EMPTY-FILTER}
        \ClassError{physicsquiz}
          {No~metadata~filter~was~supplied}
          {Use \string\quizselectall to select every declared question.}
      }
  }

\prg_new_protected_conditional:Npnn \__pq_record_matches:n #1 {T,F,TF}
  {
    \bool_set_true:N \l__pq_filter_match_bool

    \tl_if_blank:VF \l__pq_filter_topic_tl
      {
        \tl_set:Nx \l_tmpa_tl
          { \__pq_property:nn {#1}{topic-label} }
        \tl_if_eq:NNF \l_tmpa_tl \l__pq_filter_topic_tl
          { \bool_set_false:N \l__pq_filter_match_bool }
      }

    \tl_if_blank:VF \l__pq_filter_difficulty_tl
      {
        \tl_set:Nx \l_tmpa_tl
          { \__pq_property:nn {#1}{difficulty} }
        \tl_if_eq:NNF \l_tmpa_tl \l__pq_filter_difficulty_tl
          { \bool_set_false:N \l__pq_filter_match_bool }
      }

    \tl_if_blank:VF \l__pq_filter_marks_tl
      {
        \tl_set:Nx \l_tmpa_tl
          { \__pq_property:nn {#1}{points} }
        \fp_compare:nF { \l_tmpa_tl = \l__pq_filter_marks_tl }
          { \bool_set_false:N \l__pq_filter_match_bool }
      }

    \clist_if_empty:NF \l__pq_filter_tags_clist
      {
        \tl_set:Nx \l_tmpa_tl
          { \__pq_property:nn {#1}{tag-labels} }
        \clist_set:NV \l__pq_record_tags_clist \l_tmpa_tl
        \clist_map_inline:Nn \l__pq_filter_tags_clist
          {
            \clist_if_in:NnF \l__pq_record_tags_clist {##1}
              { \bool_set_false:N \l__pq_filter_match_bool }
          }
      }

    \bool_if:NTF \l__pq_filter_match_bool
      { \prg_return_true: }
      { \prg_return_false: }
  }

\cs_new_protected:Npn \__pq_select_ids:n #1
  {
    \clist_if_empty:nTF {#1}
      {
        \typeout{PQ4D-VALIDATION:EMPTY-ID-LIST}
        \ClassError{physicsquiz}
          {The~question~ID~selection~is~empty}
          {Supply one or more declared stable IDs.}
      }
      {
        \clist_map_inline:nn {#1}
          {
            \tl_set:Nn \l_tmpa_tl {##1}
            \tl_trim_spaces:N \l_tmpa_tl
            \seq_if_in:NVTF \g__pq_question_ids_seq \l_tmpa_tl
              { \__pq_selection_add:V \l_tmpa_tl }
              { \exp_args:NV \__pq_unknown_selection_id:n \l_tmpa_tl }
          }
      }
  }

\cs_new_protected:Npn \__pq_select_by_metadata:n #1
  {
    \__pq_reset_filter_keys:
    \keys_set:nn { physicsquiz / selection } {#1}
    \__pq_validate_filter:
    \int_zero:N \l__pq_filter_match_int
    \seq_map_inline:Nn \g__pq_question_ids_seq
      {
        \__pq_record_matches:nT {##1}
          {
            \int_incr:N \l__pq_filter_match_int
            \__pq_selection_add:n {##1}
          }
      }
    \int_compare:nNnF {\l__pq_filter_match_int} > {0}
      {
        \typeout{PQ4D-VALIDATION:NO-MATCH}
        \ClassError{physicsquiz}
          {No~questions~match~the~metadata~filter}
          {Check topic, difficulty, marks, and tag values against the bank.}
      }
  }

\cs_new_protected:Npn \__pq_select_all:
  {
    \seq_map_inline:Nn \g__pq_question_ids_seq
      { \__pq_selection_add:n {##1} }
  }

% Phase 4E uses a class-owned Park--Miller generator rather than an engine
% random primitive.  The same seed and candidate order therefore produce the
% same permutation across supported TeX engines.  Schrage's method keeps every
% intermediate value inside TeX's signed 32-bit integer range.
\cs_generate_variant:Nn \seq_set_item:Nnn { NnV }

\cs_new_protected:Npn \__pq_random_invalid_count:n #1
  {
    \typeout{PQ4E-VALIDATION:INVALID-COUNT:#1}
    \ClassError{physicsquiz}
      {Invalid~random-selection~count:~#1}
      {Use a positive integer not greater than the number of eligible records.}
    \int_set:Nn \l__pq_random_count_int {1}
  }

\cs_new_protected:Npn \__pq_random_invalid_seed:n #1
  {
    \typeout{PQ4E-VALIDATION:INVALID-SEED:#1}
    \ClassError{physicsquiz}
      {Invalid~random-selection~seed:~#1}
      {Use an integer from 1 to 2147483646.}
    \int_set:Nn \l__pq_random_seed_int {1}
  }

\cs_new_protected:Npn \__pq_random_parse_count:n #1
  {
    \tl_set:Nn \l_tmpa_tl {#1}
    \tl_trim_spaces:N \l_tmpa_tl
    \exp_args:NnV \regex_match:nnTF
      { \A [1-9][0-9]* \Z }
      \l_tmpa_tl
      {
        \fp_compare:nTF { \l_tmpa_tl <= 2147483646 }
          { \int_set:Nn \l__pq_random_count_int { \l_tmpa_tl } }
          { \exp_args:NV \__pq_random_invalid_count:n \l_tmpa_tl }
      }
      { \exp_args:NV \__pq_random_invalid_count:n \l_tmpa_tl }
  }

\cs_new_protected:Npn \__pq_random_parse_seed:n #1
  {
    \tl_set:Nn \l_tmpa_tl {#1}
    \tl_trim_spaces:N \l_tmpa_tl
    \exp_args:NnV \regex_match:nnTF
      { \A [1-9][0-9]* \Z }
      \l_tmpa_tl
      {
        \fp_compare:nTF { \l_tmpa_tl <= 2147483646 }
          { \int_set:Nn \l__pq_random_seed_int { \l_tmpa_tl } }
          { \exp_args:NV \__pq_random_invalid_seed:n \l_tmpa_tl }
      }
      { \exp_args:NV \__pq_random_invalid_seed:n \l_tmpa_tl }
  }

\cs_new_protected:Npn \__pq_random_next:
  {
    \int_set:Nn \l_tmpa_int
      { \int_div_truncate:nn { \l__pq_random_state_int } {127773} }
    \int_set:Nn \l_tmpb_int
      { \int_mod:nn { \l__pq_random_state_int } {127773} }
    \int_set:Nn \l__pq_random_state_int
      { 16807 * \l_tmpb_int - 2836 * \l_tmpa_int }
    \int_compare:nNnT { \l__pq_random_state_int } < {1}
      { \int_add:Nn \l__pq_random_state_int {2147483647} }
  }

\cs_new_protected:Npn \__pq_random_index:n #1
  {
    \int_set:Nn \l__pq_random_limit_int
      { \int_div_truncate:nn {2147483646} {#1} * #1 }
    \bool_do_until:nn
      {
        \int_compare_p:nNn
          { \l__pq_random_state_int }
          <
          { \l__pq_random_limit_int + 1 }
      }
      { \__pq_random_next: }
    \int_set:Nn \l__pq_random_index_int
      { 1 + \int_mod:nn { \l__pq_random_state_int - 1 } {#1} }
  }

\cs_new_protected:Npn \__pq_random_shuffle:
  {
    \seq_set_eq:NN \l__pq_random_pool_seq \l__pq_random_candidates_seq
    \int_step_inline:nnnn
      { \seq_count:N \l__pq_random_pool_seq } {-1} {2}
      {
        \__pq_random_index:n {##1}
        \tl_set:Nx \l_tmpa_tl
          { \seq_item:Nn \l__pq_random_pool_seq {##1} }
        \tl_set:Nx \l_tmpb_tl
          { \seq_item:Nn \l__pq_random_pool_seq {\l__pq_random_index_int} }
        \seq_set_item:NnV \l__pq_random_pool_seq {##1} \l_tmpb_tl
        \seq_set_item:NnV \l__pq_random_pool_seq
          {\l__pq_random_index_int} \l_tmpa_tl
      }
  }

\cs_new_protected:Npn \__pq_select_random:nnn #1#2#3
  {
    \__pq_random_parse_count:n {#2}
    \__pq_random_parse_seed:n {#3}
    \__pq_reset_filter_keys:
    \keys_set:nn { physicsquiz / selection } {#1}
    \__pq_validate_filter_values:

    \seq_clear:N \l__pq_random_candidates_seq
    \seq_map_inline:Nn \g__pq_question_ids_seq
      {
        \__pq_record_matches:nT {##1}
          {
            \seq_if_in:NnF \g__pq_selected_ids_seq {##1}
              { \seq_put_right:Nn \l__pq_random_candidates_seq {##1} }
          }
      }

    \seq_if_empty:NTF \l__pq_random_candidates_seq
      {
        \typeout{PQ4E-VALIDATION:NO-CANDIDATES}
        \ClassError{physicsquiz}
          {No~eligible~questions~remain~for~random~selection}
          {Check the filter or clear the current selection before trying again.}
      }
      {
        \int_compare:nNnTF
          { \l__pq_random_count_int }
          >
          { \seq_count:N \l__pq_random_candidates_seq }
          {
            \typeout{PQ4E-VALIDATION:COUNT-EXCEEDS-CANDIDATES:\int_use:N \l__pq_random_count_int/\seq_count:N \l__pq_random_candidates_seq}
            \ClassError{physicsquiz}
              {Random-selection~count~exceeds~the~eligible~candidate~count}
              {Request no more than \seq_count:N \l__pq_random_candidates_seq\space record(s).}
          }
          {
            \typeout{PQ4E-RANDOM:ALGORITHM=park-miller-v1}
            \typeout{PQ4E-RANDOM:SEED=\int_use:N \l__pq_random_seed_int}
            \typeout{PQ4E-RANDOM:COUNT=\int_use:N \l__pq_random_count_int}
            \typeout{PQ4E-RANDOM:POOL=\seq_count:N \l__pq_random_candidates_seq}
            \seq_map_inline:Nn \l__pq_random_candidates_seq
              { \typeout{PQ4E-RANDOM:CANDIDATE=##1} }
            \int_set_eq:NN \l__pq_random_state_int \l__pq_random_seed_int
            \__pq_random_shuffle:
            \int_step_inline:nn { \l__pq_random_count_int }
              {
                \tl_set:Nx \l_tmpa_tl
                  { \seq_item:Nn \l__pq_random_pool_seq {##1} }
                \typeout{PQ4E-RANDOM:PICK=\tl_use:N \l_tmpa_tl}
                \__pq_selection_add:V \l_tmpa_tl
              }
          }
      }
  }

\cs_new_protected:Npn \__pq_selection_total:
  {
    \fp_zero:N \l__pq_selection_total_fp
    \seq_map_inline:Nn \g__pq_selected_ids_seq
      {
        \fp_add:Nn \l__pq_selection_total_fp
          { \__pq_property:nn {##1}{points} }
      }
  }

\NewDocumentEnvironment{quizbank}{}
  { \typeout{PQ4D-BANK:BEGIN} }
  {
    \__pq_validate_solutions:
    \tl_gclear:N \g__pq_last_id_tl
    \typeout{PQ4D-BANK:END}
  }

% Backward-compatible 4C wrapper: declare the enclosed records, select just
% those newly declared records, and print them as one booklet.
\NewDocumentEnvironment{quizquestionbank}{ O{2} }
  {
    \int_gset:Nn \g__pq_compat_start_int
      { \seq_count:N \g__pq_question_ids_seq }
  }
  {
    \__pq_validate_solutions:
    \seq_gclear:N \g__pq_selected_ids_seq
    \seq_map_indexed_inline:Nn \g__pq_question_ids_seq
      {
        \int_compare:nNnT {##1} > {\g__pq_compat_start_int}
          { \__pq_selection_add:n {##2} }
      }
    \tl_gclear:N \g__pq_last_id_tl
    \printquizquestions[#1]
  }

\NewDocumentCommand \quizclearselection {}
  {
    \seq_gclear:N \g__pq_selected_ids_seq
    \__pq_reset_shuffle:
  }

\NewDocumentCommand \quizselectids {m}
  { \__pq_select_ids:n {#1} }

\NewDocumentCommand \quizselect {O{}}
  { \__pq_select_by_metadata:n {#1} }

\NewDocumentCommand \quizselectall {}
  { \__pq_select_all: }

\NewDocumentCommand \quizselectrandom { O{} m m }
  { \__pq_select_random:nnn {#1}{#2}{#3} }

\NewDocumentCommand \printquizquestions {O{2}}
  {
    \__pq_require_selection:
    \ifpq@show@questions
      \typeout{PQ4C-CONTENT:QUESTIONS}
      \typeout{PQ4D-CONTENT:SELECTED-QUESTIONS}
      \section{Generated~Question~Booklet}
      % Render the established constants box when the author has supplied
      % constants through \quizconstants.  Manually authored quizzes call
      % \constantsbox themselves; only the Phase 4 generated booklet reaches
      % this code, so no existing document can receive a duplicated box.
      \exp_args:No \tl_if_blank:nF { \QuizConstants } { \constantsbox }
      \begin{quizquestions}[#1]
        \seq_map_inline:Nn \g__pq_selected_ids_seq
          {
            \typeout{PQ4D-QUESTION:##1}
            \tl_gset:Nn \g__pq_current_id_tl {##1}
            \printexercise{exercise}{##1}
            \tl_gclear:N \g__pq_current_id_tl
          }
      \end{quizquestions}
    \fi
  }

\NewDocumentCommand \printquizanswerkey {}
  {
    \__pq_require_selection:
    \typeout{PQ4C-CONTENT:ANSWERKEY}
    \begin{answerkey}
      \begin{description}[leftmargin=4.7em,labelwidth=4em,labelsep=0.7em]
        \int_zero:N \l_tmpa_int
        \seq_map_inline:Nn \g__pq_selected_ids_seq
          {
            \int_incr:N \l_tmpa_int
            \typeout{PQ4C-ANSWER:##1=\__pq_effective_letter:n {##1}}
            \item[Question~\int_use:N \l_tmpa_int]~\textbf{\__pq_effective_letter:n {##1}}
            \quad\textcolor{QuizGrey}{\small(##1)}
          }
      \end{description}
      \medskip
      \__pq_selection_total:
      \textbf{Total~marks:}~\fp_to_decimal:N \l__pq_selection_total_fp.
    \end{answerkey}
  }

\NewDocumentCommand \printquiztopicreport {}
  {
    \__pq_require_selection:
    \typeout{PQ4C-CONTENT:TOPICS}
    \begin{tcolorbox}[
      colback=QuizLightGrey,colframe=QuizGrey,arc=2mm,boxrule=0.6pt,
      title={Generated~Topic~and~Metadata~Report},fonttitle=\bfseries
    ]
      \int_zero:N \l_tmpa_int
      \seq_map_inline:Nn \g__pq_selected_ids_seq
        {
          \int_incr:N \l_tmpa_int
          \typeout{PQ4C-RECORD:##1|\__pq_property:nn {##1}{topic-label}|\__pq_property:nn {##1}{difficulty}|\__pq_property:nn {##1}{points}}
          \textbf{\int_use:N \l_tmpa_int.}~\__pq_property:nn {##1}{topic-label};~
          \__pq_property:nn {##1}{difficulty};~
          \__pq_property:nn {##1}{points}~mark(s).\par
        }
    \end{tcolorbox}
  }

\NewDocumentCommand \printquizsolutions {}
  {
    \__pq_require_selection:
    \typeout{PQ4C-CONTENT:SOLUTIONS}
    \section{Generated~Worked~Solutions}
    \setcounter{pqselectedquestion}{0}
    \seq_map_inline:Nn \g__pq_selected_ids_seq
      {
        \stepcounter{pqselectedquestion}
        \tl_gset:Nn \g__pq_current_id_tl {##1}
        \printsolution{exercise}{##1}
        \tl_gclear:N \g__pq_current_id_tl
      }
  }

\NewDocumentCommand \printquizteacherreport {}
  {
    \__pq_require_selection:
    \typeout{PQ4C-CONTENT:TEACHER}
    \section{Teacher~Metadata}
    \begin{tcolorbox}[colback=QuizLightBlue,colframe=QuizBlue]
      \seq_map_inline:Nn \g__pq_selected_ids_seq
        {
          \tl_set:Nx \l_tmpa_tl { \__pq_property:nn {##1}{outcome} }
          \textbf{##1:}~
          \tl_if_blank:VTF \l_tmpa_tl
            {
              \typeout{PQ4C-OUTCOME:##1=NONE}
              \textcolor{QuizGrey}{\small No~learning~outcome~supplied.}
            }
            {
              \typeout{PQ4C-OUTCOME:##1=SET}
              \tl_use:N \l_tmpa_tl.
            }
          \par
          \textcolor{QuizGrey}{\small Tags:~\__pq_property:nn {##1}{tag-labels}}\par\smallskip
        }
    \end{tcolorbox}
  }

% Regression assertion for structured-bank fixtures.  It is public enough for
% project tests, but ordinary quiz documents do not need to call it.
\NewDocumentCommand \quizbankassert { m m }
  {
    \int_compare:nNnTF { \numberofusedexercises } = {#1}
      { \typeout{PQ4C-COUNT:#1} }
      {
        \ClassError{physicsquiz}
          {Question-count~assertion~failed}
          {Expected #1 stored records.}
      }
    \fp_zero:N \l__pq_assert_total_fp
    \ForEachUsedExerciseByType
      {
        \fp_add:Nn \l__pq_assert_total_fp
          { \ExercisePropertyGet{##1}{##2}{points} }
      }
    \fp_compare:nTF { \l__pq_assert_total_fp = #2 }
      { \typeout{PQ4C-TOTAL:#2} }
      {
        \ClassError{physicsquiz}
          {Marks-total~assertion~failed}
          {Expected a total of #2 marks.}
      }
    \typeout{PQ4C-BACKEND:XSIM}
  }

\NewDocumentCommand \quizselectionassert { m m m }
  {
    \int_compare:nNnTF { \seq_count:N \g__pq_selected_ids_seq } = {#1}
      { \typeout{PQ4D-COUNT:#1} }
      {
        \ClassError{physicsquiz}
          {Selection-count~assertion~failed}
          {Expected #1 selected records.}
      }
    \__pq_selection_total:
    \fp_compare:nTF { \l__pq_selection_total_fp = #2 }
      { \typeout{PQ4D-TOTAL:#2} }
      {
        \ClassError{physicsquiz}
          {Selection-marks~assertion~failed}
          {Expected #2 selected marks.}
      }
    \tl_set:Nx \l_tmpa_tl { \seq_use:Nn \g__pq_selected_ids_seq {,} }
    \tl_set:Nx \l_tmpb_tl {#3}
    \tl_if_eq:NNTF \l_tmpa_tl \l_tmpb_tl
      { \typeout{PQ4D-ORDER:#3} }
      {
        \ClassError{physicsquiz}
          {Selection-order~assertion~failed}
          {Expected the stable-ID order #3.}
      }
  }

% -------------------------------------------------
% Phase 4I: seeded option shuffling
% -------------------------------------------------
% Shuffling permutes the five slots of the \choices interface.  The permutation
% for a record is derived from the document seed and the record's declaration
% index, so it does not depend on selection order and is reproducible across
% engines.  It is computed for the whole selection before anything is rendered,
% because the answer key must report the shuffled letter even in answerkey-only
% output, where no booklet is typeset.
\prop_new:N \g__pq_shuffle_perm_prop
\prop_new:N \g__pq_shuffle_letter_prop
\tl_new:N   \g__pq_current_id_tl
\bool_new:N \g__pq_shuffled_bool
\bool_new:N \g__pq_from_choices_bool
\seq_new:N  \l__pq_choice_seq
\seq_new:N  \l__pq_perm_seq
\int_new:N  \l__pq_perm_pos_int
\int_new:N  \l__pq_orig_pos_int
\tl_new:N   \l__pq_letter_tl
\bool_new:N \l__pq_do_shuffle_bool

\cs_generate_variant:Nn \prop_item:Nn { NV }
\cs_generate_variant:Nn \prop_if_in:NnTF { NV }
\cs_generate_variant:Nn \str_case:nn { V }
\cs_generate_variant:Nn \prop_if_in:NnTF { NV }

\cs_new:Npn \__pq_effective_letter:n #1
  {
    \prop_if_in:NnTF \g__pq_shuffle_letter_prop {#1}
      { \prop_item:Nn \g__pq_shuffle_letter_prop {#1} }
      { \__pq_property:nn {#1}{correct} }
  }
\cs_generate_variant:Nn \__pq_effective_letter:n {V}

\cs_new_protected:Npn \__pq_shuffle_one:nn #1#2
  {
    % #1 = stable id, #2 = declaration index
    \int_set_eq:NN \l__pq_random_state_int \l__pq_random_seed_int
    \int_step_inline:nn {#2} { \__pq_random_next: }
    \seq_clear:N \l__pq_perm_seq
    \int_step_inline:nn {5}
      { \seq_put_right:Nn \l__pq_perm_seq {##1} }
    \int_step_inline:nnnn {5} {-1} {2}
      {
        \__pq_random_index:n {##1}
        \tl_set:Nx \l_tmpa_tl { \seq_item:Nn \l__pq_perm_seq {##1} }
        \tl_set:Nx \l_tmpb_tl
          { \seq_item:Nn \l__pq_perm_seq {\l__pq_random_index_int} }
        \seq_set_item:NnV \l__pq_perm_seq {##1} \l_tmpb_tl
        \seq_set_item:NnV \l__pq_perm_seq
          {\l__pq_random_index_int} \l_tmpa_tl
      }
    \tl_set:Nx \l_tmpa_tl { \seq_use:Nn \l__pq_perm_seq {,} }
    \prop_gput:NnV \g__pq_shuffle_perm_prop {#1} \l_tmpa_tl
    \typeout{PQ4I-PERM:#1=\tl_use:N \l_tmpa_tl}
    % Locate the display position now holding the originally correct slot.
    \tl_set:Nx \l__pq_letter_tl { \__pq_property:nn {#1}{correct} }
    \int_set:Nn \l__pq_orig_pos_int
      {
        \str_case:Vn \l__pq_letter_tl
          { {A}{1} {B}{2} {C}{3} {D}{4} {E}{5} }
      }
    \int_zero:N \l__pq_perm_pos_int
    \int_step_inline:nn {5}
      {
        \int_compare:nNnT
          { \seq_item:Nn \l__pq_perm_seq {##1} }
          =
          { \l__pq_orig_pos_int }
          { \int_set:Nn \l__pq_perm_pos_int {##1} }
      }
    \tl_set:Nx \l_tmpa_tl { \int_to_Alph:n { \l__pq_perm_pos_int } }
    \prop_gput:NnV \g__pq_shuffle_letter_prop {#1} \l_tmpa_tl
    \typeout{PQ4I-ANSWER:#1=\tl_use:N \l_tmpa_tl}
  }

\cs_new_protected:Npn \__pq_shuffle_options:n #1
  {
    \__pq_require_selection:
    \bool_if:NTF \g__pq_shuffled_bool
      {
        \typeout{PQ4I-VALIDATION:ALREADY-SHUFFLED}
        \ClassError{physicsquiz}
          {Option~shuffling~has~already~been~applied}
          {Call \quizshuffleoptions once, after the selection is complete.}
      }
      {
        \__pq_random_parse_seed:n {#1}
        \typeout{PQ4I-SHUFFLE:ALGORITHM=park-miller-v1}
        \typeout{PQ4I-SHUFFLE:SEED=\int_use:N \l__pq_random_seed_int}
        \seq_map_indexed_inline:Nn \g__pq_question_ids_seq
          {
            \seq_if_in:NnT \g__pq_selected_ids_seq {##2}
              { \__pq_shuffle_one:nn {##2}{##1} }
          }
        \bool_gset_true:N \g__pq_shuffled_bool
      }
  }

\cs_new_protected:Npn \__pq_reset_shuffle:
  {
    \prop_gclear:N \g__pq_shuffle_perm_prop
    \prop_gclear:N \g__pq_shuffle_letter_prop
    \bool_gset_false:N \g__pq_shuffled_bool
  }

% Shuffle-aware five-option interface.  The natural branch reproduces the
% established output token for token; the shuffled branch emits the same items
% in permuted order.
\cs_new_protected:Npn \__pq_choices:nnnnn #1#2#3#4#5
  {
    \bool_gset_true:N \g__pq_from_choices_bool
    \bool_set_false:N \l__pq_do_shuffle_bool
    \tl_if_blank:VF \g__pq_current_id_tl
      {
        \prop_if_in:NVT \g__pq_shuffle_perm_prop \g__pq_current_id_tl
          { \bool_set_true:N \l__pq_do_shuffle_bool }
      }
    \bool_if:NTF \l__pq_do_shuffle_bool
      {
        \seq_clear:N \l__pq_choice_seq
        \seq_put_right:Nn \l__pq_choice_seq {#1}
        \seq_put_right:Nn \l__pq_choice_seq {#2}
        \seq_put_right:Nn \l__pq_choice_seq {#3}
        \seq_put_right:Nn \l__pq_choice_seq {#4}
        \seq_put_right:Nn \l__pq_choice_seq {#5}
        \tl_set:Nx \l_tmpa_tl
          { \prop_item:NV \g__pq_shuffle_perm_prop \g__pq_current_id_tl }
        \begin{choiceoptions}
          \exp_args:NV \clist_map_inline:nn \l_tmpa_tl
            { \item \seq_item:Nn \l__pq_choice_seq {##1} }
        \end{choiceoptions}
      }
      {
        \begin{choiceoptions}
          \item #1
          \item #2
          \item #3
          \item #4
          \item #5
        \end{choiceoptions}
      }
    \bool_gset_false:N \g__pq_from_choices_bool
  }

\RenewDocumentCommand \choices { m m m m m }
  { \__pq_choices:nnnnn {#1}{#2}{#3}{#4}{#5} }

% A record whose options are authored with choiceoptions cannot be shuffled,
% because the class cannot know how many items the author will write.  Fail
% loudly rather than emit a booklet whose answer key is wrong.
\cs_new_protected:Npn \__pq_choiceoptions_guard:
  {
    \bool_set_false:N \l__pq_do_shuffle_bool
    \bool_if:NF \g__pq_from_choices_bool
      {
        \tl_if_blank:VF \g__pq_current_id_tl
          {
            \prop_if_in:NVT \g__pq_shuffle_perm_prop \g__pq_current_id_tl
              { \bool_set_true:N \l__pq_do_shuffle_bool }
          }
      }
    \bool_if:NT \l__pq_do_shuffle_bool
      {
        \typeout{PQ4I-VALIDATION:CHOICEOPTIONS-NOT-SHUFFLEABLE}
        \ClassError{physicsquiz}
          {Cannot~shuffle~a~choiceoptions~record}
          {Shuffling supports the five-option \choices interface only.}
      }
  }
\cs_set_eq:NN \pqchoiceoptionsguard \__pq_choiceoptions_guard:

\NewDocumentCommand \quizshuffleoptions { m }
  { \__pq_shuffle_options:n {#1} }

\NewDocumentCommand \quizcorrectletter {}
  {
    \tl_if_blank:VTF \g__pq_current_id_tl
      {
        \typeout{PQ4I-VALIDATION:NO-CURRENT-RECORD}
        \ClassError{physicsquiz}
          {\quizcorrectletter~used~outside~a~rendered~record}
          {Use it inside a quizsolution body or a generated section.}
      }
      { \__pq_effective_letter:V \g__pq_current_id_tl }
  }

\NewDocumentCommand \quizshuffleassert { m }
  {
    \tl_set:Nx \l_tmpa_tl
      {
        \seq_use:Nn \g__pq_selected_ids_seq {,}
      }
    \tl_clear:N \l_tmpb_tl
    \seq_map_inline:Nn \g__pq_selected_ids_seq
      {
        \tl_put_right:Nx \l_tmpb_tl
          {
            \tl_if_empty:NF \l_tmpb_tl {,}
            \__pq_effective_letter:n {##1}
          }
      }
    \tl_set:Nx \l_tmpa_tl {#1}
    \tl_if_eq:NNTF \l_tmpa_tl \l_tmpb_tl
      { \typeout{PQ4I-LETTERS:#1} }
      {
        \ClassError{physicsquiz}
          {Shuffled-answer~assertion~failed}
          {Expected #1 but obtained \tl_use:N \l_tmpb_tl.}
      }
  }

% -------------------------------------------------
% Phase 4J: version manifest
% -------------------------------------------------
% A version names a selection recipe and its own shuffle seed.  One compile
% produces one version, so pagination, numbering, and the answer key stay
% unambiguous, and the Phase 3 \quizversion header metadata finally carries a
% question-level meaning.
\prop_new:N \g__pq_version_prop
\tl_new:N   \g__pq_active_version_tl

\cs_new_protected:Npn \__pq_define_version:nn #1#2
  {
    \prop_if_in:NnTF \g__pq_version_prop {#1}
      {
        \typeout{PQ4J-VALIDATION:DUPLICATE-VERSION:#1}
        \ClassError{physicsquiz}
          {Duplicate~version~label:~#1}
          {Every quizdefineversion label must be unique.}
      }
      {
        \prop_gput:Nnn \g__pq_version_prop {#1} {#2}
        \typeout{PQ4J-VERSION-DEFINED:#1}
      }
  }

\cs_new_protected:Npn \__pq_use_version:n #1
  {
    % The label is expanded, so a build script may pass a macro.
    \tl_set:Nx \l__pq_letter_tl {#1}
    \tl_if_blank:VF \g__pq_active_version_tl
      {
        \typeout{PQ4J-VALIDATION:VERSION-ALREADY-ACTIVE}
        \ClassError{physicsquiz}
          {A~version~is~already~active}
          {One compile produces one version; call \quizuseversion once.}
      }
    \prop_if_in:NVTF \g__pq_version_prop \l__pq_letter_tl
      {
        \seq_gclear:N \g__pq_selected_ids_seq
        \__pq_reset_shuffle:
        \tl_gset_eq:NN \g__pq_active_version_tl \l__pq_letter_tl
        \typeout{PQ4J-VERSION:\tl_use:N \l__pq_letter_tl}
        \exp_args:NV \quizversion \l__pq_letter_tl
        \prop_item:NV \g__pq_version_prop \l__pq_letter_tl
      }
      {
        \typeout{PQ4J-VALIDATION:UNKNOWN-VERSION:\tl_use:N \l__pq_letter_tl}
        \ClassError{physicsquiz}
          {Unknown~version~label:~#1}
          {Define the version with quizdefineversion before using it.}
      }
  }

\NewDocumentCommand \quizdefineversion { m +m }
  { \__pq_define_version:nn {#1}{#2} }

\NewDocumentCommand \quizuseversion { m }
  { \__pq_use_version:n {#1} }

\NewDocumentCommand \quizversionassert { m }
  {
    \tl_set:Nx \l_tmpa_tl { \g__pq_active_version_tl }
    \tl_set:Nx \l_tmpb_tl {#1}
    \tl_if_eq:NNTF \l_tmpa_tl \l_tmpb_tl
      { \typeout{PQ4J-ACTIVE:#1} }
      {
        \ClassError{physicsquiz}
          {Active-version~assertion~failed}
          {Expected version #1.}
      }
  }

\ExplSyntaxOff

% -------------------------------------------------
% Utility command
% -------------------------------------------------
% Define \unit only if not already defined to avoid redefinition errors
\providecommand{\unit}[1]{\,\mathrm{#1}}
