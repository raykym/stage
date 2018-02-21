package Codemod;

# utf8の文字列を入力して、コード化を行いエンコードとデコードを行う。
# 処理毎にメソッドに置き換える。
# 暗号化は別もモジュールで行う想定

# Codemod->new( 文字列);  変換用コンストラクタ  utf8の未エンコード文章を入力する
#   ->ordcode 文字列をコード化する
#   ->ordcoderes  デコード済　コード出力する

# ordcoderesでの出力をdecnewで受け取る、区切り文字を付けてシリアライズしている

# Codemod->decnew( コード ); 変換用コード (解読済)
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

    # 入力された文字列を内部コードにして、配列に置き換える
    my @char = split(//,$arg);
    my @char_enc;

    for my $i (@char){
        $i = encode_utf8($i);
        push(@char_enc,$i);
    }
    undef @char;
    return bless { 'string' => \@char_enc } , $class;
}

sub string {
    my $self = shift;
    # 入力された文字列のアクセサー 配列リファレンス戻り  内部文字列
    return $self->{string}; 
}

# デコード用コンストラクタ
sub decnew {
    my ( $class , $arg ) = @_;

    my @code = split(/183/,$arg);  # 区切り文字で配列化

    return bless { 'code' => \@code } , $class;
}

sub code {
    my $self = shift;
    # 入力されたコードを表示するアクセサー  配列リファレンス
    return $self->{code};
}


sub ordcode {
    # 文字列をコードに
    my $self = shift;

    my @b64_enc;
    my $string = $self->{string};
    for my $i (@$string){
        my $code = encode_base64("$i");
        push(@b64_enc,$code);
     #   say "code: $code";
    }

    my @code_b64;
    for my $i (@b64_enc){
        # 一文字分のコードをキャラクターで分解
        my @wordarray = split(//,$i);
        my @chararray;
            for my $j (@wordarray){
                my $chrcode = ord("$j");
                push(@chararray,$chrcode);
             #  say "word: $chrcode";
            }
        push(@code_b64,@chararray);
        push(@code_b64,ord("|"));  #　|を区切り文字で追加
        undef @chararray;
        undef @wordarray;
    }

    $self->{ordcode} = \@code_b64;

} # ordcode

sub ordcoderes {
    my $self = shift;

    my @tmp = @{$self->{ordcode}};
    my $code = join("183",@tmp);   # 区切り文字を付けて平文化

       $self->{ordcoderes} = $code;  # 平文

    return $self->{ordcoderes};
}

sub chrcode {
    # コードを文字列に
    my $self = shift;

    my $code = $self->{code};

    # キャラコードからb６４コードへ
    # 1次元配列で文字区切りを探しながらデコード
    my @decodearray;
    for my $i (@$code){
        my $decode = chr($i);  # キャラクターへ戻す
        push(@decodearray,$decode);
      #  say "decode: $decode";
    }

    my @codeword;
    my @char_b64;
    # |を区切りとしてb64ワードに戻す
    for my $i (@decodearray){
        if ( $i ne "|" ) {
            push(@codeword,$i);
        } elsif ( $i eq "|") {
            my $word = join("",@codeword);
            push(@char_b64, $word);
          #  say "word: $word";
            @codeword = ();
        }
    }
    
    my @b64_dec;
    # b64コードから文字列に
    for my $i (@char_b64){
        my $chr = decode_base64($i);
        push(@b64_dec,$chr);
      #  say "decode: $chr";
    }

    $self->{chrcode} = \@b64_dec;

} # chrcode

sub chrcoderes {
    my $self = shift;
    # 文字列　デコード文字列で出力
    my $string = $self->{chrcode};

    my @char_dec;
    for my $i (@$string){
        $i = decode_utf8($i);
        push(@char_dec,$i);
    }

    my $str = join("",@char_dec);

    $self->{chrcoderes} = $str;   # 平文

    return $self->{chrcoderes};
}


1;
