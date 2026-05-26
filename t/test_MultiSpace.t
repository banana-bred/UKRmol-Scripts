#!usr/bin/perl

use Data::Dump qw(dump);

use Test::More;
use MultiSpace;

use strict;
use warnings;

my $test_name = "MultiSpace.pm: pod-snippet: ORMAS distributions";
my @MAS = (
    [2,3,0,0,0,0,0,0], [8,10],
    [4,4,0,0,0,0,0,0], [0,2],
);

my $target_space = MultiSpace->new({
    symmetry => "Cs",
    MAS => \@MAS,
    type => 1}
);

my $nelec = 10;
my @dists = $target_space->distributions($nelec);

my @dists_should_be = ([10, 0], [9, 1], [8, 2]);

is_deeply(\@dists, \@dists_should_be, $test_name);

$test_name = "MultiSpace.pm: pod-snippet: GAS distributions";

@MAS = (
    [2,3,0,0,0,0,0,0], [8,10],
    [4,4,0,0,0,0,0,0], [10,10],
);

$target_space = MultiSpace->new({
    symmetry => "Cs",
    MAS => \@MAS,
    type => 2}
);

@dists = $target_space->distributions($nelec);

is_deeply(\@dists, \@dists_should_be, $test_name);


$test_name = "MultiSpace.pm: pod-snippet: ORMAS distributions with constraints";

@MAS = (
    [2,3,0,0,0,0,0,0], [8,10],
    [4,4,0,0,0,0,0,0], [0,2],
);
my $constraints = sub {my $dist = shift; !($dist->[1] > 1);};

$target_space = MultiSpace->new({
    symmetry => "Cs",
    MAS => \@MAS,
    constraints => $constraints,
    type => 1}
);

@dists = $target_space->distributions($nelec);

@dists_should_be = ([10, 0], [9, 1]);

is_deeply(\@dists, \@dists_should_be, $test_name);

$test_name = "MultiSpace.pm: pod-snippet: labelling the subspaces";

@MAS = (
    [1,0,0,0,0,0,0,0], [2,2], "frozen",
    [5,1,0,0,0,0,0,0], [8,8], "active",
);

$target_space = MultiSpace->new({
    symmetry => "Cs",
    MAS => \@MAS,
    type => 1}
);

@dists = $target_space->distributions($nelec);
my @dists_and_labels = (\@dists, $target_space->{subspace_labels});

@dists_should_be = ([2, 8]);
my @dists_and_labels_should_be = (\@dists_should_be, ["frozen", "active"]);

is_deeply(\@dists_and_labels, \@dists_and_labels_should_be, $test_name);

$test_name = "MultiSpace.pm: pod-snippet: automatic subspaces";

@MAS = (
    1, [2,2], "frozen",
    6, [8,8], "active",
);

my @ordered_orb = ("1.1", "2.1", "1.2", "1.3", "1.4", "1.5", "1.6");

my $MAS_new = MultiSpace::set_orbs_per_irrep_per_subspace_automatically(\@MAS, \@ordered_orb);

my @MAS_should_be = (
    [1,0,0,0,0,0,0,0], [2,2], "frozen",
    [5,1,0,0,0,0,0,0], [8,8], "active",
);

is_deeply($MAS_new, \@MAS_should_be, $test_name);

$test_name = "MultiSpace.pm: counting csf";

@MAS = (
    [5,0,4,0,5,0,2,0], [32,32],
    [3,2,1,1,1,1,2,1], [10,10]
);

$target_space = MultiSpace->new({
    symmetry => "D2h",
    MAS => \@MAS,
    type => 1}
);

my %ncsf = $target_space->dimension(42, 1);
my %ncsf_should_be = (0 => 21578, 1 => 21228, 2 => 21168, 3 => 21168, 4 => 21168, 5 => 21168, 6 => 21228, 7 => 21178);

is_deeply(\%ncsf, \%ncsf_should_be, $test_name);

$test_name = "MultiSpace.pm: Molcas GASSCF  (D2h)";

@MAS = (
    [1,0,0,0,1,0,0,0], [4,4], "frozen",   
    [1,0,0,0,1,0,0,0], [8,8], "inactive",
    [1,0,0,0,1,0,0,0], [10,10], "active",   
    [0,1,0,0,0,1,0,0], [12,12], "active",
    [0,0,1,0,0,0,1,0], [14,14], "active",
);

$target_space = MultiSpace->new({
    symmetry => "D2h",
    MAS => \@MAS,
    type => 2}
);

my %molcas_input = $target_space->molcas_gasscf_input();

my %molcas_input_should_be = (
  "GASSCF", [
    [3],
    [1, 0, 0, 0, 1, 0, 0, 0],
    [2, 2],
    [0, 1, 0, 0, 0, 1, 0, 0],
    [4, 4],
    [0, 0, 1, 0, 0, 0, 1, 0],
    [6, 6],
  ],
  "INACTIVE", [1, 0, 0, 0, 1, 0, 0, 0],
  "NACTEL", [6,0,0],
  "FROZEN", [1, 0, 0, 0, 1, 0, 0, 0],
);

is_deeply(\%molcas_input, \%molcas_input_should_be, $test_name);

$test_name = "MultiSpace.pm: Molcas GASSCF input (C2h)";

@MAS = (
    [1,0,1,0,0,0,0,0], [4,4], "frozen",   
    [1,1,0,0,0,0,0,0], [8,8], "inactive",
    [1,0,0,1,0,0,0,0], [10,10], "active",   
    [0,1,0,1,0,0,0,0], [12,12], "active",
    [1,0,1,0,0,0,0,0], [14,14], "active",
);

$target_space = MultiSpace->new({
    symmetry => "C2h",
    MAS => \@MAS,
    type => 2}
);

%molcas_input = $target_space->molcas_gasscf_input();

%molcas_input_should_be = (
  "GASSCF", [
    [3],
    [1, 0, 0, 1, 0, 0, 0, 0],
    [2, 2],
    [0, 0, 1, 1, 0, 0, 0, 0],
    [4, 4],
    [1, 1, 0, 0, 0, 0, 0, 0],
    [6, 6],
  ],
  "INACTIVE", [1, 0, 1, 0, 0, 0, 0, 0],
  "NACTEL", [6,0,0],
  "FROZEN", [1, 1, 0, 0, 0, 0, 0, 0],
);

is_deeply(\%molcas_input, \%molcas_input_should_be, $test_name);

$test_name = "MultiSpace.pm: Molpro ORMAS input";
@MAS = (
    [1,0,0,0,0,0,0,0], [4,4], "frozen",
    [0,1,0,0,0,0,0,0], [4,4], "closed",
    [1,2,0,0,0,0,0,0], [4,6], "active",
    [4,4,0,0,0,0,0,0], [0,2], "active",
);

$target_space = MultiSpace->new({
    symmetry => "Cs",
    MAS => \@MAS,
    type => 1}
);


my %molpro_ormas_input = $target_space->molpro_ormas_input();
my %molpro_ormas_input_should_be = (
  "CLOSED",
  [1, 1, 0, 0, 0, 0, 0, 0],
  "ORMAS",
  "config;\nrestrict, 4, 6, 2.1, 2.2, 3.2;\nrestrict, 0, 2, 3.1, 4.1, 5.1, 6.1, 4.2, 5.2, 6.2, 7.2;\n",
  "OCC",
  [6, 7, 0, 0, 0, 0, 0, 0],
  "FROZEN",
  [1, 0, 0, 0, 0, 0, 0, 0],
);

is_deeply(\%molpro_ormas_input, \%molpro_ormas_input_should_be, $test_name);

$test_name = "MultiSpace.pm: Molpro ORMAS input with additional constraints";
@MAS = (
    [1,0,0,0,0,0,0,0], [4,4], "frozen",
    [0,1,0,0,0,0,0,0], [4,4], "closed",
    [1,2,0,0,0,0,0,0], [4,6], "active",
    [4,4,0,0,0,0,0,0], [0,2], "active",
);
$constraints = sub {my $dist = shift; !($dist->[3] == 1);};

$target_space = MultiSpace->new({
    symmetry => "Cs",
    MAS => \@MAS,
    constraints => $constraints,
    type => 1}
);

my %molpro_ormas_constraints_input = $target_space->molpro_ormas_input();

my %molpro_ormas_constraints_input_should_be = (
  "FROZEN",
  [1, 0, 0, 0, 0, 0, 0, 0],
  "ORMAS",
  "config;\nrestrict, 4, 6, 2.1, 2.2, 3.2;\nrestrict, 0, 2, 3.1, 4.1, 5.1, 6.1, 4.2, 5.2, 6.2, 7.2;\nrestrict, -1, 0, 3.1, 4.1, 5.1, 6.1, 4.2, 5.2, 6.2, 7.2;\n",
  "OCC",
  [6, 7, 0, 0, 0, 0, 0, 0],
  "CLOSED",
  [1, 1, 0, 0, 0, 0, 0, 0],
);

is_deeply(\%molpro_ormas_constraints_input, \%molpro_ormas_constraints_input_should_be, $test_name);

$test_name = "MultiSpace.pm: orbitals per subspace type";
@MAS = (
    [1,0,0,0,0,0,0,0], [4,4], "frozen",
    [0,1,0,0,0,0,0,0], [4,4], "closed",
    [1,2,0,0,0,0,0,0], [4,6], "active",
    [4,4,0,0,0,0,0,0], [0,2], "active",
);

my %opst = MultiSpace::orbs_per_subspace_type(\@MAS);
my %opst_should_be = ('closed', 2, 'active', 11);

is_deeply(\%opst, \%opst_should_be, $test_name);

$test_name = "MultiSpace.pm: orbitals per subspace type (auto)";
@MAS = (
    1, [4,4], "frozen",
    1, [4,4], "closed",
    3, [4,6], "active",
    8, [0,2], "active",
);

%opst = MultiSpace::orbs_per_subspace_type(\@MAS);
%opst_should_be = ('closed', 2, 'active', 11);

is_deeply(\%opst, \%opst_should_be, $test_name);

$test_name = "MultiSpace.pm: qchem irrep order";

my @C2h_multispace_order = (1,2,3,4); 

my $order = MultiSpace::map_to_qchem_irrep_order(\@C2h_multispace_order, "C2h", "molcas");
my @order_should_be = (1,3,2,4);

is_deeply($order, \@order_should_be, $test_name);

done_testing();