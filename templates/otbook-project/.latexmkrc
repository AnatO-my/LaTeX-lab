# Run latexmk from this project's root directory.
use Cwd qw(abs_path);

# In the repository, ../.. is LaTeX-lab. For a copied project, replace it
# with your LaTeX-lab path, or set the LATEX_LAB_ROOT environment variable.
my $latex_lab = $ENV{'LATEX_LAB_ROOT'} || '../..';
$latex_lab = abs_path($latex_lab);
die "Set LATEX_LAB_ROOT or edit .latexmkrc to point to LaTeX-lab.\n"
    unless defined $latex_lab
        && -f "$latex_lab/src/classes/otbook.cls"
        && -d "$latex_lab/src/packages";
$latex_lab =~ s{\\}{/}g;

my $separator = $^O eq 'MSWin32' ? ';' : ':';
$ENV{'TEXINPUTS'} = join(
    $separator,
    '.',
    "$latex_lab/src/classes",
    "$latex_lab/src/packages",
    ($ENV{'TEXINPUTS'} // ''),
    ''
);

$pdf_mode = 1;
$do_cd = 0;
$aux_dir = 'build/aux';
$out_dir = 'build/pdf';
$pdflatex =
    'pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error -file-line-error %O %S';
