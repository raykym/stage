use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../..";
use Robot::Cavalry;

subtest 'no_args' => sub {
   my $obj = Robot::Cavalry->new;
   isa_ok $obj, 'Robot::Cavalry';
};

subtest '$str is null' => sub {
    my $str = '';
    my $obj = Robot::Cavalry->new($str);
    isa_ok $obj, 'Robot::Cavalry';
};

subtest '$str' => sub {
    my $str = 'hogehoge';
    my $obj = Robot::Cavalry->new($str);
    isa_ok $obj, 'Robot::Cavalry';
};

done_testing;
