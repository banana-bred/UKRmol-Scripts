README
======

H2O
---

These are based on the H2O example already in UKRmol-scripts

Examples of how to run SEP, CAS-A, CAS-B, CAS-C and a new model type called CAS-D 
using the ORMAS approach.

SEP, CAS-A, CAS-B, CAS-C should give identical results to the existing predefined models.
This can be tested by setting `'use_MAS' = 0` and removing the ORMAS- prefix
from the model name. 

Examples of GASSCF and ORMASSCF quantum chemistry calculations.

These split the active space into two subspaces, but allow all excitations that
would be present in a standard CAS, so should give identical results to CAS-A.

Benzene
-------

This is based on the test suite calculation in the folder `D2h_scattering_CC`
It can be run without the need for molpro by using the molden file and 
molpro output in the subdirectory `./benzene_molpro_output`.
