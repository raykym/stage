#!/usr/bin/env perl

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
my $str = "あめんぼあかいよあいうえお";

my $mess = Codemod->new($str);

   $mess->ordcode;

my $numstring = $mess->ordcoderes; # 数字列

say $numstring;

# 暗号化

my $e = 65537;
my $n = $keysres->{n};

my @numstr = split(/183/,$numstring);
my @numstr_enc;

say $#numstr;

for my $m (@numstr){
    my $enc = Math::BigInt->new($m);
       $enc->bmodpow($e,$n);
    push(@numstr_enc,$enc);
  #  say $enc;
}

my $str_enc = join("\n",@numstr_enc);

say $str_enc;

# 複号

my @enc_str = split(/\n/,$str_enc);

my $d = $keysres->{d};
my @chrstr;

for my $c (@enc_str) {
    my $chr = Math::BigInt->new($c);
       $chr->bmodpow($d,$n);
    push(@chrstr,$chr);
}

my $chars = join("183",@chrstr);

my $dec = Codemod->decnew($chars);
   $dec->chrcode;

my $decstring = $dec->chrcoderes;

say $decstring;
