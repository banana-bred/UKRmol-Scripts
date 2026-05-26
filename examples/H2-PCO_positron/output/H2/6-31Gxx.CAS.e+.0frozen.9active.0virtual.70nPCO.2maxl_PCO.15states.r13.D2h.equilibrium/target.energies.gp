r_unit  = 1.0 # to change units
e_unit  = 1.0 # to change units
e_shift = 0.0 # to shift energies

set xlabel 'Internuclear distance (A)'
set ylabel 'Energy (a.u.)'
set title 'H2, CAS'

plot [:] \
  'target.energies' u ($1*r_unit):(($2+e_shift)*e_unit) t '1 singlet.Ag' w l, \
  'target.energies' u ($1*r_unit):(($3+e_shift)*e_unit) t '2 singlet.Ag' w l, \
  'target.energies' u ($1*r_unit):(($4+e_shift)*e_unit) t '3 singlet.Ag' w l, \
  'target.energies' u ($1*r_unit):(($5+e_shift)*e_unit) t '4 singlet.Ag' w l, \
  'target.energies' u ($1*r_unit):(($6+e_shift)*e_unit) t '5 singlet.Ag' w l, \
  'target.energies' u ($1*r_unit):(($7+e_shift)*e_unit) t '6 singlet.Ag' w l, \
  'target.energies' u ($1*r_unit):(($8+e_shift)*e_unit) t '1 singlet.B3u' w l, \
  'target.energies' u ($1*r_unit):(($9+e_shift)*e_unit) t '2 singlet.B3u' w l, \
  'target.energies' u ($1*r_unit):(($10+e_shift)*e_unit) t '1 singlet.B2u' w l, \
  'target.energies' u ($1*r_unit):(($11+e_shift)*e_unit) t '2 singlet.B2u' w l, \
  'target.energies' u ($1*r_unit):(($12+e_shift)*e_unit) t '1 singlet.B1g' w l, \
  'target.energies' u ($1*r_unit):(($13+e_shift)*e_unit) t '1 singlet.B1u' w l, \
  'target.energies' u ($1*r_unit):(($14+e_shift)*e_unit) t '2 singlet.B1u' w l, \
  'target.energies' u ($1*r_unit):(($15+e_shift)*e_unit) t '1 singlet.B2g' w l, \
  'target.energies' u ($1*r_unit):(($16+e_shift)*e_unit) t '1 singlet.B3g' w l
