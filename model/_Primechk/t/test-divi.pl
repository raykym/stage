#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

use lib '..';
use lib '../lib';
use Primechk;

my $obj = Primechk->new(28282828);

say "-------divisor";

  $obj->divisorspvm;

  my $res = $obj->divisorres;

  for my $i (@$res){
     say $i;
  }

