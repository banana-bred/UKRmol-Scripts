User-installed packages be here.

TOP-LEVEL FILES
---------------

  build.all: run all of the build script in dependency order
    ./build.all                         # everything, checks included
    ./build.all                         # everything, checks excluded
    ./build.all petsc64 slepc64         # just these, check included
    ./build.all nocheck petsc64 slepc64 # just these, check excluded

  prefixes: Environmental variables used by the build scripts.
    Each variable can be overwritten, e.g.,

      UKRMOL_ROOT=/opt/ ./build.all           # relocate all packages
      PETSC_PFX=/somewhere/else/ ./build.all  # relocate petsc

You can just run 'build.all', or each 'buildpkg' manually.

DEPENDENCIES: NEEDED/WANTED --> BY

MPI          --> ScaLAPACK
LAPACK+BLAS  --> ScaLAPACK
LAPACK+BLAS  --> PETSc  --> SLEPc

mpich         PROVIDES   MPI
openblas64    PROVIDES   LAPACK+BLAS
scalapack64   PROVIDES   ScaLAPACK
petsc64       PROVIDES   PETSc
slepc64       PROVIDES   SLEPc

ukrmol-in NEEDS LAPACK+BLAS
ukrmol-in WANTS mpi
ukrmol-in WANTS ScaLAPACK
ukrmol-in WANTS SLEPc

ukrmol-out NEEDS ukrmol-in

NOTE:
¯¯¯¯
The 64 means 64-bit default integers. This is not necessarily required, but can be necessary for large calculations when diagonalizing the CI
Hamiltonian. Paralellizing across more nodes is one way to get around this, but it's probably best to just be able to handle a large number of CSFs.
The MPI implementation does not need to be built 64-bit integers because you probably do not need to index 2 billion+ MPI ranks, but in case that
day comes, just use mpich64 and point downstream codes there.

Suggested compilation order (3a and 3b are mutually independent):
  . cmake (if system cmake is too old 🧓. Set CMAKE=/path/to/cmake)
  . mpich
  . openblas64
  a. petsc64 then slepc64
  b. scalapack64
  . ukrmol-in
  . ukrmol-out

Each directory contains some variation of a build script that can simply be run.
It will build the necessary libraries, (sub)module files, and executables in $HOME/.local by default.
See the build scripts for details.

NOTES:
¯¯¯¯¯¯
- OpenBLAS(64) is just a BLAS implementation that I like, compiled with 64-bit Fortran integers.

- MPICH is just an MPI implementation that I like, compiled with default 32-bit Fortran integers.
  - openmpi would probably work, but I haven't used it because other Fortran stuff that I've used
    with coarrays has stopped working because of gfortran 15+

- mpich and scalapack64 get their own directories in the default installatin directory ($HOME/.local) so that they don't step on the implementations that are often already there on other systems.
  Usually nothing would be in $HOME/.local, but if the installation directory is something like /usr/lib or something then that's when you don't want to mix openmpi and mpich etc. Probably it is nothing to worry about; this is normally enforced in the build scripts, so there's nothing to do.

- to access these installed binaries and libraries, your shell must know where they are.
  You can just source the file `ukrmolenv` which will add these to your PATH and LD_LIBRARY_PATH.

- molpro, psi4, or (open?)molcas are required to actually run UKRmol+, but it is not necessary
  to have quantum chemistry software for building.
  - you can enable them for testing (check ukmol-in/ukrmol-in/CMakeLists.txt) for exact CMAKE options
