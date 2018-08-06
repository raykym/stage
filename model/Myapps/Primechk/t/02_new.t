#t/02_new.t

use strict;
use warnings;
use Test::More;
#use lib '..';
use lib '../lib';
use Myapps::Primechk;

subtest 'no_args' => sub {
   my $obj = Myapps::Primechk->new;
   isa_ok $obj, 'Myapps::Primechk';
};

subtest '$str is null' => sub {
    my $str = '';
    my $obj = Myapps::Primechk->new($str);
    isa_ok $obj, 'Myapps::Primechk';
};

my $str = '65535';
subtest "input $str" => sub {
    my $obj = Myapps::Primechk->new($str);
    isa_ok $obj, 'Myapps::Primechk';
};

   $str = '98989898989898989898';
subtest "over 15 length" => sub {
    my $obj = Myapps::Primechk->new($str);
    isa_ok $obj, 'Myapps::Primechk';
};

done_testing;
