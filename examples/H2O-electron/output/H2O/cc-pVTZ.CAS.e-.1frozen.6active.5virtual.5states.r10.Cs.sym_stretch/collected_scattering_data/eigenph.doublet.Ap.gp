dir = 'eigenph'

set title 'H2O, doublet Ap'

set xlabel 'Energy (eV)
set ylabel 'Eigenphase sum (rad)

e_unit = 1.0 # to change energy units

plot [:] \
  dir.'/eigenph.all.geom1' u ($1*e_unit):2 t 'R =  1.70, theta = 104.48' w l, \
  dir.'/eigenph.all.geom2' u ($1*e_unit):2 t 'R =  1.80, theta = 104.48' w l, \
  dir.'/eigenph.all.geom3' u ($1*e_unit):2 t 'R =  1.90, theta = 104.48' w l, \
  dir.'/eigenph.all.geom4' u ($1*e_unit):2 t 'R =  2.00, theta = 104.48' w l

