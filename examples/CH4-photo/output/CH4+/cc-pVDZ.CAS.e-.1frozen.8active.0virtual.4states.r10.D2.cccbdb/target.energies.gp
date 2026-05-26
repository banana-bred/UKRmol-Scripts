r_unit  = 1.0 # to change units
e_unit  = 1.0 # to change units
e_shift = 0.0 # to shift energies

set xlabel 'Internuclear distance (A)'
set ylabel 'Energy (a.u.)'
set title 'CH4+, CAS'

plot [:] \
  'target.energies' u ($1*r_unit):(($2+e_shift)*e_unit) t '1 doublet.A' w l, \
  'target.energies' u ($1*r_unit):(($3+e_shift)*e_unit) t '1 doublet.B3' w l, \
  'target.energies' u ($1*r_unit):(($4+e_shift)*e_unit) t '1 doublet.B2' w l, \
  'target.energies' u ($1*r_unit):(($5+e_shift)*e_unit) t '1 doublet.B1' w l
