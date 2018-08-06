#!/usr/bin/env perl
# privkey.pl {num} {num}
# 素数から公開鍵を羅列する

use strict;
use warnings;
use utf8;
use feature 'say';
use Data::Dumper;
use bigint lib => 'GMP';
use Math::BigInt lib => 'GMP';
use FindBin;

#use lib "$FindBin::Bin/model/Primechk";
use Myapps::Primechk;

$| = 1;

my $p = $ARGV[0];
   say "p: $p";
my $q = $ARGV[1];
   say "q: $q";
my $n = $p * $q;
   say "n: $n";    # 公開鍵１

my $phy = ($p - 1 ) * ( $q - 1);
   say "phy: $phy";

my $e;

my $phyfac = Myapps::Primechk->new($phy);
   $phyfac->factor;
my $resphyfac = $phyfac->factorres;

# オイラーφ関数の中から候補を抽出
# $n以下の素数で、$phyのfactorでは無いも
my @candi;  # e 候補
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
                    #    say "drop: $i";
                        last;
                    }
                }
                push(@candi,$i) if ($flg == 0);
             #   say $i if ($flg == 0);
            } #if
    } # for $i
}

my @ANS;
my @ANS_ok;
for my $j ( @candi ){

   if ( $j >= $phy){
       last;
   }

   my $e = $j;

   say "e: $e";

my $obj = Myapps::Primechk->new($e,$phy);
   $obj->gcd;
my $gcdres = $obj->gcdres;
say " gcd: ($e , $phy) = $gcdres";

   $obj->axby1;
my $context = $obj->equation;
say $context; 

my @text = split / /,$context;   # 式を配列に分解する
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

say "d: $d";
say "x: $x";

say "------";

my $m = 16;
   say "m: $m";

#my $c = ($m ** $e) % $n;
my $c = Math::BigInt->new($m);
   $c->bmodpow($e,$n);
   say "C: ( $m ** $e ) % $n = $c";

#my $ans = ($c ** $d) % $n;
my $ans = Math::BigInt->new($c);
   $ans->bmodpow($d,$n);

   say "ans: ( $c ** $d ) % $n = $ans";
   say "--- next ---";
   say " ";

   if ( $ans == $m ) {
       my $ref = [ $e , 'ok' ];
       push(@ANS,$ref);
       push(@ANS_ok,$ref);
   } else {
       my $ref = [ $e , 'NG' ];
       push(@ANS,$ref);
   }

} #for $j

say "----------";
my $cnt = @candi; #個数
my $pkeys = @ANS_ok;
say "cnt: $pkeys / $cnt";
#print Dumper @ANS;
print Dumper @ANS_ok;
