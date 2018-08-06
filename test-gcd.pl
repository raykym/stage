#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';
use FindBin;

#use lib "$FindBin::Bin/model/Primechkr";
use Myapps::Primechk;
use Data::Dumper;

my $obj = Myapps::Primechk->new(9243532423425234,742693835267235);
   $obj->gcd;
say $obj->gcdres;

   $obj->axby1;
say $obj->equation;
