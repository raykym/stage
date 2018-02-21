#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use utf8;

#use bigint lib => 'GMP';

use lib '..';
#use lib './model/Primechk/lib';  # for SPVM

use Primechk;

$|=1;

for my $i (1000000000000000000 .. 2000000000000000000) {

    my $obj = Primechk->new($i);

       $obj->checkspvm;

       say "$i is Prime number..." if ( $obj->result == 1);
       say "$i is Not Prime number." if ( $obj->result == 0 );

}
