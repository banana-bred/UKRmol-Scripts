Welcome to the ukrmol-scripts for running both inner and outer
R-matrix suite of programs!

These scripts were developed to help the community of users of 
UKRmol and UKRmol+ (UKRmol-in and UKRmol-out) suites to run scattering calculations in an easier way.
They were then adapted to run photoionization calculations and those generating input for the RMT code.
They can be used freely by the community and are distributed 
under the terms of the GNU General Public License (see below License).

Copyright 2014, 2018 Karel Houfek

Copyright 2019 Karel Houfek, Jakub Benda, Zdenek Masin, Daniel Darby-Lewis and Jimena Gorfinkiel

Copyright 2023 Karel Houfek, Jakub Benda, Zdenek Masin, Alex Harvey, Thomas Meltzer, Vincent Graves and Jimena Gorfinkiel

Contributions and contacts:
===========================

From Institute of Theoretical Physics, Faculty of Mathematics and Physics, Charles University, Czech Republic:

- Karel Houfek - general design and original version of the scripts for electron-molecule scattering using UKRmol and UKRmol+
- Jakub Benda - implementation of Psi4 support, interface with RMT, general scripts maintenance
- Zdeněk Mašín - implementation of photoionization support, generation of geometries from normal modes and Molden file, general scripts maintenance
- Thomas Meltzer - polarization-consistent coupled Hartree–Fock (PC-CHF) approach, more efficient generation of reference configuration

From School of Physical Sciences, The Open University, Milton Keynes, United Kingdom:

- Daniel Darby-Lewis - initial work on positrons and implementation of pseudo-contiuum orbitals
- Vincent Graves -  implementation of positron scattering, including PC-CHF  
- Jimena Gorfinkiel - general scripts maintenance, testing, documentation

Other:

- Alex Harvey - implementation of photoionization support and multiple active space approach

Feel free to contact 

- Karel Houfek <karel.houfek@mff.cuni.cz> or
- Jakub Benda <jakub.benda@mff.cuni.cz> or
- Zdenek Masin <zdenek.masin@mff.cuni.cz> or
- Jimena Gorfinkiel <jimena.gorfinkiel@open.ac.uk>

with any problems you encounter using these scripts.

Citing these scripts:
=====================

The scripts are now published, and should be cited as

[1] K. Houfek et al. CPC (submitted)

If you use the Multiple Active Space (MAS) approach, please also cite

[2] A. G. Harvey, (in prep.)

Contents of the top-level directory:
====================================

- `scripts/`         contains all Perl scripts needed
- `lib/`             contains all necesary libraries
- `t/`               contains test suite (currently only covers MultiSpace.pm)
- `basis.sets/`      contains basis sets files in MOLPRO format and continuum basis sets in swmol3 format
- `input.templates/` contains input templates for UKRmol-in, UKRmol-out and MOLPRO packages
                   which are used by scripts to prepare all input files
                   by replacing strings such as >>>BASIS<<< etc
- `examples/`  contains a number of examples of settings and outputs
               for several molecules
- `doc/`       contains documentation for the scripts, describing in
               particular what you have to change to run the scripts
               for a specific system, what and where are machine dependent
               parameters and how output is organized
               there is also file setting_up_models.txt with a brief description 
               how to set up various scattering models
- `tools/`     additional Perl scripts which can be useful
               for adding functionality of the main scripts,
               e.g. scripts for generating basis set files

Prerequisites:
==============

You have to have the UKRmol+ suite (both UKRmol-in and UKRmol-out) installed on your
computer or cluster. The suite can be downloaded from zenodo (search UKRmol+).

UKRmol+ requires external input of orbitals, either from Molpro, Molcas or Psi4.

Using the scripts:
==================

For instructions on how to run the scripts see [getting started](./doc/getting_started.txt). A basic description of the predefined models that can be used in the scripts, and how to set them up,  can be found in [setting up models](./doc/setting_up_models.txt), and details on how to use the multiple active space (MAS) approach can be found in the [MAS tutorial](./doc/MAS_tutorial.md). 

Examples provided:
==================

- CH4-photo: photoionization of CH4; close-coupling calculation
- H2-rmt: generates data needed to run R-matrix with time (RMT) calculation; static-exchange model
- H2O-electron: electron scattering from H2O; close-coupling calculation with example of how to generate several geometries automatically
- H2O-positron: positron scattering from H2O
- H2-PCO_positron: positron scattering from H2; example of use of pseudocontinuum orbitals
- MAS: electron scattering from H2O and C6H6; examples of use of the ORMAS approach as well as other models (see README.md file in MAS directory)

The photoionization, RMT input and electron scattering examples are set up NOT to run any quantum chemistry code; the files needed are provided. 
Conversely, the positron calcualtions are set up to use MOLPRO. However, if MOLPRO is not avaible, 
setting 'only' in the configuration file following the electron scattering example should enable the user to run the calculation using existing files.

Information on updates to the scripts:
======================================

What's new in the scripts in February 2018:
-------------------------------------------

1. The newest versions of both UKRmol and UKRmol+ codes are supported.

2. Target bases are much simpler to use (only one file in Molpro
format is needed). Contiuum bases are still in swmol3 format.

3. Both GTO and BTO type of continuum bases or their combination can be used.

4. New options `'orbitals'` and `'select_orb_by'` provide control over
which orbitals and in which order are used (they are used only with
UKRmol+ codes, where they have sense).

5. Full CI and frozen-core full CI models can now be set up without
running CASSCF, see `doc/setting_up_models.txt`.

6. All relevant scattering data for all geometries are now collected
in one directory `collected_scattering_data/` and some gnuplot files
for eigenphase sums and cross sections are created there.

7. Some basic tests of model settings are done now in `check_settings()`
subroutine and the scripts stop when there is clear inconsistency.

What's new in the scripts in October 2019 (the list is not exhaustive):
-----------------------------------------------------------------------
(The changes were implemented by Karel Houfek, Zdenek Masin, Jakub Benda,
Daniel Darby-Lewis and Jimena Gorfinkiel

1. Singly occupied orbitals can be read (from MOLPRO output) and used without 
problems

2. New script (`geometry.from.normal.modes.pl`) for generating geometries of 
polyatomic molecules from the normal mode displacements has been added

3. New option for saving amplitude and channel data

4. New option for running only specific outer-region codes

5. New options for MPI runs using MPI-SCATCI and MPI-RSOLVE

6. Support for use of Psi4 added

7. Additional continuum bases for neutral and charged targets  and charge flag to 
switch between neutral and charged targets

8. Option to generate photoionisation cross sections

9. Use phase consistent target states in scattering calculations for all symmetries

10. Use of pseudocontinuum orbitals (PCO) and pseudostates now possible

11. Save outer data also in photoionization/RMT mode

What's new in the scripts in March 2023 (the list is not exhaustive):
---------------------------------------------------------------------
(The Multiple Active Space approach was implemented by Alex Harvey, based on
his MultiSpace python library. Other updates implemented by Jakub Benda, Vincent
Graves, Jimena Gorfinkiel,  Zdenek Masin and  Karel Houfek)

1. The Multiple Active Space (MAS) Approach:

    The multiple active space approach (MAS) is a new method for defining the 
    orbital active space for UKRmol+ calculations. It is based on a generalization 
    of the occupation restricted multiple active space approach (ORMAS) and the 
    generalized active space approach (GAS).

    Using MAS it is often possible to reduce the number of CSF by an order of
    magnitude or more, as compared to CAS, while retaining chemical accuracy.

    A second benefit of the MAS approach is that it provides a simple yet flexible
    method of defining active spaces in general, allowing for sophisticated models
    beyond the pre-defined models to be used in the scripts.

    a. MAS can now be used to generate orbitals, and construct target and total states. 

    b. Support for Molcas added, with the capability to perform GASSCF calculations.

    c. Molpro support extended to allow ORMASSCF calculations.

    For more details see the [tutorial](./doc/MAS_tutorial.md) and the examples in
    the `examples/MAS` directory.

2. Positron calculations now possible:

    Includes PC-CHF model and use of PCOs, but currently not MAS.

3. Polarization-consistent coupled Hartree–Fock (PC-CHF) model:

    The polarization-consistent coupled Hartree–Fock (PC-CHF) approach uses a simple
    Hartree–Fock-like description of the target states to model polarization and
    multi-channel effects in polyatomic molecules. The model is constructed in a
    self-consistent manner meaning that all of the target states implied by the
    polarization configurations are included in the continuum wavefunction.

License:
========

These scripts are free software: you can redistribute them and/or modify
them under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

These scripts are distributed in the hope that they will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License (see the file COPYING)
along with this program.  If not, see <http://www.gnu.org/licenses/>.
