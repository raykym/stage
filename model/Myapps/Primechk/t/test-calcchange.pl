#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

#use lib '..';
use  Myapps::Primechk;

my $obj = Myapps::Primechk->new(211,293);

   $obj->gcd;

   $obj->axby1;

   say $obj->equation;

