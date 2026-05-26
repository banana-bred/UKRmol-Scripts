dir = 'xsec'

initial = 1 # initial electronic state
final   = 1 # final electronic state (0 gives total cross section)

set title 'H2O, doublet App'

set xlabel 'Energy (eV)
set ylabel 'Cross section (a.u.)

e_unit = 1.0 # to change energy units
x_unit = 1.0 # to chenge cross-section units

plot [:] \
  dir.'/xsec.doublet.App.from_initial_state_'.initial.'.geom1' u ($1*e_unit):(column(final+2)*x_unit) t 'R =  1.70, theta = 104.48' w l, \
  dir.'/xsec.doublet.App.from_initial_state_'.initial.'.geom2' u ($1*e_unit):(column(final+2)*x_unit) t 'R =  1.80, theta = 104.48' w l, \
  dir.'/xsec.doublet.App.from_initial_state_'.initial.'.geom3' u ($1*e_unit):(column(final+2)*x_unit) t 'R =  1.90, theta = 104.48' w l, \
  dir.'/xsec.doublet.App.from_initial_state_'.initial.'.geom4' u ($1*e_unit):(column(final+2)*x_unit) t 'R =  2.00, theta = 104.48' w l

