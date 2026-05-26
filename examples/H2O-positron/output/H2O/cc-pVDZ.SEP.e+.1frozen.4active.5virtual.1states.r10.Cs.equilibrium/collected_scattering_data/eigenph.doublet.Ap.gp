dir = 'eigenph'

set title 'H2O, doublet Ap'

set xlabel 'Energy (eV)
set ylabel 'Eigenphase sum (rad)

e_unit = 1.0 # to change energy units

plot [:] \
  dir.'/eigenph.all.geom1' u ($1*e_unit):2 t 'R1 = 1.81, R2 = 1.81, Theta = 104.48' w l

