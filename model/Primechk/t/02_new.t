#t/02_new.t

use strict;
use warnings;
use Test::More;
#use lib '..';
use lib '../lib/Primechk';
use Primechk;

subtest 'no_args' => sub {
   my $obj = Primechk->new;
   isa_ok $obj, 'Primechk';
};

subtest '$str is null' => sub {
    my $str = '';
    my $obj = Primechk->new($str);
    isa_ok $obj, 'Primechk';
};

my $str = '65535';
subtest "input $str" => sub {
    my $obj = Primechk->new($str);
    isa_ok $obj, 'Primechk';
};

   $str = '98989898989898989898';
subtest "over 15 length" => sub {
    my $obj = Primechk->new($str);
    isa_ok $obj, 'Primechk';
};

done_testing;
