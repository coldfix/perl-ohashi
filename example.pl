#! /usr/bin/env perl

use strict;
use warnings;

use 5.14.0;
use ohashi;
use JSON::PP;

my $x = new ohashi(x => 'z', z => 3, alpha => 'alpha');
$x->{pi} = 3.14;

print $x->{PI}. "\n";

delete $x->{z};

print JSON::PP->new->pretty->encode($x);

%$x = (x => 'x', y => 'y', z => 'z');
$x->{beta} = '< 1';

print $x->{bEtA} . "\n";
print JSON::PP->new->pretty->encode($x);
