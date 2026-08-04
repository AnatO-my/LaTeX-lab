# Project-local latexmk configuration for LaTeX-Lab

use Cwd qw(abs_path);

# The command must be launched from the repository root.
# This path is captured before $do_cd changes to the document directory.
my $project_root = abs_path('.');
$project_root =~ s{\\}{/}g;

# Add project-local classes and packages while retaining MiKTeX defaults.
my $path_separator = $^O eq 'MSWin32' ? ';' : ':';

my $project_inputs = join(
    $path_separator,
    "$project_root/src/classes",
    "$project_root/src/packages"
);

if (defined $ENV{'TEXINPUTS'} && length $ENV{'TEXINPUTS'}) {
    $ENV{'TEXINPUTS'} =
        $project_inputs . $path_separator . $ENV{'TEXINPUTS'};
} else {
    $ENV{'TEXINPUTS'} =
        $project_inputs . $path_separator;
}

# Build directly with pdfLaTeX.
$pdf_mode = 1;

# Process each root document from its own directory.
$do_cd = 1;

# Enable SyncTeX and clear file-and-line diagnostics.
$pdflatex =
    'pdflatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# Make repository classes visible to TeX.
my $class_dir = './src/classes//';
my $separator = ($^O eq 'MSWin32') ? ';' : ':';
$ENV{'TEXINPUTS'} =
    $class_dir . $separator . ($ENV{'TEXINPUTS'} // '');
