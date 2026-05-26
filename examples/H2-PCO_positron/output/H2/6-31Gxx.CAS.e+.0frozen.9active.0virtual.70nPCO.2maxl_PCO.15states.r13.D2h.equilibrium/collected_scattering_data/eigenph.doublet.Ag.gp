dir = 'eigenph'

set title 'H2, doublet Ag'

set xlabel 'Energy (eV)
set ylabel 'Eigenphase sum (rad)

e_unit = 1.0 # to change energy units

plot [:] \
  dir.'/eigenph.all.geom1' u ($1*e_unit):2 t 'R =  1.40' w l

