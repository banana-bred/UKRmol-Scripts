# Settings related to a specific installation of UK R-matrix codes

# Path to executables can be spicified directly in %dirs or later if you are using several computers
# (see switch($run{'computer'}) below
# Use ${bs} (see dirfile.pm) in relative paths instead of \ or / for portability
# Some directories are determined later automatically
# If the full path must be used then it is not necessary to use ${bs}

%dirs = (

  'bin_in',    "/home/jakub/Software/ukrmolp-3.2/bin",  # Directory where executables of UKRmol-in are
  'bin_out',   "/home/jakub/Software/ukrmolp-3.2/bin",    # Directory where executables of UKRmol-out are
  'molpro',    "",  # Directory where executables of MOLPRO are
  'psi4',      "/home/jakub/Software/psi4-1.7/bin",  # Directory where executables of PSI4 are
  'molcas',    "",  # Directory where executables of MOLCAS are

  'basis',     "/scratch.ssd/codes/ukrmol-scripts/basis.sets",         # Directory where basis sets are - templates named 'swmol3.A.$basis' or 'molpro.A.$basis' where 'A' stands for an atom
  'templates', "/scratch.ssd/codes/ukrmol-scripts/input.templates",    # Directory where input templates are - read if 'use_templates' = 1
  'output',    "output",                                 # Main directory for output in the working directory

);
