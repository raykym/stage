#!/usr/bin/env perl
# Soldie,Bow,Cavalry,Spearの戦闘ユニットのみ

use strict;
use warnings;
use utf8;
use feature ':5.13';

use Clone qw/clone/;
use Data::Dumper;

use lib '/home/debian/perlwork/work/';
use Robot::Soldier;
use Robot::Bow;
use Robot::Cavalry;
use Robot::Spear;

#use Encode qw/encode_utf8 decode_utf8/;

binmode STDOUT , ':utf8';

$|=1;

# 10x10のフィールドを移動しながら戦う
# 3種類のモジュールがターン制で行動する

say "start";

my @robots = ();

push (@robots , Robot::Soldier->new);
push (@robots , Robot::Bow->new);
push (@robots , Robot::Cavalry->new);
push (@robots , Robot::Spear->new);

   $robots[0]->setposition(1,1);
   $robots[1]->setposition(1,9);
   $robots[2]->setposition(9,9);
   $robots[3]->setposition(9,1);

   for my $r (@robots){
       my $info = $r->roboinfo;
       for my $key (sort keys %{$info}){
           say "   $key: $info->{$key}";
       }
       say "";
   }


state @zerofield = ();
    if (!@zerofield){
        for my $i ( 0 .. 99 ){
            push(@zerofield,"_");
        }
    }


my $turn = 1;

say "start loop";

while($#robots!=0){

my $loopcount=0;
while ( $loopcount <= $#robots ){
    my $self = shift @robots;

    # 攻撃フェーズ
    my $result = $self->attack(@robots);
    my @tmp = @{$result}; #ハッシュの方がメモリの節約になるかな。。。
    @robots = @{$tmp[0]};

    say "damage: $tmp[1]->{roboinfo}->{name} に$tmp[1]->{damage} ダメージを与えた。残り $tmp[1]->{roboinfo}->{life}" if ( defined $tmp[1]->{damage});

    undef $result;
    undef @tmp;

    @robots = check_life(@robots);

    sub check_life {
	my @robots = @_;
        # lifeをチェックして除外する
        for (my $s = 0; $s <= $#robots ; $s++ ){
	        my $res = $robots[$s]->roboinfo;
            if ($res->{life} <= 0){
	        say "$res->{name} DEAD!";
                splice(@robots,$s,1);
	        last;  # 1度に1ユニットの想定
	    }
        }
	return @robots;
    } # sub

    # 自分以外が居ない場合移動は無し
    if (!@robots){
        push(@robots , $self);
	$loopcount++;
        next;
    }

    my $moveres = $self->move(@robots);
    # Cavalryの移動攻撃があった場合
    if (exists $moveres->{robots}){
	@robots = @{$moveres->{robots}};
    }
    push(@robots , $self);

    if (exists $moveres->{Cavalry_attack}){
        say "$moveres->{name} の移動攻撃　$moveres->{damage_name} に $moveres->{Cavalry_attack}ポイントのダメージ";
    }
    #
    @robots = check_life(@robots);
    
    # 自分以外が居ない場合移動は無し
    if (!@robots){
        push(@robots , $self);
	$loopcount++;
        next;
    }

    if (exists $moveres->{instep}) {
        say "$moveres->{name} は押し留められた";
    }

    #say "$moveres->{name} の移動 $moveres->{loc_x} : $moveres->{loc_y} direct: $moveres->{direct} count: $moveres->{count}";
    say "$moveres->{name} の移動 $moveres->{loc_x} : $moveres->{loc_y}";

    # 配置表示
    my @display = @zerofield; # コピー

    for my $r (@robots){
	    my $roboinfo = $r->roboinfo;  # getterで受けてから処理
	    #   print Dumper($roboinfo);
	    if ($roboinfo->{name} =~ /Soldier/){
	        $display["$roboinfo->{loc_y}$roboinfo->{loc_x}"] = "S";
            } elsif ($roboinfo->{name} =~ /Bow/){
	        $display["$roboinfo->{loc_y}$roboinfo->{loc_x}"] = "B";
	    } elsif ($roboinfo->{name} =~ /Cavalry/){
	        $display["$roboinfo->{loc_y}$roboinfo->{loc_x}"] = "C";
            } elsif ($roboinfo->{name} =~ /Spear/){
                $display["$roboinfo->{loc_y}$roboinfo->{loc_x}"] = "P";
	    } else {
	        $display["$roboinfo->{loc_y}$roboinfo->{loc_x}"] = "1";
	    }
    } # for

    if ($#display > 99) {
        die "error occered!  $#display";
    }

    if ($moveres->{direct} == 4){
	my $pname = $self->name;
        say "$pname は動かない";
    }

    if ($#display > 99){
        say "DEBUG: at display bigger : $#display";
    }

    my @dline=();
        for my $p (@display){
            push(@dline,"$p");
            if ($#dline == 9){
                print "@dline\n";
	        @dline = ();
	     }
        }
        say "";
    $loopcount++;
} # while loopcount

$loopcount=0;

say "ターン$turn 終了";

$turn++;

} # while $#robots == 0

# 最後に残ったユニットが
my $winner = $robots[0]->roboinfo;

say "$winner->{name} WIN!!!";

exit;

