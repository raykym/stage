package Myapps::Rsacrypt;

# 数列を入力して、RSA暗号方式で暗号化、複号する
# $eは固定値　公開鍵$nを受け取って暗号化。　秘密鍵$dと$nを受け取って複号する

# 逐次処理は想定していない。コード化されたものは一括で処理する仕組み
# Codemodのbase64でのコーディングの区切りを読み取る必要がある。

# Rsacrypt->new(改行付き平文数列);   b64形式の数値化されたASCIIコード
#         ->string;      アクセサー  数列が返る

# Rsacrypt->pubkey(数列);  公開鍵の指定
#         ->pkey;          公開鍵のアクセサー 　ハッシュリファレンス
#          ->encode;        暗号化　数列配列を受け入れる想定
#          ->encoderes;    改行付きの平文 

# Rsacrypt->privkey({ d => 数列, n  => 公開鍵 });
#         ->vkey;          秘密鍵のアクセサー   ハッシュリファレンス
#         ->decode;        復号化  まとめて配列を入力される想定
#         ->decoderes;     配列リファレンス

use strict;
use warnings;
use utf8;
use feature 'say';

use Math::BigInt lib => 'GMP';

$|=1;

our $VERSION = '0.900';

sub new {
    my ($class , @arg ) = @_;

    # 数列を入力する  $argは改行付き平文数列

    my @array = split(/\n/,$arg[0]);

    return bless { 'string' => \@array } , $class;
}

sub pubkey {
    my ( $self, @arg ) = @_;
    # エンコード用公開鍵入力   after new!!

    $self->{e} = 65537;
    $self->{n} = $arg[0];

}

sub privkey {
    my ( $self , @arg ) = @_;
    # プライベートキー　->privkey({ d=> xxxxxxx , n =>  yyyyyyy});
    # $argはハッシュリファレンス   after new!!

    $self->{d} = $arg[0]->{d};
    $self->{n} = $arg[0]->{n};

}

sub string {
    my $self = shift;

    return $self->{string};
}

sub pkey {
    my $self = shift;
    # 公開鍵をハッシュリファレンスで返す

    my $res = { e => $self->{e}, n => $self->{n} };

    return $res;

}

sub vkey {
    my $self = shift;

    my $res = { d => $self->{d} , n => $self->{n} };

    return $res;
}

sub encode {
    my $self = shift;

    # input check
    if ( ! defined $self->{n} ) {
        say "Input error Non public key";
        return;
    }
    if ( ! defined $self->{string} ) {
        say "Input error Non string";
        return;
    }
    
    my @str = @{$self->{string}};

    # 500桁づつのページに分割する   
    my $numstring = join("44",@str); # 1行に集約する  行は44(カンマ）で区切られる
    my @numarray = split(//,$numstring); # 1桁づつ配列に入れ直 

    my $cnt = 0;
    my @page500;
    my $tmp_line;
    for ( my $i=0; $i<=$#numarray; $i++){
        $tmp_line = "$tmp_line$numarray[$i]";
        $cnt++;
        if ( $cnt == 499 ){
            push(@page500,$tmp_line);
            $cnt = 0;
            $tmp_line = "";
            next;
        }
        if ( $i == $#numarray ) {
            push(@page500,$tmp_line);
            last;
        }
    } # for $i

    my @numstr_enc;

    # 600桁を超えると複号は失敗する  Privkeymakeが最低桁数600桁を保証すれば問題は無い
    for my $m (@page500){
        my $enc = Math::BigInt->new($m);
           $enc->bmodpow($self->{e},$self->{n});
        push(@numstr_enc,$enc);
      #  say $enc;
    }

    my $str_enc = join("\n",@numstr_enc);

    $self->{encoderes} = $str_enc;     # 500桁の数列がテキストで出力

} # encode

sub encoderes {
    my $self = shift;

    return $self->{encoderes};
}

sub decode {
    my $self = shift;

    # input check
    if ( ! defined $self->{d} ){
        say "Input error privkey";
        return;
    }
    if ( ! defined $self->{n} ) {
        say "Input error public key";
        return;
    }
    if ( ! defined $self->{string} ){
        say "Input error string";
        return;
    }

    my @enc_str = @{$self->{string}};
    my @chrnums;

    for my $c (@enc_str) {
        my $chr = Math::BigInt->new($c);
           $chr->bmodpow($self->{d},$self->{n});
        push(@chrnums,$chr);
    }

    my $chars = join("",@chrnums);  # 数列　 １行にまとめる  

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

    $self->{decoderes} = \@decnums;
}

sub decoderes {
    my $self = shift;

    return $self->{decoderes};    # 数列配列
}

1;

