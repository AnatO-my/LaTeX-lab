% ============================================================
% OT Science Notes Styler
% otscience.cls
% Version: 0.3
%
% Composition (PLAN.md Phase D):
%   base class   article (11pt, A4)
%   foundations  otcore (facade: otcolors + otlayout + table/date packages),
%                ottheme (palette + OT link policy)
%   preset       otscience-theme (shared with otbook)
%   boxes        otboxes primitives, otsciboxes semantic family
%   bundle       otnotation, otmath, ottensors, otphysics, otcoordinates,
%                otpractice, otfigures (skipped with the `minimal' option)
% ============================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{otscience}[2026/11/11 v0.3 OT Science Notes Styler]

% -----------------------------
% Class options
% -----------------------------
% minimal: skip the companion-package bundle loaded at the end of the class.
% Other options keep their previous behaviour: they are not passed to
% article, but remain visible to packages as global options.
\newif\ifotscience@minimal\otscience@minimalfalse
\DeclareOption{minimal}{\otscience@minimaltrue}
\ProcessOptions\relax

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
\RequirePackage{otsciboxes}
\RequirePackage{cleveref}

\tcbuselibrary{theorems,listings}

% -----------------------------
% Visual preset
% -----------------------------
% otscience-theme supplies quantity formatting, list spacing and heading
% colours shared with otbook.
\RequirePackage{otscience-theme}

% -----------------------------
% Page style
% -----------------------------
\otsciencepagestyle{OT Science Notes}

% -----------------------------
% Standard science boxes
% -----------------------------
% definitionbox, theorembox, lawbox, formulabox, derivationbox, examplebox,
% warningbox, intuitionbox, summarybox, experimentbox and their nosplit
% variants are provided by otsciboxes.sty (loaded above).

% -----------------------------
% Companion-package bundle
% -----------------------------
% These companions ship with the class in the LaTeX-lab author kit and are
% loaded unconditionally, so every installation yields the same commands.
% A missing companion now stops with a clear "File not found" error
% instead of silently removing its commands. The class option `minimal'
% skips this bundle; load the companions you need with \usepackage.
\ifotscience@minimal\else
  \RequirePackage{otnotation}
  \RequirePackage{otmath}
  \RequirePackage{ottensors}
  \RequirePackage{otphysics}
  \RequirePackage{otcoordinates}
  \RequirePackage{otpractice}
  \RequirePackage{otfigures}
\fi

\endinput
