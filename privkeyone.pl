#!/usr/bin/env perl
# privkey.pl {num} {num}
# 素数から公開鍵 最初の１個を算出する
# 乱数で位置取りを決める 

use strict;
use warnings;
use utf8;
use feature 'say';
use Data::Dumper;
use bigint lib => 'GMP';
use Math::BigInt lib => 'GMP';
use FindBin;
use Math::GMP;

use lib "$FindBin::Bin/model/Primechk";
use Primechk;

$| = 1;

my $p = $ARGV[0];
   say "p: $p";
my $q = $ARGV[1];
   say "q: $q";
#my $n = $p * $q;
my $n = Math::BigInt->new($p);
   $n->bmul($q);
   say "n: $n";    # 公開鍵１

#my $phy = ($p - 1 ) * ( $q - 1);

my $bp = Math::BigInt->new($p);
   $bp->bdec;
my $bq = Math::BigInt->new($q);
   $bq->bdec;

my $phy = $bp->bmul($bq);

   say "phy: $phy";

my $e;
say "-----";

my $phyfac = Primechk->new($phy);
   $phyfac->factor;
say "factor check END!";
my $resphyfac = $phyfac->factorres;

my $rnd = int(rand($phy/2));  # 開始位置をランダムで決める

# オイラーφ関数の中から候補を抽出
# $n以下の素数で、$phyのfactorでは無いも
    for (my $i=$phy-$rnd; $i>1; $i-- ){
  #  for (my $i=$phy-1; $i>1; $i-- ){
      #  my $CHK = Primechk->new($i);
      #     $CHK->checkspvm;
         my $CHK = Math::GMP->new($i);
         my $res = $CHK->probab_prime(50);
      #      if ( $CHK->result ) {
            if ( ($res == 1) || ($res == 2) ) {
                my $flg = 0;
                # factorを除外
                for my $j (@$resphyfac){
                    if ( $j == $i ){
                        $flg = 1;  # factorに一致
                    #    say "drop: $i";
                        last;
                    }
                }
              #  push(@candi,$i) if ($flg == 0);
                 #  my $e = $i;
                   my $e = Math::BigInt->new($i);

                   say "e: $e";

                my $obj = Primechk->new($e,$phy);
                   $obj->gcd;
                my $gcdres = $obj->gcdres;
              #  say " gcd: ($e , $phy) = $gcdres";

                   $obj->axby1;
                my $context = $obj->equation;
              say $context; 

                my @text = split / /,$context;   # 式を配列に分解する
                my $x;
                my $d;  # 式から読み出す
                   for (my $i=0; $i<$#text; $i++){
                       if ( $text[$i] =~ /^?\d$/ ) {
                           if ( $text[$i] == $e ){
                               $d = Math::BigInt->new($text[$i+2]);  # $eから２個後ろの数字
                               next;
                            } elsif ( $text[$i] == $phy ){
                                $x = Math::BigInt->new($text[$i+2]);
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
             #   say "m: $m";

                my $c = Math::BigInt->new($m);
                   $c->bmodpow($e,$n);
             #   say "C: ( $m ** $e ) % $n = $c";

                my $ans = Math::BigInt->new($c);
                   $ans->bmodpow($d,$n);

             #   say "ans: ( $c ** $d ) % $n = $ans";
             #   say "--- next ---";
             #   say " ";

                if ( $ans == $m ) {
                    say "e: $e ok";
                    last;  # 終了する
                } else {
                    say "e: $e NG";
                    say "-------";
                }

             #   say $i if ($flg == 0);
            } #if
    } # for $i



