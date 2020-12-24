#t/03_arglist.t
  
use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../..";
use Robot::Base;

my $str = 'aaa@bbb.com';
my $obj = Robot::Base->new($str);

subtest 'arglist check' => sub {

   my $res = $obj->arglist;
   my @get = @{$res};
   is $get[0],'aaa@bbb.com';
};

done_testing;
