#!/usr/bin/env perl
# privkeymake.pl
# 公開鍵を65537に固定して組み合わ素数を調べる

use strict;
use warnings;
use utf8;
use feature 'say';
use Data::Dumper;
use bigint lib => 'GMP';
use Math::BigInt lib => 'GMP';
use FindBin;
use Math::GMP;

#use lib "$FindBin::Bin/model/Primechk";
use Primechk;

$| = 1;

while(1){    # 無限ループ

my $end = 1;

my $e = 65537;
my $n;
my $phy;

my $res_p = 0;
my $res_q = 0;

my $p;
my $q;
my $d;
my $x;

while ($end){

    say "---START---";

    # 素数作成
    while ( ($res_p == 0 ) || ($res_q == 0 )){
        # 乱数でベースを選ぶ
        my $n1 = int(rand(99999999999999999999));
        my $n2 = int(rand(99999999999999999999));

        if ( $n1 == $n2 ) {
            $n2 = int(rand(99999999999999999999));
        }

           $p = Math::BigInt->new($n1);
           $q = Math::BigInt->new($n2);   

           # 6n+1 or 6n+5
           $p->bmul(6);
           if ( int(rand(10)) < 5 ) {
                                       $p->binc;
                                   } else {
                                       $p->badd(5);
                                   }
           $q->bmul(6);
           if ( int(rand(10)) < 5 ) {
                                       $q->badd(5);
                                    } else {
                                       $q->binc;
                                    }

        my $chk_p = Math::GMP->new($p);
        my $chk_q = Math::GMP->new($q);

           $res_p = $chk_p->probab_prime(50);
           $res_q = $chk_q->probab_prime(50);

        say "p: $p";
        say "q: $q";
        say "make prime";
        say "";
    } # while

    # n = p x q
    $n = $p->copy();
         $n->bmul($q);
    say "n: $n";
    say "";

    # phy = ( p - 1) * ( q - 1)
    $phy = $p->copy();   
           $phy->bdec;
           $phy->bmul($q->bdec);
    say "phy: $phy";
    say "";

    # 割り切れたらfactorなのでパス
    my $chk_phy = $phy->copy();
       $chk_phy->bmod($e);

    if ($chk_phy->is_zero){
        $end = 0;
        say "e is phy factor!";
        exit;
    }

                # 最大公約数を求めて、履歴から不定方程式を解く
                my $obj = Primechk->new($e,$phy);
                   $obj->gcd;
                my $gcdres = $obj->gcdres;
                say " gcd: ($e , $phy) = $gcdres";

                   $obj->axby1;
                my $context = $obj->equation;
                say $context;

                my @text = split / /,$context;   # 式を配列に分解する

                   # 式から読み出す
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


                my $m = 16;
                say "m: $m";

                my $c = Math::BigInt->new($m);
                   $c->bmodpow($e,$n);
                say "C: ( $m ** $e ) % $n = $c";

                my $ans = Math::BigInt->new($c);
                   $ans->bmodpow($d,$n);

                say "ans: ( $c ** $d ) % $n = $ans";
                say " ";

                if ( $ans == $m ) {
                    say "OK   e: $e, d: $d, p: $p, q: $q";
                    open( DATA, ">>", "./d.txt" );
                    print DATA "OK   e: $e, d: $d, p: $p, q: $q\n";
                    $end = 0;
                    say "--- end ---";
                    close(DATA) ;
                #    exit;  # 終了する
                } else {
                    say "NG e: $e, d: $d, p: $p, q: $q";
                    say "--- next ---";
                }

} # while end

} # while(1)
