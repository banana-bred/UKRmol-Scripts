r_unit  = 1.0 # to change units
e_unit  = 1.0 # to change units
e_shift = 0.0 # to shift energies

set xlabel 'Internuclear distance (a.u.)'
set ylabel 'Energy (a.u.)'
set title 'H2O, CAS'

plot [:] \
  'target.energies' u ($1*r_unit):(($2+e_shift)*e_unit) t '1 singlet.Ap' w l, \
  'target.energies' u ($1*r_unit):(($3+e_shift)*e_unit) t '2 singlet.Ap' w l, \
  'target.energies' u ($1*r_unit):(($4+e_shift)*e_unit) t '1 triplet.Ap' w l, \
  'target.energies' u ($1*r_unit):(($5+e_shift)*e_unit) t '1 singlet.App' w l, \
  'target.energies' u ($1*r_unit):(($6+e_shift)*e_unit) t '1 triplet.App' w l
