#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

use Myapps::Primechk;
use Math::GMP;
use Data::Dumper;

for my $num ( 1 .. 1000){ 

my $chk_num = Math::GMP->new($num);

my $chkres = $chk_num->probab_prime(50);

if ($chkres != 0 ){

#	say "prime num! $num";
	#exit;
	next;
}

my $obj = Myapps::Primechk->new($num);

   $obj->divisor;
   my $add = Math::BigInt->new(0);
   for my $i (@{$obj->divisorres}) {
	   if ( $num == $i ){
               next;
	   }
       $add->badd($i);		   
   }		  
   #  say " add: $add";

   if ($add->beq($num)){
      say " perfect: $num";
      #say "factor";
      # for my $i (@{$obj->divisorres}) {
      #    say for $i;		   
      #}		  
   }



if (0) {
   my $obj2 = Myapps::Primechk->new($num);
   $obj2->divisor;
   say "divisor";
   for my $i (@{$obj2->divisorres}) {
       say Dumper for $i;
   }
   } # block

} # for
