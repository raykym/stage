package Robot::Base;

use utf8;
use feature ':5.13';
use Carp qw/croak/;
binmode STDOUT , ':utf8';

sub new {
    my $proto = shift;
    my $class = ref $proto || $proto;
    my $self = {};
    bless $self , $class;

    $self->{arg} = \@_;

    $self->{life} = 10;
    $self->{strength} = 2;
    $self->{agility} = 1;
    $self->{defence} = 0;
    $self->{speed} = 1;
    $self->{loc}->{x} = 0;
    $self->{loc}->{y} = 0;

    my $num = int(rand(999));
    $self->{name} = "$class$num";

    my $tmp = int(rand(10));
    if ($tmp <= 5 ) {
        $self->{emotion} = 0; # negative
    } else {
        $self->{emotion} = 1;  # positive
    }

    return $self;
}

sub arglist {
    my $self = shift;

    return $self->{arg};
}

sub roboinfo {
    my $self = shift;

    my $tmp = { "life"      => $self->{life} ,
                "strength"  => $self->{strength} ,
                "agility"   => $self->{agility} ,
                "defence"   => $self->{defence} ,
                "speed"     => $self->{speed} ,
                "loc_x"     => $self->{loc}->{x} ,
                "loc_y"     => $self->{loc}->{y} ,
                "name"      => $self->{name},
    };

    return $tmp;
}

sub setposition {
    my ($self, $x , $y) = @_;

    $self->{loc}->{x} = $x;
    if ($self->{loc}->{x} >= 10) {
        croak "over range x max";
    } elsif ($self->{loc}->{x} < 0) {
        croak "over range x min";
    }

    $self->{loc}->{y} = $y;
    if ($self->{loc}->{y} >= 10) {
        croak "over range y max";
    } elsif ($self->{loc}->{y} < 0) {
        croak "over range y min";
    }

    return;
}

sub strength {
    my $self = shift;
    if (@_) {
        $self->{strength} = shift;
    }
    return $self->{strength};
}
sub agility {
    my $self = shift;
    if (@_) {
        $self->{agility} = shift;
    }
    return $self->{agility};
}
sub defence {
   my $self = shift;
   if (@_) {
       $self->{defence} = shift;
   }
   return $self->{defence};
}
sub speed {
    my $self = shift;
    if (@_) {
        $self->{speed} = shift;
    }
   return $self->{speed};
}
sub loc_x {
    my $self = shift;
    if (@_) {
        $self->{loc}->{x} = shift;
	if ($self->{loc}->{x} >= 10) {
            croak "out range loc_x max";
	}
	if ($self->{loc}->{x} < 0) {
            croak "out range loc_x min";
	}
    }
    return $self->{loc}->{x};
}
sub loc_y {
    my $self = shift;
    if (@_) {
        $self->{loc}->{y} = shift;
	if ($self->{loc}->{y} >= 10) {
            croak "out range loc_y max";
	}
	if ($self->{loc}->{y} < 0) {
            croak "out range loc_y min";
	}
    }
    return $self->{loc}->{y};
}
sub name {
    my $self = shift;
    if (@_) {
        $self->{name} = shift;
    }
    return $self->{name};
}
sub life {
    my $self = shift;
    my $dumage;
    if (@_) {
             $dumage = shift;
	     if ($dumage < 0 ) {
                 $dumage = 0;
	     }
        $self->{life} = $self->{life} - $dumage;
    }
    # マイナス判定(死亡) はここでは行わない
    return $self->{life};
}

# Medicの施術を受けた場合の処理
sub recovery {
    my $self = shift;
    my $recovery;
    if(@_) {
	    $recovery = shift;
	    if ($recovery < 0) {
		    $recovery = 0;
	    }
    }
    if ($recovery != 0) { # マイナスの場合上限値に引っかかるのでバイパス
        $self->{life} = $self->{life} + $recovery;
        if ($self->{life} > 8) {
            $self->{life} = 8;  #上限は8
        }
    }
    return $self->{life};
}

sub emotion {
    my $self = shift;
    if(@_) {
        if ($_[0] <= 1) {
            $self->{emotion} = $_[0];
        } # 0 or 1 以外はスルー 
    }
    return $self->{emotion}; # 0 or 1
}

# @robotsを受けて、判定を行う
# @robotsは自分以外に成っている
# 結果と@robotsを戻す
sub attack {
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
	    if ($r->name !~ /Medic/){
                push(@onrange,$r);
            }
        }
    } # for

    # 攻撃をするかしないかの判定処理を加える  感情パラメータを増やして反映させるか、行動判別処理を加えるか


    # 攻撃範囲にrobotが居た場合
    if (@onrange){
        my $target = int(rand($#onrange));
        my $damage = $self->power - int( $onrange[$target]->durable * rand(1) );
     #my $tinfo = $onrange[$target]->roboinfo;
        # 判定は@onrangeで実際の処理は@robots側のモジュールを処理する必要がある。
        for my $r (@robots){
            if ($r->name eq $onrange[$target]->name){
                  $r->life($damage);
                  $result->{roboinfo} = $r->roboinfo;
                  last;
            }
        }
        $result->{damage} = $damage;
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

sub move {
    my ($self,@robots) = @_;
    # moveの結果roboinfoを返す
    # directとcountを付け加える。
    # 戻りが発生した場合は、instepも付け加える。
     
    # Class別に得て、不得手を設定して、意図的に行動を選択させるか？

    # ターゲットの決定（大まかな方向を決める）
    my @targetlist;
    for my $r (@robots){

        my $point = abs($self->loc_x - $r->loc_x) + abs($self->loc_y - $r->loc_y);

        my @directrange = (); #毎回消す
        my $debug_say = "";
        if (($self->loc_x <= $r->loc_x) && ($self->loc_y <= $r->loc_y)) {
           push(@directrange , 5);
           push(@directrange , 7);
           push(@directrange , 8);
           $debug_say = "DEBUG: 相手が右下・・・";
        } elsif (($self->loc_x >= $r->loc_x) && ($self->loc_y >= $r->loc_y)) {
           push(@directrange , 0);
           push(@directrange , 1);
           push(@directrange , 3);
           $debug_say = "DEBUG: 相手が左上・・・";
        } elsif (($self->loc_x <= $r->loc_x) && ($self->loc_y >= $r->loc_y)) {
           push(@directrange , 1);
           push(@directrange , 2);
           push(@directrange , 5);
           $debug_say  = "DEBUG: 相手が右上・・・";
        } elsif (($self->loc_x >= $r->loc_x) && ($self->loc_y <= $r->loc_y)) {
           push(@directrange , 3);
           push(@directrange , 6);
           push(@directrange , 7);
           $debug_say = "DEBUG: 相手が左下・・・";
        }
           push(@directrange , 4);  # 共通で4を追

        my $tlist = { "point" => $point , "range" => \@directrange , "debug" => $debug_say };

        push (@targetlist,$tlist);
    } # for

    my $direct;
    if (@targetlist) {
            #複数居る場合、近い方を選ぶ
        my @targetlistsort = sort {$a->{point} <=> $b->{point}} @targetlist;

        my $target = shift @targetlistsort;   # 先頭を選択
        my @directrange = @{$target->{range}};
	#	say "DEBUG: point: $target->{point} $target->{debug}";

        my $slice = int(rand($#directrange));
           $direct = $directrange[$slice];

        undef $slice;
        undef @directrange;
        undef @targetlistsort;
        undef @targetlist;
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

	#	say "DEBUG: direct: $direct count: $count";
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
        } # while $loopflg 複数ステップバックする可能性を考

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
