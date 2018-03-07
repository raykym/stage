package Codemod;

# utf8の文字列を1行入力して、コード化を行いエンコードとデコードを行う。
# 処理毎にメソッドに置き換える。
# 暗号化は別もモジュールで行う想定

# Codemod->new( 文字列);  変換用コンストラクタ  utf8の未エンコード文章を入力する
#   ->ordcode 文字列をコード化する    
#   ->ordcoderes  デコード済　コード出力する  カンマを区切り文字としている

# ordcoderesでの出力をdecnewで受け取る

# Codemod->decnew( コード ); 変換用コード (暗号化解除済)
#   ->chrcode  コードを文字列にする
#   ->chrcoderes デコード済　文字列を出力する

use strict;
use warnings;   # bigint でエラーが出るが仕方がない
use utf8;
use feature 'say';

use Encode;
use MIME::Base64 qw/encode_base64 decode_base64/;
#use bigint lib => 'GMP'; # 暗号化は別なので不要

sub new {
    my ( $class , $arg ) = @_;

    # 入力された文字列を内部コードに
    # 1行づつ入力を受ける想定

    if ( defined $arg ) {
        $arg = encode_utf8($arg);
    }

    # 空白行が入力された場合
    if ( $arg eq "" ){
        $arg = " ";   # 空白を1個追加する
    }

    return bless { 'string' => $arg } , $class;
}

sub string {
    my $self = shift;
    # 入力された文字列のアクセサー 配列リファレンス戻り  内部文字列

    my @line = split(//,$self->{string});

    return \@line; 
}

# デコード用コンストラクタ
sub decnew {
    my ( $class , $arg ) = @_;
    # 数列が入力される想定 数列なのでperlエンコードは不要と判断

    my @code = split(//,$arg);  # 1文字つづに分解
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

    return bless { 'code' => \@codes } , $class;
}

sub code {
    my $self = shift;
    # 入力されたコードを表示するアクセサー  キャラクターコードの配列リファレンス
    return $self->{code};
}


sub ordcode {
    # 文字列をコードに
    my $self = shift;

    my $code = encode_base64($self->{string},'*');  # 1行まるっとbase64エンコード  *はデコードに必要デフォルトのLFだと複号に不都合
    my @b64_enc = split(//,$code);  # ASCII文字を１文字づつ配列に

    my @code_b64;
        for my $j (@b64_enc){
            my $chrcode = ord("$j");
            push(@code_b64,$chrcode);  # b64コードがASCII一文字づつ数値配列
            undef $chrcode;
        }

 #   push(@code_b64,127);   # 127を区切りとして追加

    $self->{ordcode} = \@code_b64;

} # ordcode

sub ordcoderes {
    my $self = shift;

    my @tmp = @{$self->{ordcode}};
    my $code = join("",@tmp);   # 数列平文化

       $self->{ordcoderes} = $code;  # 数列  内部文字列 数字だから影響はないか？

    return $self->{ordcoderes};
}

sub chrcode {
    # コードを文字列に
    my $self = shift;

    my $numstr = $self->{code};
    my @chr_code;

    # 数値をキャラクターに置き換え
    for my $i (@$numstr){
        my $chr = chr($i);
        push(@chr_code,$chr);
    }

 #   my $b64_code = join("*",@chr_code);  # 1行にまとめて  encode_base64で付けた*で連結
    my $b64_code = join("",@chr_code);  # 1行にまとめて

    my $str = decode_base64($b64_code);   #１行まるっと変換を試す  
         
    $self->{chrcode} = $str;

} # chrcode

sub chrcoderes {
    my $self = shift;
    # 文字列　デコード文字列で出力
    my $string = $self->{chrcode};

       $string = decode_utf8($string);

    $self->{chrcoderes} = $string;   # 平文

    return $self->{chrcoderes};
}


1;
