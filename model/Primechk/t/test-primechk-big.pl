#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use utf8;

use bigint lib => 'GMP';
use Math::BigInt lib => 'GMP';

use lib '..';
#use lib './model/Primechk/lib';  # for SPVM

use Primechk;

$|=1;

my $NUM = Math::BigInt->new('10000000000');

while  ($NUM->blt('10000010000') )  {

    my $obj = Primechk->new($NUM);

       $obj->checkspvm;

       say "$NUM is Prime number..." if ( $obj->result == 1);
    #   say "$NUM is Not Prime number." if ( $obj->result == 0 );

    $NUM->binc;

}
