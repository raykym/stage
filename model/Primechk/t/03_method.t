#t/03_method.t

use strict;
use warnings;
use feature 'say';
use Test::More;
#use lib '..';
use lib '../lib/Primechk';
use Primechk;
use Data::Dumper;

# method TEST SAMPLE

my $str = '200';
my $obj = Primechk->new($str);
my $str2 = '211';
my $obj2 = Primechk->new($str2);

subtest 'string method' => sub {

       $obj->string;  # print $str
    is $obj->{string}, $str;
};

subtest 'false check & result' => sub {

   $obj->check;
   ok ! $obj->result, 'Not prim number.';
};

subtest 'true check & result' => sub {

      $obj2->check;
   ok $obj2->result, 'prime number.'; 
};

subtest 'false check SPVM & result' => sub {

   $obj->checkspvm;
   ok ! $obj->result, 'Not prim number.';
};

subtest 'true check SPVM & result' => sub {

      $obj2->checkspvm;
   ok $obj2->result, 'prime number.'; 
};

# 時間がかかる 
#my $obj5 = Primechk->new("19000000000000000001");
#subtest 'big num true check & result' => sub {

#      $obj5->check;
#   ok $obj5->result, 'prime number.'; 
#};

# 時間がかかるのでコメントしておく
#my $obj4 = Primechk->new(3000000077);
#
#subtest 'over long check SPVM & result' => sub {
#
#      $obj4->checkspvm;
#   ok $obj4->result, 'over long check'; 
#};

subtest 'factor check' => sub {

        $obj->factor;
     my $res = $obj->factorres;
     for my $i ( @$res){
         say $i;
     }

    is ( ref $obj->factorres , 'ARRAY' , 'return ARRAY factor' );

};

subtest 'divisor check' => sub {

       $obj->divisor;
    my $res = $obj->divisorres;
    for my $i ( @$res){
        say $i;
    }

    is ( ref $obj->divisorres , 'ARRAY' , 'return ARRAY divisor' );
    
};

subtest 'divisorspvm check' => sub {

       $obj->divisorspvm;
    my $res = $obj->divisorres;
    for my $i ( @$res){
        say $i;
    }

    is ( ref $obj->divisorres , 'ARRAY' , 'return ARRAY divisor' );
    
};

   $obj2 = Primechk->new(1071,1029);

subtest 'gcd check' => sub {

    $obj2->gcd;

    say $obj2->gcdres;

    print Dumper $obj2->gcdhistory;

    is $obj2->gcdres , 21 , 'get gcd';

    is ( ref $obj2->gcdhistory , 'ARRAY' , 'return ARRAY history' );

};

   my $obj3 = Primechk->new(1777,1999);

subtest 'axby1 check' => sub {

    $obj3->gcd; 
    $obj3->axby1;
    say $obj3->equation;

    is ( $obj3->equation , '( 1777 * 9 - 1999 * 8 )' , 'get text line') ;

};

   my $obj4 = Primechk->new(10000009247,10000009249);

subtest 'axby1 check' => sub {

    $obj4->gcd; 
    $obj4->axby1;
    say $obj4->equation;

    is ( $obj4->equation , '( 10000009247 * 5000004624 - 10000009249 * 5000004623 )' , 'get text line') ;

};



done_testing;
