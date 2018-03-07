#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';
use Math::BigInt lib => 'GMP';
use Math::GMP;
use AnyEvent;

#use lib '/home/debian/perlwork/work/model/Primechk';
use Primechk;

my $p = 9999973;     # 素数を選び
say "p: $p";

my @candi; # g候補
for my $i ( 1 .. $p ){
    my $obj = Math::GMP->new($i);
    my $res = $obj->probab_prime(50);
    if ( ($res == 1) || ($res == 2) ) {
        push(@candi,$i);        
    }
}
my $g = $candi[rand($#candi)];


say "g: $g";    # p以下の素数を選ぶ

# ここまでで公開鍵を設定した。

my @AtoB;
my @BtoA;
my $a;

 my $cv = AnyEvent->condvar;
    $cv->begin;
 my $wa; $wa = AnyEvent->timer( after => 0, interval => 1, cb => 
    sub {
            my $A = Math::BigInt->new($g);
               $a = int(rand($p-2));        # p以下の適当な数を選ぶ
            say "a: $a";

            $A->bmodpow($a,$p);             # 離散対数を計算する  (($g ** $a) % $p)
            say "A: $A";

        push(@AtoB,$A);              # 送信の代わりに配列に入れる
        say "AtoB[0]: $AtoB[0]";
        $cv->end;

    } # A
  );

my $b;
    $cv->begin;
 my $wb; $wb = AnyEvent->timer( after => 0, interval => 1, cb => 
    sub {
            my $B = Math::BigInt->new($g);; 
               $b = int(rand($p-2));
            say "b: $b";

            $B->bmodpow($b,$p);        # (($g ** $b) % $p)
            say "B: $B";

        push(@BtoA,$B);
        say "BtoA[0]: $BtoA[0]";
        $cv->end;

    } # B
);

 $cv->recv;


        # Bから通信が来ていれば
        if ( defined $BtoA[0] ) {
           my $k = Math::BigInt->new($BtoA[0]);
              $k->bmodpow($a,$p);                    # (($B ** $a) % $p)   受け取った＄Bで計算する

         #   my $k = ( $BtoA[0] ** $a ) % $p;
            say "A: K: $k";
        }


        if ( defined $AtoB[0] ) {
           my $k = Math::BigInt->new($AtoB[0]);
              $k->bmodpow($b,$p);                    # (($A ** $b) % $p)  受け取った$Aで計算する

         #   my $k = ( $AtoB[0] ** $b ) % $p;
            say "B: K: $k";
        }

# 計算結果から同じ鍵が導かれる



