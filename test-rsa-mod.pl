#!/usr/bin/env perl
# 作成したモジュールでの暗号化のテスト
# Privkeymake.pm は200桁に設定しているので、1行全角46文字程度で暗号化の限界になる。暗号化処理の中でセグメント処理を行う必要がある。
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
sub AAAAAAA {
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

} # AAAAAAAA

my $str = << "EOF";
あいうえおかきくけこさしすせそたちつてとなにぬねのまみむめもやゆよわおん
イロハニホヘトチリヌルヲワガヨタレソツネナラムウイノオクヤマケフコエテ
abcdefghijklmnopqrstuvwxyz
ABCDEFGHIJKLMNOPQRSTUVWXYZ
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

my @numstr_enc;

# 500桁づつのページに分割する
my $numstring = join("44",@page_code); # 1行に集約する  行は44(カンマ）で区切られる
my @numarray = split(//,$numstring); # 1桁づつ配列に入れ直す

my $cnt = 0;
my @page500;
my $tmp;
for ( my $i=0; $i<=$#numarray; $i++){
    $tmp = "$tmp$numarray[$i]";
    $cnt++;
    if ( $cnt == 499 ){
        push(@page500,$tmp);
        $cnt = 0;
        $tmp = "";
        next;
    }
    if ( $i == $#numarray ) {
        push(@page500,$tmp);
        last;
    }
} # for $i

#say "page500 list";
#say for @page500;


# 500桁を超えると複号は失敗する  Privkeymakeが最低桁数500桁を保証すれば問題は無い
for my $m (@page500){
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

my $chars = join("",@chrnums);  # 数列　キャラクターコードまで複号

#say "decode chars";
#say $chars;

# 数列を文字コード単位　２桁か3桁に戻す
my @chrarray = split(//,$chars);   # 数字1文字単にに分けて
my @chrs;

    # 一桁目に0,2,3が来てもスルーされる
    for (my $i=0; $i < $#chrarray; $i++ ){
        if ( $chrarray[$i] == 1 ) {
             # 一桁目が１の場合　３桁のコード
             my $chr = "$chrarray[$i]$chrarray[$i+1]$chrarray[$i+2]";
             push(@chrs,$chr);
             $i = $i + 2; # インデックスを2つすすめる
             next;
        }
        if ( $chrarray[$i] >= 4 ) {
            # 4以上の場合　２桁のキャラクターコード
            my $chr = "$chrarray[$i]$chrarray[$i+1]";
            push(@chrs,$chr);
            $i = $i + 1; # インデックスを１つすすめる
            next;
        }
    } # for $i

#say "chrs";
#say for @chrs;

# 行の区切りが44（カンマ）なので行に分ける
my @decnums;
my $tmp_line;
for (my $i=0; $i<=$#chrs; $i++){
    if ( $chrs[$i] != 44 ) {
        $tmp_line = "$tmp_line$chrs[$i]";
        if ( $i != $#chrs ) { 
                            next;
        } else { 
            # 最後の余りはここで追加される
            push(@decnums,$tmp_line);
            last;
        }
    }    
    if ($chrs[$i] == 44 ) {
        push(@decnums,$tmp_line);
        $tmp_line = "";
        next;
    }
} # for

#say for @decnums;

for my $chr (@decnums){
    my $dec = Codemod->decnew($chr);
       $dec->chrcode;

    my $decstring = $dec->chrcoderes;
#    say "decode line";
#    say $chr;
    
    say encode_utf8($decstring);
}
