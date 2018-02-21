#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

# カッコを展開して式を整理する
# 1倍もあえて書く書式の使用
#my $context = "( 100 * 1 - ( 202 * 1 - 100 * 2 ) * 34 )";
my $context = "( ( 60 * 1 - 31 * 1 ) * 15 - 31 * 14 )";

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

    say "pre: $contarray[$pre[0]-1]";
    say "pos: $contarray[$pos[0]+1]";

    for (my $i = $pre[0]+1; $i < $pos[0]-1; $i++ ){
        # マイナスフラグ処理
        my $preflag = $contarray[$pre[0]-1];  # maybe -
        if (( $contarray[$i] eq '-') && ($preflag eq '-')) {
            $contarray[$i] = "+";  
        }

        # 掛け算処理
        my $posflag = $contarray[$pos[0]+1]; # maybe * 
        my $posnum = $contarray[$pos[0]+2]; # number

        if (( $contarray[$i] eq '*') && ($posflag eq '*')){
            $contarray[$i+1] = $contarray[$i+1] * $posnum; 
        }
    }

    # カッコと後ろの掛け算を削除する
    splice(@contarray,$pos[0],3); #後ろのカッコと符号、数字
    splice(@contarray,$pre[0],1); # 前のカッコ

 say "contarray: @contarray";

    # 重複数値の抽出 
     my @dropmark;
     for my $i (@contarray){
         push(@dropmark,$i) if ( $i =~ /^?\d$/); 
     }
 say "dropmark: @dropmark";
    my @tmp_cont = sort { $b <=> $a } @dropmark;
    my %hash;
    my @dubl = grep $hash{$_}++ , @dropmark; # 重複抽出 1個のはず
 say "dubl: @dubl";

    # 重複した数値の位置を取得
    my @posi;
    for (my $i = 0; $i < $#contarray; $i++) {
     
        if ( $contarray[$i] =~ /^?\d$/){
            if ( $contarray[$i] == $dubl[0] ) {
                push(@posi,$i);
            }
        }
    }

    # 符号の判別
    my $flag;
    for my $i (@posi){
        if ( $i < 1 ){
            next;
        } elsif ( $i > 1 ) {
            $flag = $contarray[$i-1] ; # + or -
        }
    } # for

    my $add1 = $contarray[$posi[0] + 2]; # 前のかける数
    my $add2 = $contarray[$posi[1] + 2]; # 後ろのかける数

    if ( $flag eq '+' ) {
        $contarray[$posi[0] + 2] = $add1 + $add2;
    } else {
        $contarray[$posi[0] + 2] = $add1 - $add2;
    }

    # 後ろの数とかける数,直前の符号を削除
    splice(@contarray,$posi[1]-1,4); 

my $context2 = join(" ", @contarray);

say $context2;
