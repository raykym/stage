#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';
use Data::Dumper;

use lib '/home/debian/perlwork/work/model/Primechk';
use Primechk;

#my $obj = Primechk->new(211,293);  # 2段
#my $obj = Primechk->new(1071,1029);  # 2段
#my $obj = Primechk->new(1999,1777);  # 2段
#my $obj = Primechk->new(2999,2777);  # 3段
#my $obj = Primechk->new(2251,2311);   # 3段
#my $obj = Primechk->new(2999,29989);  # 3段
my $obj = Primechk->new(3907,3947); 

   $obj->gcd;

say $obj->gcdres;

#print Dumper $obj->gcdhistory;

   $obj->axby1;

say $obj->equation;


