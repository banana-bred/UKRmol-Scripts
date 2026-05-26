#!usr/bin/perl
use FindBin;
use lib "$FindBin::RealBin/.";
use Data::Dump qw(dump);
use Storable 'dclone';

# Use a (crudely) hacked version of Fortran::F90Namelist::Group that doesn't overwrite
# the repeated wfngrp namelist each time a new one is found.
# All namelists in a file are saved in a hash with the namelist name as a key, 
# wfngrp is saved as an array of F90namelist objects, all others are saved as
# a single F90namelist object.

use MyFortran::F90Namelist::Group;
use Test::More;
use MultiSpace;

use strict;
use warnings;


# my $path = "/home/alex/Code/git_repos/UKRmol-in/tests/suite";
my $path = $ENV{'UKRMOLP_TEST_SUITE'};
our $bs = "/";

our %irred_repr = %MultiSpace::irred_repr;
our %spin_label = reverse %MultiSpace::spin_multiplicity;

# sub read_congen_input_file
#
# Read a congen input file of specified symmetry and extract only the subset 
# of wfngrp namelist variables that are created by space.
#
# Returns: Array of wfngrp hashes

sub read_congen_input_file{
    my ($path, $point_group, $calc_type, $task, $index, $qntot) = @_;

    my $program = "congen";
    my $folder = "${point_group}_scattering_$calc_type"; 
    my $statespin = $spin_label{$qntot->[0]};
    # my $str_ir = $irred_repr{$point_group}->[$qntot->[1]];
    # Test suite uses Molcas irrep order (i.e. 2nd and 3rd C2h irrep exchanged).
    my $str_ir =  $irred_repr{$point_group}->[MultiSpace::map_to_qchem_irrep_order($qntot->[1], $point_group, "molcas")];
    my $str_index = sprintf("%02d",$index);
    my $inputfile = "$path$bs$folder${bs}inputs$bs$task.$program.$str_index.$statespin.$str_ir.inp";

    my $nlgrp = MyFortran::F90Namelist::Group->new() or die "Couldn't get object\n";
    $nlgrp->parse(file => $inputfile);

    my @wfngrps_test_suite = ();
    foreach my $nl (@{$nlgrp->{DATA}->{'wfngrp'}}){
        my $tmp = $nl->hash();
        my %wfngrp = (
            MSHL => $tmp->{'mshl'}{'value'},
            NDPROD => $tmp->{'ndprod'}{'value'}[0],
            NELECP => $tmp->{'nelecp'}{'value'},
            NSHLP => $tmp->{'nshlp'}{'value'},
            PQN => $tmp->{'pqn'}{'value'},
            QNTAR => $tmp->{'qntar'}{'value'},
        );
        push(@wfngrps_test_suite, \%wfngrp);
    }

    return @wfngrps_test_suite;
}

# sub make_wfngrps_from_model
#
# Construct the set of wfngrp variables relating to the active space for
# each wfngrp corresponding to a particular electron distribution.
#
# Returns: Array of wfngrp hashes

sub make_wfngrps_from_model{
    my ($model, $task, $qntot, $qntars) = @_;

    my @wfngrps;
    if ($model->{l2_MAS}){
        
        my $target_space = MultiSpace->new({symmetry => $model->{point_group}, MAS => $model->{MAS}, type => 1});
        my $l2_space = MultiSpace->new({symmetry => $model->{point_group}, MAS => $model->{l2_MAS}, type => 1});
        my @nob0 = $l2_space->total_orbitals();

        if ($task eq "target"){
            @wfngrps = $target_space->congen_target($model->{nelec}, \@nob0, $qntot);
        } else {
            @wfngrps = $target_space->congen_scattering($model->{nelec}, \@nob0, $qntot, $qntars, $l2_space);
        }

    } else {
        my $target_space = MultiSpace->new({symmetry => $model->{point_group}, MAS => $model->{MAS}, type => 1});
        my @nob0 = $target_space->total_orbitals();

        if ($task eq "target"){
            @wfngrps = $target_space->congen_target($model->{nelec}, \@nob0, $qntot);
        } else {
            @wfngrps = $target_space->congen_scattering($model->{nelec}, \@nob0, $qntot, $qntars);
        }                
    }

    foreach my $wfngrp (@wfngrps){
        delete $wfngrp->{'GNAME'};
    }
    return @wfngrps;
}

# sub run_tests_one_calc
#
# Run tests for a single ukrmolp test suite calculation.

sub run_tests_one_calc{
    my ($model, $path, $calc_type, $n_irreps, $qntars, $qntots) = @_;

    my $task = "target";

    my $n_target_syms = scalar @{$qntars};

    for my $i (0..$n_target_syms-1){

        my $statespin = $spin_label{$qntars->[$i]->[0]};
        my $str_ir = $irred_repr{$model->{point_group}}->[$qntars->[$i]->[1]];   
        my $test_name = "$model->{point_group}_scattering_$calc_type - $task - congen - $i - $statespin $str_ir";

        my @wfngrps = make_wfngrps_from_model($model, $task, $qntars->[$i], $qntars);
        my @wfngrps_test_suite = read_congen_input_file($path, $model->{point_group}, $calc_type, $task, $i+1, $qntars->[$i]);

        is_deeply(\@wfngrps, \@wfngrps_test_suite, $test_name);
    }

    $task = "scattering";

    for my $i (0..$n_irreps-1){

        my $statespin = $spin_label{$qntots->[$i]->[0]};
        my $str_ir = $irred_repr{$model->{point_group}}->[$qntots->[$i]->[1]];   
        my $test_name = "$model->{point_group}_scattering_$calc_type - $task - congen - $i - $statespin $str_ir";

        my @wfngrps = make_wfngrps_from_model($model, $task, $qntots->[$i], $qntars);
        my @wfngrps_test_suite = read_congen_input_file($path, $model->{point_group}, $calc_type, $task, $i+1, $qntots->[$i]);

        is_deeply(\@wfngrps, \@wfngrps_test_suite, $test_name);
    }

}

# All test suite calculations either use all singlet and triplet target symmetries
# or just the HF ground state.
my @all_qntar = (
    [1,0,0],[3,0,0],[1,1,0],[3,1,0],[1,2,0],[3,2,0],[1,3,0],[3,3,0],
    [1,4,0],[3,4,0],[1,5,0],[3,5,0],[1,6,0],[3,6,0],[1,7,0],[3,7,0]
    );
# All scattering symmetries are used
my @all_qntot = ([2,0,0],[2,1,0],[2,2,0],[2,3,0],[2,4,0],[2,5,0],[2,6,0],[2,7,0]);


# ============== <point_group>_scattering_CC calculations =====================
#
# These are CAS calculations with no virtual orbitals.
#
# =============================================================================

# -------------- C1_scattering_CC test suite calculation ----------------------

my $calc_type = "CC";

my %model = (
    'point_group',  "C1",
    'nelec',  24,
    'MAS', [
        [10,0,0,0,0,0,0,0], [20,20],
        [6,0,0,0,0,0,0,0], [4,4],
    ],
);

my $n_irreps = scalar @{$irred_repr{$model{point_group}}};
my @qntots = @all_qntot[0..$n_irreps-1];
my @qntars = @all_qntar[0..2*$n_irreps-1];

run_tests_one_calc(\%model, $path, $calc_type, $n_irreps, \@qntars, \@qntots);

# -------------- Ci_scattering_CC test suite calculation ---------------------

$calc_type = "CC";

%model = (
    'point_group',  "Ci",
    'nelec',  58,
    'MAS', [
        [10,8,0,0,0,0,0,0], [36,36],
        [5,3,0,0,0,0,0,0], [10,10],
    ],
);

$n_irreps = scalar @{$irred_repr{$model{point_group}}};
@qntots = @all_qntot[0..$n_irreps-1];
@qntars = @all_qntar[0..2*$n_irreps-1];

run_tests_one_calc(\%model, $path, $calc_type, $n_irreps, \@qntars, \@qntots);

# -------------- Cs_scattering_CC test suite calculation ---------------------

$calc_type = "CC";

%model = (
    'point_group',  "Cs",
    'nelec',  58,
    'MAS', [
        [22,2,0,0,0,0,0,0], [48,48],
        [3,5,0,0,0,0,0,0], [10,10],
    ],
);

$n_irreps = scalar @{$irred_repr{$model{point_group}}};
@qntots = @all_qntot[0..$n_irreps-1];
@qntars = @all_qntar[0..2*$n_irreps-1];

run_tests_one_calc(\%model, $path, $calc_type, $n_irreps, \@qntars, \@qntots);

# -------------- C2_scattering_CC test suite calculation ---------------------

$calc_type = "CC";

%model = (
    'point_group',  "C2",
    'nelec',  18,
    'MAS', [
        [2,2,0,0,0,0,0,0], [8,8],
        [4,4,0,0,0,0,0,0], [10,10],
    ],
);

$n_irreps = scalar @{$irred_repr{$model{point_group}}};
@qntots = @all_qntot[0..$n_irreps-1];
@qntars = @all_qntar[0..2*$n_irreps-1];

run_tests_one_calc(\%model, $path, $calc_type, $n_irreps, \@qntars, \@qntots);

# -------------- C2h_scattering_CC test suite calculation ---------------------

$calc_type = "CC";

%model = (
    'point_group',  "C2h",
    'nelec',  16,
    'MAS', [
        [2,0,2,0,0,0,0,0], [8,8],
        [3,1,3,1,0,0,0,0], [8,8],
    ],
);

$n_irreps = scalar @{$irred_repr{$model{point_group}}};
@qntots = @all_qntot[0..$n_irreps-1];
@qntars = @all_qntar[0..2*$n_irreps-1];

run_tests_one_calc(\%model, $path, $calc_type, $n_irreps, \@qntars, \@qntots);

# -------------- C2v_scattering_CC test suite calculation ---------------------

$calc_type = "CC";

%model = (
    'point_group',  "C2v",
    'nelec',  42,
    'MAS', [
        [11,1,7,0,0,0,0,0], [38,38],
        [3,2,2,2,0,0,0,0], [4,4],
    ],
);

$n_irreps = scalar @{$irred_repr{$model{point_group}}};
@qntots = @all_qntot[0..$n_irreps-1];
@qntars = @all_qntar[0..2*$n_irreps-1];

run_tests_one_calc(\%model, $path, $calc_type, $n_irreps, \@qntars, \@qntots);

# -------------- D2h_scattering_CC test suite calculation ---------------------

$calc_type = "CC";

%model = (
    'point_group',  "D2h",
    'nelec',  42,
    'MAS', [
        [6,1,4,0,5,0,3,0], [38,38],
        [2,1,1,1,1,1,1,1], [4,4],
    ],
);

$n_irreps = scalar @{$irred_repr{$model{point_group}}};
@qntots = @all_qntot[0..$n_irreps-1];
@qntars = @all_qntar[0..2*$n_irreps-1];

run_tests_one_calc(\%model, $path, $calc_type, $n_irreps, \@qntars, \@qntots);

# ============== <point_group>_scattering_SEP calculations ====================
#
# These are SEP calculations with single and double excitations into 
# the virtual orbitals.
#
# =============================================================================

# -------------- C1_scattering_SEP test suite calculation ----------------------

$calc_type = "SEP";

%model = (
    'point_group',  "C1",
    'nelec',  24,
    'MAS', [
        [6,0,0,0,0,0,0,0], [12,12],
        [6,0,0,0,0,0,0,0], [12,12],
    ],
    'l2_MAS', [
        [6,0,0,0,0,0,0,0], [12,12],
        [6,0,0,0,0,0,0,0], [10,12],
        [20,0,0,0,0,0,0,0], [0,2],
    ],    
);

$n_irreps = scalar @{$irred_repr{$model{point_group}}};
@qntots = @all_qntot[0..$n_irreps-1];
@qntars = @all_qntar[0..0];

run_tests_one_calc(\%model, $path, $calc_type, $n_irreps, \@qntars, \@qntots);

# -------------- Ci_scattering_SEP test suite calculation ----------------------

$calc_type = "SEP";

%model = (
    'point_group',  "Ci",
    'nelec',  46,
    'MAS', [
        [9,9,0,0,0,0,0,0], [36,36],
        [3,2,0,0,0,0,0,0], [10,10],
    ],
    'l2_MAS', [
        [9,9,0,0,0,0,0,0], [36,36],
        [3,2,0,0,0,0,0,0], [8,10],
        [9,11,0,0,0,0,0,0], [0,2],
    ],    
);

$n_irreps = scalar @{$irred_repr{$model{point_group}}};
@qntots = @all_qntot[0..$n_irreps-1];
@qntars = @all_qntar[0..0];

run_tests_one_calc(\%model, $path, $calc_type, $n_irreps, \@qntars, \@qntots);

# -------------- Cs_scattering_SEP test suite calculation ----------------------
#   nelecp = 40,18,1, ! number of electrons in each set
#   nshlp  = 2,2,2,  ! number of shells (triplets) in each set
#   pqn  = 0,1,19, 0,1,1, 0,20,24, 0,2,5, 0,25,39, 0,6,10, ! orbitals in each shell
#   mshl =   0,     1,     0,     1,     0,     1, ! symmetry of shells above 
$calc_type = "SEP";

%model = (
    'point_group',  "Cs",
    'nelec',  58,
    'MAS', [
        [19,1,0,0,0,0,0,0], [40,40],
        [5,4,0,0,0,0,0,0], [18,18],
    ],
    'l2_MAS', [
        [19,1,0,0,0,0,0,0], [40,40],
        [5,4,0,0,0,0,0,0], [16,18],
        [15,5,0,0,0,0,0,0], [0,2],
    ],    
);

$n_irreps = scalar @{$irred_repr{$model{point_group}}};
@qntots = @all_qntot[0..$n_irreps-1];
@qntars = @all_qntar[0..0];

run_tests_one_calc(\%model, $path, $calc_type, $n_irreps, \@qntars, \@qntots);

# -------------- C2_scattering_SEP test suite calculation ----------------------

$calc_type = "SEP";

%model = (
    'point_group',  "C2",
    'nelec',  18,
    'MAS', [
        [2,2,0,0,0,0,0,0], [8,8],
        [3,2,0,0,0,0,0,0], [10,10],
    ],
    'l2_MAS', [
        [2,2,0,0,0,0,0,0], [8,8],
        [3,2,0,0,0,0,0,0], [8,10],
        [10,10,0,0,0,0,0,0], [0,2],
    ],    
);

$n_irreps = scalar @{$irred_repr{$model{point_group}}};
@qntots = @all_qntot[0..$n_irreps-1];
@qntars = @all_qntar[0..0];

run_tests_one_calc(\%model, $path, $calc_type, $n_irreps, \@qntars, \@qntots);

# -------------- C2h_scattering_SEP test suite calculation ----------------------

$calc_type = "SEP";

%model = (
    'point_group',  "C2h",
    'nelec',  16,
    'MAS', [
        [1,0,1,0,0,0,0,0], [4,4],
        [3,1,2,0,0,0,0,0], [12,12],
    ],
    'l2_MAS', [
        [1,0,1,0,0,0,0,0], [4,4],
        [3,1,2,0,0,0,0,0], [10,12],
        [7,3,7,3,0,0,0,0], [0,2],
    ],    
);

$n_irreps = scalar @{$irred_repr{$model{point_group}}};
@qntots = @all_qntot[0..$n_irreps-1];
@qntars = @all_qntar[0..0];

run_tests_one_calc(\%model, $path, $calc_type, $n_irreps, \@qntars, \@qntots);

# -------------- C2v_scattering_SEP test suite calculation ----------------------

$calc_type = "SEP";

%model = (
    'point_group',  "C2v",
    'nelec',  42,
    'MAS', [
        [10,0,6,0,0,0,0,0], [32,32],
        [1,2,1,1,0,0,0,0], [10,10],
    ],
    'l2_MAS', [
        [10,0,6,0,0,0,0,0], [32,32],
        [1,2,1,1,0,0,0,0], [8,10],
        [8,3,7,2,0,0,0,0], [0,2],
    ],    
);

$n_irreps = scalar @{$irred_repr{$model{point_group}}};
@qntots = @all_qntot[0..$n_irreps-1];
@qntars = @all_qntar[0..0];

run_tests_one_calc(\%model, $path, $calc_type, $n_irreps, \@qntars, \@qntots);

# -------------- D2h_scattering_SEP test suite calculation ----------------------

$calc_type = "SEP";

%model = (
    'point_group',  "D2h",
    'nelec',  42,
    'MAS', [
        [5,0,4,0,4,0,2,0], [30,30],
        [1,1,0,1,1,1,1,0], [12,12],
    ],
    'l2_MAS', [
        [5,0,4,0,4,0,2,0], [30,30],
        [1,1,0,1,1,1,1,0], [10,12],
        [5,2,3,1,4,2,2,1], [0,2],
    ],    
);

$n_irreps = scalar @{$irred_repr{$model{point_group}}};
@qntots = @all_qntot[0..$n_irreps-1];
@qntars = @all_qntar[0..0];

run_tests_one_calc(\%model, $path, $calc_type, $n_irreps, \@qntars, \@qntots);

done_testing();
