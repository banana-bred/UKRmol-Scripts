# Here is an example of setting up geometries when you have an equilibrium geometry that you
# want to stretch in the direction of normal modes. The normal modes must take the form of a 
# displacement from the equilibrium geometry (e.g. as obtained from a GAUSSIAN calculation).

%geometry = (

  'suffix', ".mode",          # string added to model directory to distinguish runs
                              # with different geometry settings

  'geometry_labels', " Note", # labels used on the first line of output files
                              # it should correspond to numbers given in 'geometries'->'description'
  'correct_cm',   1,          # correct the center of mass to be at the origin
  'length_unit',  0,          # 0 - atomic units, 1 - Angstroms
                              # this is actually set later by &read_geometries_from_files_in_molden_format   

  'geometries', [
                              # Only one geometry must be entered here: the one corresponding to the initial
                              # (equilibrium) geometry from which the displaced geometries will be calculated.
       { 'description', "",    # string to use in output files to describe this particular geometry, will be set automatically
         'gnuplot_desc', "",   # used in gnuplot files for keys, will be set automatically
         # specify ALL atoms (even redundant with respect to symmetry elements) 
         'atoms',[ ["C", 0.98579, 0.71408, 0],
                   ["C", 0.98579, -0.71408, 0],
                   ["C", -0.33363, 1.12733, 0],
                   ["H", 1.85395, 1.36595, 0],
                   ["C", -0.33363, -1.12733, 0],
                   ["H", 1.85395, -1.36595, 0],
                   ["N", -1.12333, 0, 0],
                   ["H", -0.76957, 2.12015, 0],
                   ["H", -0.76958, -2.12015, 0],
                   ["H", -2.13148, 0, 0], ]
       },
 ],

  # the following option can be used e.g. to continue an interupted run
  # all geometries are generated but codes will run only for specified geometries
  'start_at_geometry', 1,               # codes will run only for geometries with index >= than this number
  'stop_at_geometry',  0,               # this can be used to stop at a certain geometry 
                                        # if zero then codes will run for all geometries
);

# An array of file names containing the normal mode displacements.
@mode_files = ("v1_pyrrole","v13_pyrrole");

# Array of arrays of q-factors that will multiply each normal mode displacement to generate the 
# different geometries by adding them to the equilibrium geometry specified above.
@q_factors = ([0.7,0.8,0.9,1.0,1.2,1.3,1.4,1.6,1.8,2.0],[-3.0,-2.0,-1.5,-1.0,-0.5,0.0,0.5,1.0,1.5,2.0,3.0]);

$save_geoms_to_disk = 0; #if set to 1 each geometry generated will be saved to a separate file with name `geom_X`.

&construct_geometries_from_normal_modes(\@mode_files, \@q_factors, $save_geoms_to_disk, \%geometry);

# Example of the contents of the file containing the normal mode. It is a simple text file containing
# the displacement vectors wrt equilibrium for each atom in the order in which the equilibirium coordinates
# of the atoms are specified in 'geometries' above.
#
# 0.00   0.00   0.07
# 0.00   0.00   0.07
# 0.00   0.00  -0.08
# 0.00   0.00  -0.44
# 0.00   0.00  -0.08
# 0.00   0.00  -0.44
# 0.00   0.00   0.01
# 0.00   0.00   0.53
# 0.00   0.00   0.53
# 0.00   0.00  -0.16
