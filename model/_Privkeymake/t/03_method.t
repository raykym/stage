#t/03_method.t

use strict;
use warnings;
use feature 'say';
use Test::More;
#use lib '..';
use lib '../lib';
use Privkeymake;
use Data::Dumper;
use bigint lib => 'GMP';


my $obj = Privkeymake->new();

subtest 'string method' => sub {

       $obj->make; 
   my $res = $obj->result;
#    say Dumper %$res;
    say "d: $res->{d}";
    say "n: $res->{n}";
    is ( ref $res, 'HASH' , 'response check');
};

done_testing;
