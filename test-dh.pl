#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';
use Math::BigInt;
use AnyEvent;

use lib '/home/debian/perlwork/work/model/Primechk';
use Primechk;

my $p = 11100101029;
say "p: $p";

my @candi; # g候補
for my $i ( $p-100 .. $p ){
    my $obj = Primechk->new($i);
       $obj->checkspvm;
    if ( $obj->result ) {
        push(@candi,$i);        
    }
}
my $g = $candi[rand($#candi)];


say "g: $g";

# ここまでで公開鍵を設定した。

my @AtoB;
my @BtoA;
my $a;

 my $cv = AnyEvent->condvar;
    $cv->begin;
 my $wa; $wa = AnyEvent->timer( after => 0, interval => 1, cb => 
    sub {
            my $A = Math::BigInt->new($g);
               $a = int(rand($p-2));
            say "a: $a";

            $A->bmodpow($a,$p);
            say "A: $A";

        push(@AtoB,$A);
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

            $B->bmodpow($b,$p);
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
              $k->bmodpow($a,$p);

         #   my $k = ( $BtoA[0] ** $a ) % $p;
            say "A: K: $k";
        }


        if ( defined $AtoB[0] ) {
           my $k = Math::BigInt->new($AtoB[0]);
              $k->bmodpow($b,$p);

         #   my $k = ( $AtoB[0] ** $b ) % $p;
            say "B: K: $k";
        }





