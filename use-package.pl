#!/usr/bin/env perl
# test-package.plにきちんと各パラメータ　
# にアクセサーを用意して、処理する

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
use Robot::Medic;

#use Encode qw/encode_utf8 decode_utf8/;

binmode STDOUT , ':utf8';

$|=1;

# 10x10のフィールドを移動しながら戦う
# 3種類のモジュールがターン制で行動する

say "start";

my @robots = ();
my @field = (); #勝利判定用 Medic1を除外

push (@robots , Robot::Soldier->new);
push (@robots , Robot::Bow->new);
push (@robots , Robot::Cavalry->new);
push (@robots , Robot::Spear->new);
push (@robots , Robot::Medic->new);

# 初期配置
   $robots[0]->setposition(1,1);
   $robots[1]->setposition(1,9);
   $robots[2]->setposition(9,9);
   $robots[3]->setposition(9,1);
   $robots[4]->setposition(5,5);

   # パラメータ表示
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

   @field = @robots;

my $turn = 1;

say "start loop";

while($#field!=0){

my $loopcount=0;
while ( $loopcount <= $#robots ){
    my $self = shift @robots;

    # 攻撃 or 治療
    my $result = $self->attack(@robots);
    my @tmp = @{$result}; #ハッシュの方がメモリの節約になるかな。。。
       @robots = @{$tmp[0]};

    if ((!defined($tmp[1]->{damage})) && ($self->name =~ /Medic/)) {
	    #　治療系
        $result = $self->cure(@robots);

	my @tmp = @{$result};
	@robots = @{$tmp[0]};

	say "heal: $tmp[1]->{roboinfo}->{name} に$tmp[1]->{heal} を治療した。 現在 $tmp[1]->{roboinfo}->{life}" if (defined $tmp[1]->{heal});

        undef @tmp;

    } else {
	    # 攻撃系

        say "damage: $tmp[1]->{roboinfo}->{name} に$tmp[1]->{damage} ダメージを与えた。残り $tmp[1]->{roboinfo}->{life}" if ( defined $tmp[1]->{damage});

    } # else

    undef @tmp;
    undef $result;

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

    if ($moveres->{count} == 0) {
        if (exists $moveres->{instep}) {
            say "$moveres->{name} は押し留められた";
        } else {
            say "$moveres->{name}は動けなかった";
        }
    }

    #say "$moveres->{name} の移動 $moveres->{loc_x} : $moveres->{loc_y} direct: $moveres->{direct} count: $moveres->{count}";
    say "$moveres->{name} の移動 $moveres->{loc_x} : $moveres->{loc_y}";

    # 配置表示 ユニット毎の表示をやめて、ターンの最終段階のみを表示する
if ($loopcount == $#robots) {
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
	    } elsif ($roboinfo->{name} =~ /Medic/) {
		$display["$roboinfo->{loc_y}$roboinfo->{loc_x}"] = "M";
	    } else {
	        $display["$roboinfo->{loc_y}$roboinfo->{loc_x}"] = "1";
	    }
    } # for

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
} # loopcount == $#robots
        say "";
    $loopcount++;
} # while loopcount

$loopcount=0;
say "ターン$turn 終了";
say "-";
$turn++;

# @fieldからMedicを除外する
@field = @robots;
for (my $s=0; $s <= $#field; $s++) {
    if ($field[$s]->name =~ /Medic/) {
        splice(@field,$s,1);
    }
}

} # while $#field == 0

# 最後に残ったユニットが
my $winner = $field[0]->roboinfo;

say "$winner->{name} WIN!!!";

exit;

