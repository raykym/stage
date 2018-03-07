#!/usr/bin/env perl
# 作成したモジュールでの暗号化のテスト
# Privkeymake.pm は600桁に設定しているの。暗号化処理の中でセグメント処理を行う。
# Codemod.pmは文字列をキャラクターコードに置き換えるが、桁数の制限などは特に無い

use strict;
use warnings;
use utf8;
use feature 'say';
use Encode qw/encode_utf8 decode_utf8/;

#use FindBin;
#use lib "$FindBin::Bin/model/Privkeymake";
#use lib "$FindBin::Bin/model/Codemod";
# make install したのでコメントアウト

use Privkeymake;    # キー作成
use Codemod;        # 文字列の数値化と複号
use Rsacrypt;

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

１．とりあえず文章ッパ位もの
２．えーっと、どんな文章にしたら良いだろか？
３．まるっと変換すると、大丈夫だろうか？

長い一行を用意した場合、
それはエンコードする数列の範囲に収まるように出来るのだろうか？それとも　延々と入力されてオーバーフローを起こすのだろうか？

　　　　　　　　　　　　　　2018.03.02
　　　　　　　　　　　　　　征馬孤影

EOF


my @page = split(/\n/,$str);  # 行に分解
my @page_code;

say "base strings";
say for @page;

# 行単位でコード化   コード化そのものには桁数上限は特に無い
for my $i ( @page) {
    my $mess = Codemod->new($i);
       $mess->ordcode;
    my $numstring = $mess->ordcoderes; # 数字列
    push(@page_code,$numstring);
#     say "chrcode:";
#     say $numstring;
} # for

say "chrcode";
say for @page_code;


# 暗号化

my $e = 65537;   # 固定値
my $n = $keysres->{n};

my $input_code = join("\n",@page_code);

my $obj = Rsacrypt->new($input_code);
   $obj->pubkey($n);
   $obj->encode;
my $enc_nums = $obj->encoderes;    # 改行付き平文　数列  メールなどでやり取りに使う

say "enc num:";
say $enc_nums;

# 複号

my $d = $keysres->{d};

my $obj2 = Rsacrypt->new($enc_nums);
   $obj2->privkey({d=>$d,n=>$n});
   $obj2->decode;
my $res = $obj2->decoderes;    #配列リファレンス

my @decnums = @$res;

for my $chr (@decnums){
    my $dec = Codemod->decnew($chr);
       $dec->chrcode;

    my $decstring = $dec->chrcoderes;
#    say "decode line";
#    say $chr;
    
    say encode_utf8($decstring);
}
