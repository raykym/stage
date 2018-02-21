#!/usr/bin/env perl

# RSA暗号の段取りを確認する

use strict;
use warnings;
use utf8;
use feature 'say';
use Data::Dumper;
use Math::BigInt;
use FindBin;

use lib "$FindBin::Bin/model/Primechk";
use Primechk;

$| = 1;

my $p = 211;
   say "p: $p";
my $q = 293;
   say "q: $q";
my $n = $p * $q;
   say "n: $n";

my $phy = ($p - 1 ) * ( $q - 1);
   say "phy: $phy";

my $e;

my $phyfac = Primechk->new($phy);
   $phyfac->factor;
my $resphyfac = $phyfac->factorres;

# オイラーφ関数の中から候補を抽出
# $n以下の素数で、phyのfactorでは無いもの
while ( ! defined $e ) {
my @candi;  # e 候補
my $ind;
if (!@candi){
    for my $i ( 1 .. $phy ){
        my $CHK = Primechk->new($i);
           $CHK->checkspvm;
        if ( $CHK->result ) {
            my $flg = 0;
            # factorを除外
            for my $j (@$resphyfac){
                if ( $j == $i ){
                    $flg = 1;  # factorに一致
                    say "drop: $i";
                    last;
                }
            }
        push(@candi,$i) if ($flg == 0);  # factorで無いものを登録
     #   say $i if ($flg == 0);
        } #if
    }
    $ind = rand($#candi);
}

   $e = $candi[$ind] if ( $candi[$ind] < $phy);
}


sub aaa{
# p-1 とq-1の最小公倍数 +1
my $e = Math::BigInt->new($p-1);  
   $e->blcm($q-1);
   $e->binc;
}


   say "e: $e";

my $obj = Primechk->new($e,$phy);
   $obj->gcd;
my $gcdres = $obj->gcdres;
say " gcd: ($e , $phy) = $gcdres";

   $obj->axby1;
my $context = $obj->equation;
say $context;
my @text = split / /,$context;
my $x;
my $d;  # 式から読み出す
   for (my $i=0; $i<$#text; $i++){
       if ( $text[$i] =~ /^?\d$/ ) {
           if ( $text[$i] == $e ){
               $d = $text[$i+2];  # $eから２個後ろの数字
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

   say "d: $d";
   say "x: $x";

say "------";

my $m = 296;
   say "m: $m";

#my $c = ($m ** $e) % $n;
my $c = Math::BigInt->new($m);
   $c->bmodpow($e,$n);
   say "C: ( $m ** $e ) % $n = $c";

#my $ans = ($c ** $d) % $n;
my $ans = Math::BigInt->new($c);
   $ans->bmodpow($d,$n);

   say "ans: ( $c ** $d ) % $n = $ans";


