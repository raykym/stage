#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

use MIME::Base64 qw/encode_base64 decode_base64/;
use Encode;



my $str = << "EOL";
イロハニホヘトチリヌルヲワガヨタレソツネナラム
あいうえおかきくけこさしすせそ
０１２３４５６７８９
東京特許許可局許可局長
在る晴れた日のこと、魔法みたいに愉快な、限りなく不可能はない
!"#0&'()=
~{`*+?><}{
EOL


my @array = split(/\n/,$str);    # １行づつに分解

say for @array;
say "END input";

# perl エンコード
my @array_enc = map { encode_utf8($_); } @array;

my @array_word;
my @b64_enc;

# 行単位でBase64に変換
for my $i (@array_enc){
        my $tmp = encode_base64($i,'*');
        push(@b64_enc,$tmp);
}

say "b64 encode";
say for @b64_enc;

my @ordb64enc;

# キャラクターコードに分解  数値化
for my $i (@b64_enc){
    my @line = split(//,$i);   # 1行を１文字に分割  ASCIIコード１文字づつの配列
    my $line_tmp;
    for my $j (@line){
        my $tmp = ord($j); 
        $line_tmp = "$line_tmp$tmp";   # 変換したキャラクターコードをつなぎ合わせる  数列
        undef $tmp;
    } # for $j
    push(@ordb64enc,$line_tmp);  # 行単位でキャラクターコードを格納
    undef $line_tmp;
} # for $i

say "b64 to chr code";
say for @ordb64enc;

say "back ASCII code";

my @chrb64enc;
# 文字列化　ASCIIこーどに戻す
for my $i (@ordb64enc){
    my @code = split(//,$i);  #数列を１桁の配列に置き換える
    my @codes;

    # Base64コードがキャラクターコードになっているので、46から122までが使われている
    # @codeのインデックスでキャラクターコードに分解する
    for (my $i=0; $i < $#code; $i++ ){
        if ( $code[$i] == 1 ) {
             # 一桁目が１の場合　３桁のコード
             my $chr = "$code[$i]$code[$i+1]$code[$i+2]";
             push(@codes,$chr);
             $i = $i + 2; # インデックスを2つすすめる
             next;
        }
        if ( $code[$i] >= 4 ) {
            # 4以上の場合　２桁のキャラクターコード
            my $chr = "$code[$i]$code[$i+1]";
            push(@codes,$chr);
            $i = $i + 1; # インデックスを１つすすめる
            next;
        }
    } # for $i

    say @codes;  

    my @chrcode;
    #数列をキャラクターコード単位に配列に収めたら、ASCIIコードに置き換える
    for my $i (@codes){
        my $tmp = chr($i);
        push(@chrcode,$tmp); 
    }

    my $tmp = join("",@chrcode);    # 1行に戻して  $iのループ毎
    push(@chrb64enc,$tmp);

} # for $i

say "chr code to b64";
say for @chrb64enc;


# b64 デコード
my @b64_dec;
my $tmp;
for my $i (@chrb64enc){
     $tmp = decode_base64($i);
     push(@b64_dec,$tmp);
}


# デコードして表示
    say "Decode start";
   say for @b64_dec;
