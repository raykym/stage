#t/02_new.t

use strict;
use warnings;
use Test::More;
#use lib '..';
use lib '../lib';
use Myapps::Privkeymake;

subtest 'no_args' => sub {
   my $obj = Myapps::Privkeymake->new;
   isa_ok $obj, 'Myapps::Privkeymake';
};

done_testing;
