use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../..";
use Robot::Soldier;

subtest 'no_args' => sub {
   my $obj = Robot::Soldier->new;
   isa_ok $obj, 'Robot::Soldier';
};

subtest '$str is null' => sub {
    my $str = '';
    my $obj = Robot::Soldier->new($str);
    isa_ok $obj, 'Robot::Soldier';
};

subtest '$str' => sub {
    my $str = 'hogehoge';
    my $obj = Robot::Soldier->new($str);
    isa_ok $obj, 'Robot::Soldier';
};

done_testing;
