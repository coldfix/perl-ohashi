#! /usr/bin/env perl

use strict;
use warnings;

use 5.14.0;
use ohashi;
use JSON::PP;


# This stuff all works as expected:
my $x = new ohashi(x => 'z', z => 3, alpha => 'alpha');
$x->{pi} = 3.14;

print $x->{PI}. "\n";

delete $x->{z};

print JSON::PP->new->pretty->encode($x);

%$x = (x => 'x', y => 'y', z => 'z');
$x->{beta} = '< 1';

print $x->{bEtA} . "\n";
print JSON::PP->new->pretty->encode($x);



# Does not work - empty output: 
my %y = (
    alpha => 1,
    beta  => 2,
    gamma => 3,
    delta => 4,
);
tie (%y, 'ohash');
print JSON::PP->new->pretty->encode(\%y);


# Works as expected:
tie (my %z, 'ohash');
%z = (
    alpha => 1,
    beta  => 2,
    gamma => 3,
    delta => 4,
);
print JSON::PP->new->pretty->encode(\%z);

