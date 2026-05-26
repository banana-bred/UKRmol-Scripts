# Settings related to a specific installation of UK R-matrix codes

# Path to executables can be spicified directly in %dirs or later if you are using several computers
# (see switch($run{'computer'}) below
# Use ${bs} (see dirfile.pm) in relative paths instead of \ or / for portability
# Some directories are determined later automatically
# If the full path must be used then it is not necessary to use ${bs}

%dirs = (

  'bin_in',    "/home/alex/Code/git_repos/UKRmolp/UKRmol-in/build/bin",  # Directory where executables of UKRmol-in are
  'bin_out',   "/home/alex/Code/git_repos/UKRmolp/UKRmol-in/build/bin",    # Directory where executables of UKRmol-out are
  'molpro',    "/home/alex/bin",  # Directory where executables of MOLPRO are
  'psi4',      "/opt/psi4-1.2.1/bin",  # Directory where executables of PSI4 are
  'molcas',    "/home/alex/bin",  # Directory where executables of MOLCAS are

  'basis',     "/home/alex/Code/git_repos/UKRmol-scripts/basis.sets",         # Directory where basis sets are - templates named 'swmol3.A.$basis' or 'molpro.A.$basis' where 'A' stands for an atom
  'templates', "/home/alex/Code/git_repos/UKRmol-scripts/input.templates",    # Directory where input templates are - read if 'use_templates' = 1
  'libs',      "/home/alex/Code/git_repos/UKRmol-scripts/lib",                # Directory where UKRmol-scripts libraries are (equivalent to perl -I<libs>, or use of PERL5LIB)

  'output',    "output",                                 # Main directory for output in the working directory

);
