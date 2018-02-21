#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

use lib '..';
use Primechk;

my $obj = Primechk->new(1234567890123456789012345);
   $obj->factor;

for my $i (@{$obj->factorres}){
    say $i;
}
