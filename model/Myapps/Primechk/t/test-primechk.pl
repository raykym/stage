#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use utf8;

#use bigint lib => 'GMP';

#use lib '..';
#use lib './model/Primechk/lib';  # for SPVM

use Myapps::Primechk;

$|=1;

for my $i (100000000 .. 200000000) {

    my $obj = Myapps::Primechk->new($i);

       $obj->check;

       say "$i is Prime number..." if ( $obj->result == 1);
       say "$i is Not Prime number." if ( $obj->result == 0 );

}
