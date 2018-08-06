use strict;
use warnings;
use Test::More;
#use lib '..';
use lib '../lib';


subtest 'use chack' => sub {
     use_ok('Myapps::Calcchange');
};

use Myapps::Calcchange;

subtest 'no_args' => sub {
   my $obj = Myapps::Calcchange->new;
   isa_ok $obj, 'Myapps::Calcchange';
};

subtest '$str is null' => sub {
    my $str = '';
    my $obj = Myapps::Calcchange->new($str);
    isa_ok $obj, 'Myapps::Calcchange';
};

subtest '$str' => sub {
    my $str = '65535';
    my $obj = Myapps::Calcchange->new($str);
    isa_ok $obj, 'Myapps::Calcchange';
};

my $obj = Myapps::Calcchange->new("( 100 * 1 - ( 202 * 1 - 100 * 2 ) * 34 )");
my $obj2 = Myapps::Calcchange->new("( ( 202 * 1 - 100 * 2 ) * 34 - 100 * 1 )");

subtest 'method test' => sub {

   $obj->calcchange;
   $obj2->calcchange;

   is ( $obj->calcchangeres , '( 100 * 69 - 202 * 34 )', 'calc change test' );
   is ( $obj2->calcchangeres , '( 202 * 34 - 100 * 69 )', 'calc change test' );

};



done_testing;
