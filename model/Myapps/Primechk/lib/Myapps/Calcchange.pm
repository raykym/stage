# 計算書式書き換え  Primechkのサブルーチン
package Myapps::Calcchange;

# mod = first * 1 - second * div 形式   histryから次のmodを読んで置き換えると	
# ( xxx * e - ( xxx * e2 - yyy * d ) * d2 )  に置き換えられるのでこれが入力される
# この式を展開して
#  xxx * (e2+d2-e) - yyy * (d+d2) の形式に置き換える


use strict;
use warnings;
use utf8;
use feature 'say';

use bigint lib => 'GMP';
use Math::BigInt lib => 'GMP';

sub new {
    my ($class,@arg) = @_;

    # 数字を判別してbigintで表現する
    my @argb = map { Math::BigInt->new($_) if ( $_ =~ /^?+\d$/ ); } @arg ;

    return bless { 'string' => $arg[0], 'argarray' => \@arg } , $class;
}

sub string {
    my $self = shift;

    return $self->{string};
}

sub calcchange {
    my $self = shift;

    my $context = $self->{string};

    my @contarray = split / /, $context;

    # 先頭と末尾のカッコを外す
    shift(@contarray);
    pop(@contarray);

    # カッコの位置を取る
    my @pre;
    my @pos;
    for (my $i=0; $i < $#contarray; $i++ ){
        if ( $contarray[$i] eq '(' ) {
            push(@pre,$i);
        }
        if ( $contarray[$i] eq ')' ) {
            push(@pos,$i);
        }
    }

    # 前方フラグ マイナスフラグ処理  プラスの場合は何もしない
    my $preflag;
    if ($pre[0] < 1 ) {
       $preflag = '+'; # 先頭の場合＋と判定
    } else {
       $preflag = $contarray[$pre[0]-1];  # maybe -
    }

    # 掛け算処理
    my $posflag = $contarray[$pos[0]+1]; # maybe *
    my $posnum = $contarray[$pos[0]+2]; # number

    # contarrayをループ カッコ内を外側からフラグと倍数をかけて展開する
    for (my $i = $pre[0]+1; $i < $pos[0]-1; $i++ ){

        if (( $contarray[$i] eq '-') && ($preflag eq '-')) {
            $contarray[$i] = "+";
        } 

        if (( $contarray[$i] eq '*') && ($posflag eq '*')){
          #  $contarray[$i+1] = $contarray[$i+1] * $posnum;
            my $tmp = Math::BigInt->new($contarray[$i+1]);
            $contarray[$i+1] = $tmp->bmul($posnum);
        }
    }

    # カッコと後ろの掛け算を削除する
    my @pos_del = splice(@contarray,$pos[0],3); #後ろのカッコと符号、数字
    my @pre_del = splice(@contarray,$pre[0],1); # 前のカッコ
 #   say "pos_del: @pos_del";
 #   say "pre_del: @pre_del";

 #   say "contarray: @contarray";

    # 重複数値の抽出
     my @dropmark;
     for my $i (@contarray){
         push(@dropmark,$i) if ( $i =~ /^?\d$/);
     }
  #  say "dropmark: @dropmark";

    my @tmp_cont = sort { $a <=> $b } @dropmark;
    my %hash;
    my @dubl = grep $hash{$_}++ , @dropmark; 
       @dubl = sort { $b <=> $a } @dubl;
  #  say "dubl: @dubl";

    # 重複した数値の位置を取得 
    my @posi; # 位置情報配列  @contarrayのインデックス
    for (my $i = 0; $i < $#contarray; $i++) {

        if ( $contarray[$i] =~ /^?\d$/){
            if ( $contarray[$i] == $dubl[0] ) {
                push(@posi,$i);
            }
        }
    } # for

    # 符号の判別  @flagと@posiは2個づつ入る
    my @flag;
    for my $i (@posi){
        if ( $i < 1 ){
            push(@flag,'+');  # 先頭の数字は+
            next;
        } elsif ( $i > 1 ) {
            push(@flag, $contarray[$i-1]); # + or -
        }
    } # for

    my $add1 = $contarray[$posi[0] + 2]; # 前のかける数
    my $add2 = $contarray[$posi[1] + 2]; # 後ろのかける数

    if ( (( $flag[0] eq '+' )&&( $flag[1] eq '+' )) || (( $flag[0] eq '-' )&&( $flag[1] eq '-' )) ) {
        $contarray[$posi[0] + 2] = $add1 + $add2;
    } elsif (($flag[0] eq '+') && ($flag[1] eq '-' )){
        $contarray[$posi[0] + 2] = $add1 - $add2;
    } elsif (($flag[0] eq '-') && ($flag[1] eq '+' )){
        $contarray[$posi[0] + 2] = $add2 - $add1;
    }

    # 後ろの数とかける数,直前の符号を削除
    splice(@contarray,$posi[1]-1,4);

    my $context2 = join(" ",@contarray);

    $self->{calcchangeres} = "( $context2 )";   # 括弧を追加して次の処理で使えるようにする

    return;
}

sub calcchangeres {
    my $self = shift;

    return $self->{calcchangeres};
}


1;
