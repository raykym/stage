package Privkeymake;

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

use lib '/home/debian/perlwork/work/model/Primechk';
use Primechk;


sub new {
    my ( $class , @arg ) = @_;
    # 特に何もしない

    return bless { } , $class;
}


sub make {
    my $self = shift;

    # 素数の作成
    my $e = 65537;
    my $res_p = 0;
    my $res_q = 0;
    my $p;
    my $q;
    my $n;
    my $phy;
    my $end = 1;
    my $d;
    my $x;

    while ($end) {

    # 素数で在ること、phyの素因数では無いこと
    while (($res_p == 0 ) || ($res_q == 0 )) {
        # 乱数でベースを選ぶ
        my $n1 = int(rand(9999999999999999999999999999999999999999999999999999));
        my $n2 = int(rand(9999999999999999999999999999999999999999999999999999));

        if ( $n1 == $n2 ) {
            $n2 = int(rand(9999999999999999999999999999999999999999999999999999));
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

    } # while

    # n = p x q
    $n = $p->copy();
         $n->bmul($q);

    # phy = ( p - 1) * ( q - 1)
    $phy = $p->copy();
           $phy->bdec;
           $phy->bmul($q->bdec);


                # 最大公約数を求めて、履歴から不定方程式を解く
                my $obj = Primechk->new($e,$phy);
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

