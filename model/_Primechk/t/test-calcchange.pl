#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

use lib '..';
use  Primechk;

my $obj = Primechk->new(211,293);

   $obj->gcd;

   $obj->axby1;

   say $obj->equation;

