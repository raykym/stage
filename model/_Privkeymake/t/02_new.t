#t/02_new.t

use strict;
use warnings;
use Test::More;
#use lib '..';
use lib '../lib';
use Privkeymake;

subtest 'no_args' => sub {
   my $obj = Privkeymake->new;
   isa_ok $obj, 'Privkeymake';
};

done_testing;
