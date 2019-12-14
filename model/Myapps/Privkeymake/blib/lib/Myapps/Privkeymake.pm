package Myapps::Privkeymake;

# 公開鍵を65537に固定してもう一つの公開鍵と秘密鍵を算出する
# Privkeymake->new;
# Privkeymake->make;
# Privkeymake->result;  ハッシュ　 { d => XXXXX , n => YYYYY } で出力される

use strict;
use warnings;
use utf8;
use feature 'say';
use Data::Dumper;
use bigint lib => 'GMP';
use Math::BigInt lib => 'GMP';
use FindBin;
use Math::GMP;

use Myapps::Primechk;

our $VERSION = '0.900';


sub new {
    my ( $class , @arg ) = @_;
    # 特に何もしない

    srand(); #並列処理のため

    return bless { } , $class;
}


sub make {
    my $self = shift;

    # 素数の作成
    my $e = 65537;
    my $p;
    my $q;
    my $n;
    my $phy;
    my $end = 1;
    my $d;
    my $x;
    my $res = 0;
    my @nap;


    while ($end) {

    # 素数で在ること、phyの素因数では無いこと
     for my $j ( 0 .. 1 ){

         while ( $res == 0 ) {
             my @cont;

             for my $i ( 1 .. 300 ){
                 push(@cont, int(rand(9)));
             }

             #push (@na, join("",@cont));
             my $na = join("",@cont);
             undef @cont;

             $nap[$j] = Math::BigInt->new($na);

             # 6n+1 or 6n+5
             if ( int(rand(10)) < 5 ) {
                                    $nap[$j]->binc;
                                } else {
                                    $nap[$j]->badd(5);
                                }

             my $chk = Math::GMP->new($nap[$j]);
                $res = $chk->probab_prime(50);
          } #while res

          $res = 0;

     } # for $j

     $p = $nap[0];
     $q = $nap[1];

    # n = p x q
    $n = $p->copy();
         $n->bmul($q);

    # phy = ( p - 1) * ( q - 1)
    $phy = $p->copy();
           $phy->bdec;
           $phy->bmul($q->bdec);


                # 最大公約数を求めて、履歴から不定方程式を解く
                my $obj = Myapps::Primechk->new($e,$phy);
                   $obj->gcd;
                my $gcdres = $obj->gcdres;

                   $obj->axby1;
                my $context = $obj->equation;

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
                    } # for

                # 検算
                my $m = 16;
                my $c = Math::BigInt->new($m);
                   $c->bmodpow($e,$n);

                my $ans = Math::BigInt->new($c);
                   $ans->bmodpow($d,$n);

                if ( $ans == $m ) {
                #    say "OK   e: $e, d: $d, p: $p, q: $q";
                    $end = 0;

                    $self->{d} = $d;
                    $self->{n} = $n;

                } else {
                #    say "NG e: $e, d: $d, p: $p, q: $q";
                }

    }  # while end

} # make

sub result {
    my $self = shift;

    return { 'd' => $self->{d}, 'n' => $self->{n} };
}


1;

