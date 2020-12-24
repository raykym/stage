use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../..";
use Robot::Bow;

subtest 'no_args' => sub {
   my $obj = Robot::Bow->new;
   isa_ok $obj, 'Robot::Bow';
};

subtest '$str is null' => sub {
    my $str = '';
    my $obj = Robot::Bow->new($str);
    isa_ok $obj, 'Robot::Bow';
};

subtest '$str' => sub {
    my $str = 'hogehoge';
    my $obj = Robot::Bow->new($str);
    isa_ok $obj, 'Robot::Bow';
};

done_testing;
