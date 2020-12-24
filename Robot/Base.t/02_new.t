#t/02_new.t
  
use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../..";
use Robot::Base;

subtest 'no_args' => sub {
   my $obj = Robot::Base->new;
   isa_ok $obj, 'Robot::Base';
};

subtest '$str is null' => sub {
    my $str = '';
    my $obj = Robot::Base->new($str);
    isa_ok $obj, 'Robot::Base';
};

subtest '$str' => sub {
    my $str = 'hogehoge';
    my $obj = Robot::Base->new($str);
    isa_ok $obj, 'Robot::Base';
};

done_testing;
