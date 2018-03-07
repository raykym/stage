#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

#use bigint lib =>'GMP';
use Math::BigInt lib => 'GMP';

my $e = 65537;   # 適当
#my $x = 290;    #適当

my $p = 9999863;
my $q = 9999907;

my $n = $p * $q;

my $m = 102;

#my $c = (($m ** $e ) % $n);
my $c = Math::BigInt->new($m);
   $c->bmodpow($e,$n);

say $c;

#my $dec = (($c ** $e) % $n);
my $dec = Math::BigInt->new($c);
   $dec->bmodpow($e,$n);

say $dec;
