#/t/04_methods_be.t

use strict;
use warnings;
use Test::More;
use Test::Exception;
use FindBin;
use lib "$FindBin::Bin/../..";
use Robot::Base;


subtest 'methods check' => sub {
    my $obj = Robot::Base->new;

    can_ok($obj , qw/ new arglist roboinfo strength agility defence speed loc_x loc_y name life attack move recovery emotion/);

};

subtest 'setter input range check' => sub {
    my $obj = Robot::Base->new;
    # 入力が10を超えるとdieする

    dies_ok(sub {$obj->setposition(10,10)} , 'setposition over range');
    dies_ok(sub {$obj->loc_x(10)} , 'loc_x over range');
    dies_ok(sub {$obj->loc_y(10)} , 'loc_y over range');

    # マイナスダメージの入力
    $obj->life(-1);
    is($obj->{life} , 10 , 'life point minus no damage');

    #マイナスの回復入力
    $obj->recovery(-2);
    is($obj->{life} , 10 , 'life recovery point minus no damage');

    #　回復上限は8
    $obj->life(4);
    $obj->recovery(4);
    is($obj->{life} , 8 , 'life recovery max 8'); 

    # emotionは0or1
    $obj->emotion(10);
    isnt($obj->emotion , 10 , 'emotion input false');

};

done_testing;
