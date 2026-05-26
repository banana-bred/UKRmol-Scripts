#!/bin/bash

# set required memory
#PBS -l mem=10g
#PBS -l nodes=1:ppn=8
#PBS -l walltime=99:00:00
export MOLECULE=H2O

echo This calculation was done on
less $PBS_NODEFILE

#Remember the submit directory for later
SbmtDir=$PBS_O_WORKDIR

#copy all stuff on scratch
export MY_NAME=$PBS_JOBID
export MY_LOG=log_$MY_NAME.txt
export SCRATCH=/scratch/$USER/$MY_NAME
mkdir -p $SCRATCH
cp -r $SbmtDir/* $SCRATCH/.
cd $SCRATCH
mkdir -p output/$MOLECULE

# set no limits for STACK size
ulimit -s unlimited

# set the intel compiler and MKL environment variables
module load intel

# set the number of threads available for multi-threaded MKL routines
export OMP_NUM_THREADS=8

perl main.pl dirs.pl config.pl model.pl geometry.pl > $MY_LOG 2>&1

#copy all results from scratch to my home directory 
cp $MY_LOG $SCRATCH/output/$MOLECULE/.
cd $SCRATCH/output/$MOLECULE
export DEST=~/Molecules/$MOLECULE/UKRmol
mkdir -p $DEST
cp -r * $DEST/.

#remove the temporary data from scratch
rm -rf $SCRATCH && echo "scratch cleaned"
