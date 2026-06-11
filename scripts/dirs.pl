# Settings related to a specific installation of UK R-matrix codes

# Path to executables can be spicified directly in %dirs or later if you are using several computers
# (see switch($run{'computer'}) below
# Use ${bs} (see dirfile.pm) in relative paths instead of \ or / for portability
# Some directories are determined later automatically
# If the full path must be used then it is not necessary to use ${bs}

%dirs = (

  'bin_in',    "",  # Directory where executables of UKRmol-in are
  'bin_out',   "",  # Directory where executables of UKRmol-out are
  'molpro',    "",  # Directory where executables of MOLPRO are
  'psi4',      "",  # Directory where executables of PSI4 are
  'molcas',    "",  # Directory where executables of MOLCAS are

  'basis',     "../basis.sets",         # Directory where basis sets are - templates named 'swmol3.A.$basis' or 'molpro.A.$basis' where 'A' stands for an atom
  'templates', "../input.templates",    # Directory where input templates are - read if 'use_templates' = 1
  'libs',      "../lib",                # Directory where UKRmol-scripts libraries are (equivalent to perl -I<libs>, or use of PERL5LIB)

  'output',    "output",                                 # Main directory for output in the working directory

);
