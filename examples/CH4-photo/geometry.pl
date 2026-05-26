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

  'suffix', ".cccbdb",        # string added to model directory to distinguish runs
                              # with different geometry settings

  'geometry_labels',  "",                 # labels used on the first line of output files
                                          # it should correspond to numbers given in 'geometries'->'description'
  'correct_cm',   0,                      # correct the center of mass to be at the origin
  'length_unit',  1,                      # 0 - atomic units, 1 - Angstroms   

  'geometries', [
       # start copy
       { 'description', "",              # string to use in output files to describe this particular geometry, can be anything
         'gnuplot_desc', "",             # used in gnuplot files for keys
         # specify ALL atoms (even redundant with respect to symmetry elements) 
         'atoms', [ [ "C",   0.0000000,  0.0000000,  0.0000000 ],
                    [ "H",   0.6275789,  0.6275789,  0.6275815 ],
                    [ "H",  -0.6275789, -0.6275789,  0.6275815 ],
                    [ "H",  -0.6275789,  0.6275789, -0.6275815 ],
                    [ "H",   0.6275789, -0.6275789, -0.6275815 ] ]
       },
       # end copy
  ],

  # the following option can be used e.g. to continue an interupted run
  # all geometries are generated but codes will run only for specified geometries
  'start_at_geometry', 1,                # codes will run only for geometries with index >= than this number
  'stop_at_geometry',  0,               # this can be used to stop at certain geometry 
                                         # if zero then codes will run for all geometries
);
