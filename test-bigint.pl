#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

use Math::BigInt;

my $a = Math::BigInt->new('89');

say $a->blcm(0.2);

