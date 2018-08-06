#!/usr/bin/env perl

# キャラクターの分解、再構築のテスト

use strict;
use warnings;
use utf8;
use feature 'say';

use lib '../lib';
use Codemod;

#my $str = "あいうえおかきくけこさしすせそ";
my $str = "イロハニホヘトチリヌルヲワガヨタレソツネナラム";

my $obj = Codemod->new($str);
   $obj->ordcode;
say $obj->ordcoderes;

my $tmp = $obj->ordcoderes;

my @code = split(//,$tmp);
my @codes;

    for (my $i=0; $i < $#code; $i++ ){
        if ( $code[$i] == 1 ) {
             # 一桁目が１の場合　３桁のコード
             my $chr = "$code[$i]$code[$i+1]$code[$i+2]"; 
             push(@codes,$chr);
             $i = $i + 2 ; # インデックスを2つすすめる
        }
        if ( $code[$i] >= 4 ) {
            # 4以上の場合　２桁のキャラクターコード
            my $chr = "$code[$i]$code[$i+1]";
            push(@codes,$chr);
            $i++ ; # インデックスを１つすすめる
        }
    } # for

say @codes;

my $code = join("",@codes);

#for my $i ( @codes) {
#   say chr($i);
#}

my $dec = Codemod->decnew($code);

   $dec->chrcode;

my $res = $dec->chrcoderes;
say $res;



