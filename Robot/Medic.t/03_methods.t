# 03_methods.t

use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../..";

use feature ':5.13';
use Robot::Medic;
use Robot::Soldier;

subtest 'methods exist' => sub {
    my $obj = Robot::Medic->new;

    can_ok($obj , qw / new init power attackrange durable cure/);
};

# include Robot::Base class method
subtest 'return value' => sub {
    my $obj = Robot::Medic->new;

    my $res = $obj->roboinfo;
    #print "$res¥n";
    like( $res , '/HASH/' , "roboinfo method" );

       $res = $obj->setposition(5,5);
    ok(!defined($res) ,"setposition return");       

       $res = $obj->loc_x;
    ok($res == 5 ,"loc_x method");

       $res = $obj->loc_y;
    ok($res == 5 , "loc_y method");

};


subtest 'cure method test' => sub {
    my $obj = Robot::Medic->new;
    $obj->setposition(5,5);

    my @robots = ();
    push(@robots , Robot::Soldier->new);  # Medicは不可
    $robots[0]->setposition(4,5);
    $robots[0]->life(7); #はじめにダメージを設定しておく

    my $result = $obj->cure(@robots);
    my @tmp = @{$result};
    @robots = @{$tmp[0]};

    like($result , '/ARRAY/' , "cure method in curerange");

    if (defined $tmp[1]->{heal}) { 
        ok($robots[0]->life > 3 , "cure heal check");
    } 
       @robots = ();
    push(@robots , Robot::Soldier->new);  # Medicは不可
    $robots[0]->setposition(4,5);
    $robots[0]->life(5); #limitを超える

       $result = $obj->cure(@robots);
       @tmp = @{$result};
    @robots = @{$tmp[0]};

    if (defined $tmp[1]->{heal}) { 
        ok($robots[0]->life >= 8 , "cure success bat limit heal");
    }
       @robots = ();
    push(@robots , Robot::Soldier->new);  # Medicは不可
    $robots[0]->setposition(4,5);

       $result = $obj->cure(@robots);
       @tmp = @{$result};
    @robots = @{$tmp[0]};

    if (!defined $tmp[1]->{heal}) { 
        ok($robots[0]->life == 10 , "no cure operation");
    }

    @robots = ();

    #  my @pointlist = rengeoutlist($obj->agility);
    # 5,5を基準として、施術範囲外を取得する
    my  @pointlist = ( [3 , 3] , [4 , 3] , [5 , 3] , [6 , 3] , [7 , 3] ,
                       [3 , 4] , [7 , 4] , [3 , 5] , [7 , 5] , [3 , 6] , [7 , 6] ,
                       [3 , 7] , [4 , 7] , [5 , 7] , [6 , 7] , [7 , 7] );

    my $cnt = 0;
    for my $i (@pointlist){
        push(@robots , Robot::Medic->new);
	my @po = @{$i};
	#	print "$po[0] $po[1]\n";
        $robots[$cnt]->setposition($po[0] , $po[1]);
        $robots[$cnt]->life(5);
	$cnt++;
    }

    $result = $obj->cure(@robots);
    @tmp = @{$result};
    @robots = @{$tmp[0]};

    my @aggligate;
    for my $k ( 0 .. $#pointlist ) {
	if ($robots[$k]->life == 5 ) {   # 誰も回復させていない
            push(@aggligate , "ok");
        }
    }

    ok( $#aggligate == $#pointlist , "cure out range check" );

};

# Medicのmovemethodは行動規定が違うのでテストも変化する 
# ユニットのlifeが少ないユニットへ近づくが、
# 居ない場合は最寄りのユニットへ近づく
subtest 'move method test' => sub {
    my $obj = Robot::Medic->new;
    $obj->setposition(5,5);

    my @robots = ();

    push(@robots , Robot::Medic->new);
    push(@robots , Robot::Medic->new);
    push(@robots , Robot::Medic->new);
    push(@robots , Robot::Medic->new);

    my $res = $obj->move(@robots);
   
    like($res , '/HASH/' , "move method return check");

    $obj->setposition(5,5);
    $robots[0]->setposition(8,8);  # target
    $robots[1]->setposition(9,1);
    $robots[2]->setposition(1,1);
    $robots[3]->setposition(1,9);

      $res = $obj->move(@robots);
      #  say "loc_x $res->{loc_x} loc_y $res->{loc_y}";

      ok((($res->{loc_x} >= 5) && ($res->{loc_y} >= 5)) , "move method check 1");

    $obj->setposition(5,5);
    $robots[0]->setposition(2,2);  # target
    $robots[1]->setposition(9,9);
    $robots[2]->setposition(1,9);
    $robots[3]->setposition(9,1);

      $res = $obj->move(@robots);
      #say "loc_x $res->{loc_y} loc_y $res->{loc_y}";

      ok((($res->{loc_x} <= 5) && ($res->{loc_y} <= 5)) , "move method check 2");

    $obj->setposition(5,5);
    $robots[0]->setposition(8,2);  # target
    $robots[1]->setposition(9,9);
    $robots[2]->setposition(1,1);
    $robots[3]->setposition(1,9);

      $res = $obj->move(@robots);
      #say "loc_x $res->{loc_x} loc_y $res->{loc_y}";

      ok((($res->{loc_x} >= 5) && ($res->{loc_y} <= 5)) , "move method check 3");

    $obj->setposition(5,5);
    $robots[0]->setposition(2,8);  # target
    $robots[1]->setposition(9,9);
    $robots[2]->setposition(1,1);
    $robots[3]->setposition(9,1);

      $res = $obj->move(@robots);
      #say "loc_x $res->{loc_x} loc_y $res->{loc_y}";

      ok((($res->{loc_x} <= 5) && ($res->{loc_y} >= 5)) , "move method check 4");

    $obj->setposition(5,5);
    $robots[0]->setposition(7,7);  # これは関係していない 
    $robots[1]->setposition(6,5);
    $robots[2]->setposition(6,6);
    $robots[3]->setposition(5,6);

      $res = $obj->move(@robots);
      #say "loc_x $res->{loc_x} loc_y $res->{loc_y}";

      ok(defined($res->{instep}) , "move method check stepback");

     @robots = ();

    push(@robots , Robot::Medic->new);
    push(@robots , Robot::Medic->new);
    push(@robots , Robot::Medic->new);
    push(@robots , Robot::Medic->new);

    $obj->setposition(5,5);
    $robots[0]->setposition(9,9);  # target
    $robots[0]->life(7);
    $robots[1]->setposition(9,1);
    $robots[2]->setposition(1,1);
    $robots[3]->setposition(1,9);

      $res = $obj->move(@robots);

      ok((($res->{loc_x} >= 5) && ($res->{loc_y} >= 5)) , "medic move method check 1");
    
     @robots = ();

    push(@robots , Robot::Medic->new);
    push(@robots , Robot::Medic->new);
    push(@robots , Robot::Medic->new);
    push(@robots , Robot::Medic->new);

    $obj->setposition(5,5);
    $robots[0]->setposition(1,1);  # target
    $robots[0]->life(7);
    $robots[1]->setposition(9,9);
    $robots[2]->setposition(1,9);
    $robots[3]->setposition(9,1);

      $res = $obj->move(@robots);

      ok((($res->{loc_x} <= 5) && ($res->{loc_y} <= 5)) , "medic move method check 2");

     @robots = ();

    push(@robots , Robot::Medic->new);
    push(@robots , Robot::Medic->new);
    push(@robots , Robot::Medic->new);
    push(@robots , Robot::Medic->new);

    $obj->setposition(5,5);
    $robots[0]->setposition(9,1);  # target
    $robots[0]->life(7);
    $robots[1]->setposition(9,9);
    $robots[2]->setposition(1,1);
    $robots[3]->setposition(1,9);

      $res = $obj->move(@robots);

      ok((($res->{loc_x} >= 5) && ($res->{loc_y} <= 5)) , "medic move method check 3");

     @robots = ();

    push(@robots , Robot::Medic->new);
    push(@robots , Robot::Medic->new);
    push(@robots , Robot::Medic->new);
    push(@robots , Robot::Medic->new);

    $obj->setposition(5,5);
    $robots[0]->setposition(2,8);  # target
    $robots[0]->life(7);
    $robots[1]->setposition(9,9);
    $robots[2]->setposition(1,1);
    $robots[3]->setposition(9,1);

      $res = $obj->move(@robots);

      ok((($res->{loc_x} <= 5) && ($res->{loc_y} >= 5)) , "medic move method check 4");

};

done_testing;
