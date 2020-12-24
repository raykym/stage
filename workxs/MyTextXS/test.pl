#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature ':5.13';

use ExtUtils::testlib;
use MyTextXS;

my $num = 100;

my $res = MyTextXS::increment2($num);

say "increment2: $res";

my $res3 = MyTextXS::increment3($num);

say "increment3: $res3";

my $rad = 0.1;
my $ress = MyTextXS::sin($rad);

say "sin: $ress";

