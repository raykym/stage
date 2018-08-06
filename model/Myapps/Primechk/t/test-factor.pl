#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

use lib '..';
use Primechk;

my $obj = Primechk->new(100000000000001);
   $obj->factor;

for my $i (@{$obj->factorres}){
    say $i;
}
