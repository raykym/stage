#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';
use FindBin;

#use lib "$FindBin::Bin/model/Primechkr";
use Myapps::Primechk;
use Data::Dumper;
use Mojo::JSON qw/ from_json to_json /;

#my $obj = Myapps::Primechk->new(9243532423425234,742693835267235);
my $obj = Myapps::Primechk->new(125,15);
   $obj->gcd;
say $obj->gcdres;
#say Dumper $obj->gcdhistory;

for my $i (@{$obj->gcdhistory}){
    my $line = to_json($i);
    say $line;
} #i

   $obj->axby1;
say $obj->equation;
