use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../..";
use Robot::Spear;

subtest 'no_args' => sub {
   my $obj = Robot::Spear->new;
   isa_ok $obj, 'Robot::Spear';
};

subtest '$str is null' => sub {
    my $str = '';
    my $obj = Robot::Spear->new($str);
    isa_ok $obj, 'Robot::Spear';
};

subtest '$str' => sub {
    my $str = 'hogehoge';
    my $obj = Robot::Spear->new($str);
    isa_ok $obj, 'Robot::Spear';
};

done_testing;
