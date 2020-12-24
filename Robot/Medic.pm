package Robot::Medic;
use utf8;
use feature ':5.13';

use FindBin;
use lib "$FindBin::Bin/..";
use base 'Robot::Base';
use Carp qw/croak/;

binmode STDOUT , ':utf8';

sub new {
    my $proto = shift;
    my $class = ref $proto || $proto;
    my $self = $class->SUPER::new();
       $self->init();
    return $self;
}

sub init {
    my $self = shift;
    $self->{speed} = 2;
    $self->{agility} = 1;
    return;
}

sub power {
        my $self = shift;
        return $self->strength;
}

sub attackrange {
        my $self = shift;
        return $self->agility;
}

sub durable {
        my $self = shift;
        return $self->defence;
}

# オーバーライド 何もしない
sub attack {
    my $self = shift;
    my @robots = @_;

    my $result = {};
    my @tmp = ( \@robots , $result );

    return \@tmp;
}

sub cure {
    my ($self,@robots) = @_;

    my $xmin = $self->loc_x - $self->attackrange;
       if ($xmin < 0) {
           $xmin = 0;
       }
    my $xmax = $self->loc_x + $self->attackrange;
       if ($xmax > 9) {
           $xmax = 9
       }
    my $ymin = $self->loc_y - $self->attackrange;
       if ($ymin < 0) {
           $ymin = 0;
       }
    my $ymax = $self->loc_y + $self->attackrange;
       if ($ymax > 9) {
           $ymax = 9;
       }

    my $result = {};

    my @onrange = ();
    for my $r (@robots){
        if ((($xmin <= $r->loc_x) && ($xmax >= $r->loc_x)) && (($ymin <= $r->loc_y) && ($ymax >= $r->loc_y))){
            push(@onrange,$r);
        }
    } # for
    # lifeが減少しているユニットか？
    for (my $s=0;$s <= $#onrange; $s++) {
        if ($onrange[$s]->life >= 8) {
            splice(@onrange,$s,1);
	}
    }
    # 施術範囲にユニットが居た場合
    if (@onrange){
        my $target = int(rand($#onrange));
        my $heal = 4;
     #my $tinfo = $onrange[$target]->roboinfo;
        # 判定は@onrangeで実際の処理は@robots側のモジュールを処理する必要がある。
        for my $r (@robots){
            if ($r->name eq $onrange[$target]->name){
                  $r->recovery($heal);
                  $result->{roboinfo} = $r->roboinfo;
                  last;
            }
        }
        $result->{heal} = $heal;
        #undef $tinfo;
    }

    undef $xmin;
    undef $xmax;
    undef $ymin;
    undef $ymax;
    undef @onrange;

    # ハッシュに統一するべきだったか？
    my @tmp = (\@robots , $result );

    return \@tmp;
}

# オーバーライド
# lifeが少ないユニットが無い場合は近いユニットへ進む
sub move {
    my ($self,@robots) = @_;

    my @targetlist;
    my $roboinfo_move;
    my $tlist = {};

    if (!@robots) {
        croak "no list found robots";
    }

       @targetlist = sort {$a->life <=> $b->life} @robots;

    if ((@targetlist) && ($targetlist[0]->life >=8)) {
        # lifeが低いユニットが無い場合、継承したmove
        $roboinfo_move = $self->SUPER::move(@robots);

        return $roboinfo_move;

    } else {
        # lifeが少ないユニットの方向へ

        my @directrange = (); #毎回消す
        my $debug_say = "";
        if (($self->loc_x <= $targetlist[0]->loc_x) && ($self->loc_y <= $targetlist[0]->loc_y)) {
           push(@directrange , 5);
           push(@directrange , 7);
           push(@directrange , 8);
           $debug_say = "DEBUG: 相手が右下・・・";
        } elsif (($self->loc_x >= $targetlist[0]->loc_x) && ($self->loc_y >= $targetlist[0]->loc_y)) {
           push(@directrange , 0);
           push(@directrange , 1);
           push(@directrange , 3);
           $debug_say = "DEBUG: 相手が左上・・・";
        } elsif (($self->loc_x <= $targetlist[0]->loc_x) && ($self->loc_y >= $targetlist[0]->loc_y)) {
           push(@directrange , 1);
           push(@directrange , 2);
           push(@directrange , 5);
           $debug_say  = "DEBUG: 相手が右上・・・";
        } elsif (($self->loc_x >= $targetlist[0]->loc_x) && ($self->loc_y <= $targetlist[0]->loc_y)) {
           push(@directrange , 3);
           push(@directrange , 6);
           push(@directrange , 7);
           $debug_say = "DEBUG: 相手が左下・・・";
        }

        $tlist = { "minlife" => $targetlist[0]->life , "range" => \@directrange , "debug" => $debug_say };

    } # targetlist else

    my $direct;
    if (@targetlist) {

        my @directrange = @{$tlist->{range}};
        #       say "DEBUG: point: $target->{point} $target->{debug}";

        my $slice = int(rand($#directrange));
           $direct = $directrange[$slice];

        undef $slice;
        undef @directrange;
        undef @targetlist;
        undef $tlist;
    } else {
         $direct = int(rand(8));   #位置がかぶった場合乱数で決める 
    }

    my $count = int(rand($self->speed));
    if ($count == 0) {
            $count = 1;  # 最低限１は移動する
    }

    my $instep = 0; #ステップバックフラグ

    # 4は移動なしでスルー
    if ($direct != 4){

        #       say "DEBUG: direct: $direct count: $count";
        $count = direct_speed($self,$direct,$count); # 舞台の枠、位置の重複で止まった場合$countを変更している　移動攻撃の判定で利用する
        # 位置が被ったときの処理
        my $loopflg = 1; # 0でスルー
        while ($loopflg) {
            my $flg=0;
            for my $r (@robots){
                if (($self->loc_x == $r->loc_x) && ($self->loc_y == $r->loc_y)) {
                    $flg = 1;
                    last;
                }
            }

            if ($flg == 1) {
         #say "DEBUG: inverse section";
                # direct_speedに引数を使って逆処理を行わせる
                my $indirect;
                my $incount = 1; # ステップバック 向きが逆に設定されているので一歩だけ
                if ($direct == 0) {
                    $indirect = 8;
                } elsif ($direct == 1) {
                    $indirect = 7;
                } elsif ($direct == 2) {
                    $indirect = 6;
                } elsif ($direct == 3) {
                    $indirect = 5;
                } elsif ($direct == 5) {
                    $indirect = 3;
                } elsif ($direct == 6) {
                    $indirect = 2;
                } elsif ($direct == 7) {
                    $indirect = 1;
                } elsif ($direct == 8) {
                    $indirect = 0;
                }
            $count = direct_speed($self,$indirect,$incount);
            $instep = 1; # ステップバックフラグ
            $count = $count - 1; #ステップバックを引く
            }
            # flgが0のままならwhile ループを抜ける
            if ($flg == 0) {
                $loopflg = 0;
            }
        } # while $loopflg 複数ステップバックする可能性を

       sub direct_speed {
            my ($self,$direct,$count) = @_;
           # 方角と進むカウントから座標を割り出して、盤上に収まるように調整する・

           if ($direct == 0) {
               if (($self->loc_y - $count) < 0) {
                   # x,yで少ないほうが$countの代わりになる
                   $count = $self->loc_y < $self->loc_x ? $self->loc_y : $self->loc_x;
               } elsif (($self->loc_x - $count) < 0) {
                   $count = $self->loc_y < $self->loc_x ? $self->loc_y : $self->loc_x;
               }

               my $yc = $self->loc_y - $count;
               $self->loc_y($yc);

               my $xc = $self->loc_x - $count;
               $self->loc_x($xc);

           } elsif ($direct == 1) {
                   if (($self->loc_y - $count) < 0) {
                       $self->loc_y(0);
                   } else {
                       my $yc = $self->loc_y - $count;
                       $self->loc_y($yc);
                   }
           } elsif ($direct == 2) {
               if (($self->loc_y - $count) < 0) {
                   $count = $self->loc_y < (9 - $self->loc_x) ? $self->loc_y : (9 - $self->loc_x);
               } elsif (($self->loc_x + $count) > 9) {
                   $count = $self->loc_y < (9 - $self->loc_x) ? $self->loc_y : (9 - $self->loc_x);
               }
                       my $yc = $self->loc_y - $count;
                       $self->loc_y($yc);

                       my $xc = $self->loc_x + $count;
                       $self->loc_x($xc);

           } elsif ($direct == 3) {
                   if (($self->loc_x - $count) < 0) {
                      $self->loc_x(0);
                   } else {
                      my $xc = $self->loc_x - $count;
                      $self->loc_x($xc);
                   }
           } elsif ($direct == 5) {
                   if (($self->loc_x + $count) > 9) {
                       $self->loc_x(9);
                   } else {
                       my $xc = $self->loc_x + $count;
                       $self->loc_x($xc);
                   }

           } elsif ($direct == 6) {
               if (($self->loc_y + $count) > 9) {
                   $count = (9 - $self->loc_y) < $self->loc_x ? (9 - $self->loc_y) : $self->loc_x;
               } elsif (($self->loc_x - $count) < 0) {
                   $count = $self->loc_y < $self->loc_x ? $self->loc_y : $self->loc_x;
               }

                      my $xc = $self->loc_x - $count;
                      $self->loc_x($xc);

                      my $yc = $self->loc_y + $count;
                      $self->loc_y($yc);

           } elsif ($direct == 7) {
                   if (($self->loc_y + $count) > 9) {
                       $self->loc_y(9);
                   } else {
                       my $yc = $self->loc_y + $count;
                       $self->loc_y($yc);
                   }
           } elsif ($direct == 8) {
               if (($self->loc_y + $count) > 9) {
                   $count = (9 - $self->loc_y) < (9 - $self->loc_x) ? (9 - $self->loc_y) : (9 - $self->loc_x);
               } elsif (($self->loc_x + $count) > 9) {
                   $count = (9 - $self->loc_y) < (9 - $self->loc_x) ? (9 - $self->loc_y) : (9 - $self->loc_x);
               }

                       my $xc = $self->loc_x + $count;
                       $self->loc_x($xc);

                       my $yc = $self->loc_y + $count;
                       $self->loc_y($yc);
           }
           return $count;
        } # sub

    } # if direct

    my $res = $self->roboinfo;
    $res->{direct} = $direct;
    $res->{count} = $count;
    if ($instep == 1) {
        $res->{instep} = "stepback";
    }
    return $res;
}

1;
