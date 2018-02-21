#!/usr/bin/env perl

use warnings;
use strict;
use utf8;
use feature 'say';
use Encode qw(encode_utf8 decode_utf8);
use MIME::Base64 qw/encode_base64 decode_base64/;
use bigint lib => 'GMP';

# 
my $chars = "
             おはようからこんにちわ、今晩はまで。
             いつもニコニコ明朗会計。
                 1.aaaaa
                 2.bbbbb
             色は匂へど散りぬるを我がよたれそ常ならむ有為の奥山けふ越えて、
　　　　　　 
　　　　　　 ( 240 ** 14 ) % 424 = ????
             
             阿吽」れれれ 
            ";
my @char = split(//,$chars);
my @char_enc;
my @char_dec;   # 使わない

# encode
for my $i ( @char ){
    $i = encode_utf8($i);
    push(@char_enc,$i);    
}

########################

my @b64_enc;
my @b64_dec;  # 使わない

# コードに変換
for my $i (@char_enc){
    my $code = encode_base64("$i");
    push(@b64_enc,$code);
 #   say "code: $code";
}


#######################

my @code_b64;  
my @char_b64;  # 使わない

# さらにキャラコードに変換

for my $i (@b64_enc){
    # 一文字分のコードをキャラクターで分解
    my @wordarray = split(//,$i);
    my @chararray;
        for my $j (@wordarray){
            my $chrcode = ord("$j");
            push(@chararray,$chrcode);
        }
    push(@code_b64,@chararray);
    push(@code_b64,ord("|"));  #　|を区切り文字で追加
    undef @chararray;
    undef @wordarray;
}

say "char code change";
print @code_b64;
say "";

# 配列から平文に
my $codestring = join("183",@code_b64);

say "TEXT: $codestring";

#############################################
# 暗号化ブロック  RSA暗号ロジック

my $p = 211;
my $q = 293;
my $n = $p * $q;   # 公開鍵
my $phy = ( $p - 1 ) * ( $q - 1 );
# 計算済の結果
my $e = 22129;     # 公開鍵
my $d = 7249;      # 秘密鍵
my $x = 2616;

my @code_back = split(/183/,$codestring);  # 配列に戻す

my @enc_array;
my @dec_array;

# 暗号化
#for my $i ( @code_b64 ) {
for my $i ( @code_back ) {
    my $C = ( $i ** $e ) % $n;
    push(@enc_array,$C);
}

say "Encrypt code ";
print @enc_array;
say "";

# ここにシリアライズが入るが、とりあえずパス

# 配列戻しもパス

# デコード
for my $i (@enc_array){
    my $m = ( $i ** $d ) % $n;
    push(@dec_array,$m);
}

say " Decode code ";
print @dec_array;
say "";

#############################################

# キャラコードからb６４コードへ
# 1次元配列で文字区切りを探しながらデコード
my @decodearray;
#for my $i (@code_b64){
for my $i (@dec_array){
    my $decode = chr($i);  # キャラクターへ戻す
    push(@decodearray,$decode);
}

my @codeword;
for my $i (@decodearray){
    if ( $i ne "|" ) {
        push(@codeword,$i);
    } elsif ( $i eq "|") {
        my $word = join("",@codeword);
        push(@char_b64, $word);  # ワード毎に格納  output
  #  say "word: $word";
        @codeword = ();
    }
}

########################

# b64コードからキャラクターに
#for my $i (@b64_enc){
for my $i (@char_b64){
    my $ord = decode_base64($i);
    push(@b64_dec,$ord);   # output
  #  say "decode: $ord";
}

########################

# decode  perl で表示する分には不要。webなどの出力に使う場合は必要  wide char エラーが出る
#for my $i (@char_enc){
for my $i (@b64_dec){
    $i = decode_utf8($i);
    push(@char_dec,$i);
}

my $char_join = join("",@char_dec);

say "Return Chars";
say $char_join;
