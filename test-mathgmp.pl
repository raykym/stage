#!/usr/bin/env perl 

use strict;
use warnings;
use utf8;
use feature 'say';
use FindBin;

use Math::GMP;

for my $i ( 1000000000000000000 .. 2000000000000000000){
    my $num = Math::GMP->new($i);
    my $res = $num->probab_prime(50);

    say "res: $i  | $res" if (($res == 1) || ( $res == 2));
}
