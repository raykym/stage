#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

use bigint lib => 'GMP';

use lib '/home/debian/perlwork/work/model/Primechk';
use Primechk;

my $p = 9999991;
my $q = 9999889;

my $e = 106164011;   # 計算の一つ  
my $d = 35777219;   # 答え

# e n が公開鍵で

my $n = $p * $q;

my $phy_b = ( $p - 1 ) * ( $q - 1 );
say "phy_b: $phy_b";

my $obj = Primechk->new($n);

   $obj->factor;

my $res = $obj->factorres;

 map { say $_ ; } @$res;





sub AAAAA {

my @tmp = @$res;

my $phy = ( $tmp[0] - 1 ) * ( $tmp[1] - 1);
say "phy: $phy";

my $obj2 = Primechk->new($e,$phy);
   $obj2->gcd;
   $obj2->axby1;

my $context = $obj2->equation;
say $context;
my @text = split / /,$context;
my $x;
my $cal_d;  # 式から読み出す
   for (my $i=0; $i<$#text; $i++){
       if ( $text[$i] =~ /^?\d$/ ) {
           if ( $text[$i] == $e ){
               $cal_d = $text[$i+2];  # $eから２個後ろの数字
               next;
           } elsif ( $text[$i] == $phy ){
               $x = $text[$i+2];
               next;
           }
       } else {
           next;
       }
   }

#my $d = $e ** -1 % $phy;

   say "cal_d: $cal_d";
   say "x: $x";
}




