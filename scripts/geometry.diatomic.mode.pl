# Displacement of a diatomic molecule. Some geometry intervals are more dense than others due to resonances
# (easier to resolve with finer spacing in R)
#
# Geometries can be specified either manually in the array 'geometries'
# by copying what is between start copy and end copy for each geometry
# or automatically as shown below the hash array %geometry
#
# Note that 'length_unit' should be set to the actual length unit used for values in 'atoms' array,
# later (in &generate_geometries) $model{'r_unit'} is set also to this unit for consistency reasons
#
# Note that there's a restriction on the orientation of the molecules in the scripts (although there isn't one in the codes themselves)
# Your molecular target should be oriented as follows for the corresponding point groups ('any orientation' still requires the axes to
# be along the cartesian axes):
# D2h: any orientation
# C2v: C2 axis along Z
# C2h: C2 axis along Z
# D2:  any orientation
# C2:  C2 axis along Z
# Cs:  Molecule in the YZ plane
# Ci:  any orientation
# C1:  any orientation

%geometry = (

  # 'suffix', ".quartet.mixedgrid.CoC",   # string added to model directory to distinguish runs
  'suffix', ".test",   # string added to model directory to distinguish runs
                              # with different geometry settings

  'geometry_labels',  "   R       Theta    ",         # labels used on the first line of output files
                                          # it should correspond to numbers given in 'geometries'->'description'
  'correct_cm',   0,                      # correct the center of mass to be at the origin
  'length_unit',  1,                      # 0 - atomic units, 1 - Angstroms

  'geometries', [
    # { 'description', sprintf("%8.5f", $R),
    #   'gnuplot_desc', "R = ".sprintf("%5.2f", $R), # used in gnuplot files for keys
    #    # specify ALL atoms (even redundant with respect to symmetry elements)
    #    'atoms', [ [ "O", 0.000000000000,     0.000000000000,     0.512907709005],
    #               [ "H", 0.000000000000,     0.000000000000,    -0.487092290995] ]
    #  },
  ],

  # the following option can be used e.g. to continue an interupted run
  # all geometries are generated but codes will run only for specified geometries
  'start_at_geometry', 1,                # codes will run only for geometries with index >= than this number
  'stop_at_geometry',  0,               # this can be used to stop at certain geometry
                                         # if zero then codes will run for all geometries
);

# Here is an example of automatic generation of geometries.
# Specifically the symmetric stretch of the water molecule is generated.
# If you want to use this then comment first the part in %geometry between # start copy ... # end copy
# and change 'suffix' and 'geometry_labels' in %geometry accordingly,
# e.g. as ".sym_stretch.theta104.48.r1.6-0.2-2.6" and "     O-H     "
#

# -- center of charge coordinates near minimum configuration (Å)
my $O0 =  0.512907709005;
my $H0 = -0.487092290995;
my $R0 = $O0 - $H0;

# -- fraction by which to displace each atom (1/2 = evenly)
my $ORfraction = 1.0 / 2.0;
my $HRfraction = 1.0 / 2.0;

# -- internuclear distances split up into 3 sections
my $bohr2ang = 0.52917721090299996;
my $Ri = 1.5  * $bohr2ang;
my $Rf = 2.35 * $bohr2ang;
my $dR = 0.01 * $bohr2ang;


# -- before the targeted resonance
for (my $R = $Ri; $R <= $Rf; $R += $dR) {
  $dRO = ($R - $R0) * $ORfraction;
  $dRH = ($R - $R0) * $HRfraction;
  push(@{$geometry{'geometries'}},
       { 'description', sprintf("%8.5f", $R),
         'gnuplot_desc', "R = ".sprintf("%5.2f", $R), # used in gnuplot files for keys
         'atoms', [ [ "O", 0.0,  0.0,  $O0 + $dRO ],
                    [ "H", 0.0,  0.0,  $H0 - $dRH ] ]
       }
  );
}

my $Ri = 2.352 * $bohr2ang;
my $Rf = 2.45 * $bohr2ang;
my $dR = 0.002 * $bohr2ang;


# -- around the targeted resonance
for (my $R = $Ri; $R <= $Rf; $R += $dR) {
  $dRO = ($R - $R0) * $ORfraction;
  $dRH = ($R - $R0) * $HRfraction;
  push(@{$geometry{'geometries'}},
       { 'description', sprintf("%8.5f", $R),
         'gnuplot_desc', "R = ".sprintf("%5.2f", $R), # used in gnuplot files for keys
         'atoms', [ [ "O", 0.0,  0.0,  $O0 + $dRO ],
                    [ "H", 0.0,  0.0,  $H0 - $dRH ] ]
       }
  );
}

my $Ri = 2.46 * $bohr2ang;
my $Rf = 2.85 * $bohr2ang;
my $dR = 0.01 * $bohr2ang;

# -- after the targeted resonance
for (my $R = $Ri; $R <= $Rf; $R += $dR) {
  $dRO = ($R - $R0) * $ORfraction;
  $dRH = ($R - $R0) * $HRfraction;
  push(@{$geometry{'geometries'}},
       { 'description', sprintf("%8.5f", $R),
         'gnuplot_desc', "R = ".sprintf("%5.2f", $R), # used in gnuplot files for keys
         'atoms', [ [ "O", 0.0,  0.0,  $O0 + $dRO ],
                    [ "H", 0.0,  0.0,  $H0 - $dRH ] ]
       }
  );
}
