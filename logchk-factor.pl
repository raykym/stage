#!/usr/bin/env perl
#
use strict;
use warnings;
use utf8;
use feature 'say';

use Math::GMP;
use Math::BigInt lib => 'GMP';
use bigint lib => 'GMP';

my $num = 28;

my @res;

my $i = 2;

push(@res,1);

while ( $i <= $num ){

    my $chk = 0;

    #  my $chk_num = Math::GMP->new($num);
    #  my $chk_prime = $chk_num->probab_prime(50);
    #  last if ( $chk_prime != 0);

	my $num_tmp = $num->copy();
	#$chk = $num % $i;
	$num_tmp->bmod($i);
	$chk = $num_tmp->copy();

	if ($chk == 0 ){
           push(@res , $i );
	}

    $i++;
} # while $i


say for @res;
