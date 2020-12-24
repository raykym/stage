# 03_methods.t

use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../..";

use feature ':5.13';
use Robot::Bow;

subtest 'methods exist' => sub {
    my $obj = Robot::Bow->new;

    can_ok($obj , qw / new init power attackrange durable /);
};

# include Robot::Base class method
subtest 'return value' => sub {
    my $obj = Robot::Bow->new;

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
    my $obj = Robot::Bow->new;
    $obj->setposition(5,5);

    my @robots = ();
    push(@robots , Robot::Bow->new);
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

    @robots = ();

    #  my @pointlist = rengeoutlist($obj->agility);
    # 5,5を基準として、攻撃範囲外を取得する
    my  @pointlist = ( [1,1] , [2,1] , [3,1] , [4,1] , [5,1] , [6,1] , [7,1] , [8,1] , [9,1] ,
	               [1,2] , [9,2] , [1,3] , [9,3] , [1,4] , [9,4] , [1,5] , [9,5] , [1,6] , [9,6] , [1,7] , [9,7] ,
		       [1,8] , [9,8] ,
	               [1,9] , [2,9] , [3,9] , [4,9] , [5,9] , [6,9] , [7,9] , [8,9] , [9,9]
		      );

    my $cnt = 0;
    for my $i (@pointlist){
        push(@robots , Robot::Bow->new);
	my @po = @{$i};
	#	print "$po[0] $po[1]\n";
        $robots[$cnt]->setposition($po[0] , $po[1]);
	$cnt++;
    }

    $result = $obj->attack(@robots);
    @tmp = @{$result};
    @robots = @{$tmp[0]};

    my @aggligate;
    for my $k ( 0 .. $#pointlist ) {
	if ($robots[$k]->life == 10 ) {
            push(@aggligate , "ok");
        }
    }

    ok( $#aggligate == $#pointlist , "attack out range check" );

};


subtest 'move method test' => sub {
    my $obj = Robot::Bow->new;
    $obj->setposition(5,5);

    my @robots = ();

    my $res = $obj->move(@robots);
   
    like($res , '/HASH/' , "move method return check");

    push(@robots , Robot::Bow->new);
    push(@robots , Robot::Bow->new);
    push(@robots , Robot::Bow->new);
    push(@robots , Robot::Bow->new);

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

};

done_testing;
