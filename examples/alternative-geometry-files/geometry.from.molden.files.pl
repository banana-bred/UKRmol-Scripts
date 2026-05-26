# Here is an example of setting up geometries when you have a molden file or files
# where all geometries you want to run are stored

%geometry = (

  'suffix', ".molden",        # string added to model directory to distinguish runs
                              # with different geometry settings

  'geometry_labels', " Note", # labels used on the first line of output files
                              # it should correspond to numbers given in 'geometries'->'description'
  'correct_cm',   1,          # correct the center of mass to be at the origin
  'length_unit',  0,          # 0 - atomic units, 1 - Angstroms
                              # this is actually set later by &read_geometries_from_files_in_molden_format   

  'geometries', [ ],          # this can be empty, if it is not then it will be deleted anyway

  # the following option can be used e.g. to continue an interupted run
  # all geometries are generated but codes will run only for specified geometries
  'start_at_geometry', 1,               # codes will run only for geometries with index >= than this number
  'stop_at_geometry',  0,               # this can be used to stop at a certain geometry 
                                        # if zero then codes will run for all geometries
);

# Read one particular file
#&read_geometries_from_files_in_molden_format("h2o.molden", \%geometry);
# or read all files in the working directory whose names contain 'molden' as a substring
&read_geometries_from_files_in_molden_format("*molden*", \%geometry);
