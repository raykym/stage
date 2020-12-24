use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../..";
use Robot::Medic;

subtest 'no_args' => sub {
   my $obj = Robot::Medic->new;
   isa_ok $obj, 'Robot::Medic';
};

subtest '$str is null' => sub {
    my $str = '';
    my $obj = Robot::Medic->new($str);
    isa_ok $obj, 'Robot::Medic';
};

subtest '$str' => sub {
    my $str = 'hogehoge';
    my $obj = Robot::Medic->new($str);
    isa_ok $obj, 'Robot::Medic';
};

done_testing;
