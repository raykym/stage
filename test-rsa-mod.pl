#!/usr/bin/env perl
# 作成したモジュールでの暗号化のテスト

use strict;
use warnings;
use utf8;
use feature 'say';

#use FindBin;
#use lib "$FindBin::Bin/model/Privkeymake";
#use lib "$FindBin::Bin/model/Codemod";
# make install したのでコメントアウト

use Privkeymake;
use Codemod;

use Math::BigInt lib => 'GMP';

$|=1;

say "start key generate";
# 鍵の作成
my $keys = Privkeymake->new;
   $keys->make;
my $keysres = $keys->result;  # HASH

say "d: $keysres->{d}";
say "n: $keysres->{n}";

say "message convert";

# メッセージの作成
my $str = << "EOF";
あめんぼあかいよあいうえお
株式会社ほげほげ
イロハニホヘトチリヌルヲワガヨタレソ
アイウエオカキクケコサシスセソ
０１２３４５６７８９
亜居兎絵御化気区毛個
!"#$%&'()=~{`*+?><}{
EOF

my @page = split(/\n/,$str);  # 行に分解
my @page_code;

say "base strings";
say for @page;

# 行単位でコード化
for my $i ( @page) {
  #  $i =~ s/[\s　]+//g;  # 空白の除去
    my $mess = Codemod->new($i);
       $mess->ordcode;
    my $numstring = $mess->ordcoderes; # 数字列
    push(@page_code,$numstring);
     say "chrcode:";
     say $numstring;
} # for


# 暗号化

my $e = 65537;
my $n = $keysres->{n};

my @numstr_enc;

for my $m (@page_code){
    my $enc = Math::BigInt->new($m);
       $enc->bmodpow($e,$n);
    push(@numstr_enc,$enc);
  #  say $enc;
}

my $str_enc = join("\n",@numstr_enc);

say "encode string";
say $str_enc;    #暗号化したページ



# 複号

my @enc_str = split(/\n/,$str_enc);

my $d = $keysres->{d};
my @chrnums;

for my $c (@enc_str) {
    my $chr = Math::BigInt->new($c);
       $chr->bmodpow($d,$n);
    push(@chrnums,$chr);
}

my $chars = join("\n",@chrnums);  # 数列　キャラクターコードまで複号

say "decode chars";
say $chars;

my @decnums = split(/\n/,$chars);

for my $chr (@decnums){
    my $dec = Codemod->decnew($chr);
       $dec->chrcode;

    my $decstring = $dec->chrcoderes;
    say "decode line";
    say $chr;
    say $decstring;
}
