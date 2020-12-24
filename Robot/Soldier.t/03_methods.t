# 03_methods.t

use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../..";

use feature ':5.13';
use Robot::Soldier;

subtest 'methods exist' => sub {
    my $obj = Robot::Soldier->new;

    can_ok($obj , qw / new init power attackrange durable /);
};

# include Robot::Base class method
subtest 'return value' => sub {
    my $obj = Robot::Soldier->new;

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


subtest 'attack method test' => sub {
    my $obj = Robot::Soldier->new;
    $obj->setposition(5,5);

    my @robots = ();
    push(@robots , Robot::Soldier->new);
    $robots[0]->setposition(4,5);

    my $result = $obj->attack(@robots);
    my @tmp = @{$result};
    @robots = @{$tmp[0]};

    like($result , '/ARRAY/' , "attack method in attackrange");

    if ($tmp[1]->{damage} != 0) {
        ok($robots[0]->life < 10 , "attack damage check");
    } else {
        ok($robots[0]->life == 10 , "attack success bat no damage");
    }

    # 16体のユニットを配置して、、攻撃されないことを確認する
    @robots = ();

    #  my @pointlist = rengeoutlist($obj->agility);
    # 5,5を基準として、攻撃範囲外を取得する
    my  @pointlist = ( [3 , 3] , [4 , 3] , [5 , 3] , [6 , 3] , [7 , 3] ,
	               [3 , 4] , [7 , 4] , [3 , 5] , [7 , 5] , [3 , 6] , [7 , 6] ,
		       [3 , 7] , [4 , 7] , [5 , 7] , [6 , 7] , [7 , 7] );

    my $cnt = 0;
    for my $i (@pointlist){
        push(@robots , Robot::Soldier->new);
	my @po = @{$i};
	#	print "$po[0] $po[1]\n";
        $robots[$cnt]->setposition($po[0] , $po[1]);
	$cnt++;
    }

    $result = $obj->attack(@robots);
    @tmp = @{$result};
    @robots = @{$tmp[0]};

    my @aggligate;
    for my $k ( 0 .. 15 ) {
	if ($robots[$k]->life == 10 ) {
            push(@aggligate , "ok");
        }
    }

    ok( $#aggligate == 15 , "attack out range check" );

};


subtest 'move method test' => sub {
    my $obj = Robot::Soldier->new;
    $obj->setposition(5,5);
    # 1マスしか進まないから、レンジの外に出る処理はテストがない。# 

    my @robots = ();

    my $res = $obj->move(@robots);
   
    like($res , '/HASH/' , "move method return check");

    push(@robots , Robot::Soldier->new);
    push(@robots , Robot::Soldier->new);
    push(@robots , Robot::Soldier->new);
    push(@robots , Robot::Soldier->new);

    $obj->setposition(5,5);
    $robots[0]->setposition(7,7);  # target
    $robots[1]->setposition(9,1);
    $robots[2]->setposition(1,1);
    $robots[3]->setposition(1,9);

      $res = $obj->move(@robots);
      #  say "loc_x $res->{loc_x} loc_y $res->{loc_y}";

      ok((($res->{loc_x} >= 5) && ($res->{loc_y} >= 5)) , "move method check 1");

    $obj->setposition(5,5);
    $robots[0]->setposition(3,3);  # target
    $robots[1]->setposition(9,9);
    $robots[2]->setposition(1,9);
    $robots[3]->setposition(9,1);

      $res = $obj->move(@robots);
      #say "loc_x $res->{loc_y} loc_y $res->{loc_y}";

      ok((($res->{loc_x} <= 5) && ($res->{loc_y} <= 5)) , "move method check 2");

    $obj->setposition(5,5);
    $robots[0]->setposition(7,3);  # target
    $robots[1]->setposition(9,9);
    $robots[2]->setposition(1,1);
    $robots[3]->setposition(1,9);

      $res = $obj->move(@robots);
      #say "loc_x $res->{loc_x} loc_y $res->{loc_y}";

      ok((($res->{loc_x} >= 5) && ($res->{loc_y} <= 5)) , "move method check 3");

    $obj->setposition(5,5);
    $robots[0]->setposition(3,7);  # target
    $robots[1]->setposition(9,9);
    $robots[2]->setposition(1,1);
    $robots[3]->setposition(9,1);

      $res = $obj->move(@robots);
      #say "loc_x $res->{loc_x} loc_y $res->{loc_y}";

      ok((($res->{loc_x} <= 5) && ($res->{loc_y} >= 5)) , "move method check 4");

    $obj->setposition(5,5);
    $robots[0]->setposition(7,7);  # target
    $robots[1]->setposition(6,5);
    $robots[2]->setposition(6,6);
    $robots[3]->setposition(5,6);

      $res = $obj->move(@robots);
      #say "loc_x $res->{loc_x} loc_y $res->{loc_y}";

      ok(defined($res->{instep}) , "move method check stepback");

};

done_testing;
