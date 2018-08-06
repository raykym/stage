#t/02_new.t

use strict;
#use warnings;
use Test::More;
#use lib '/home/debian/perlwork/work/model/Codemod';
use lib '../lib';
use Myapps::Codemod;

subtest 'no_args' => sub {
   my $obj = Myapps::Codemod->new;
   isa_ok $obj, 'Myapps::Codemod';
};

subtest '$str is null' => sub {
    my $str = '';
    my $obj = Myapps::Codemod->new($str);
    isa_ok $obj, 'Myapps::Codemod';

    is ( ref $obj->string , 'ARRAY', "maybe undef");   # undefのはず

};

my $str = 'いろはにほへとちりぬるを';
subtest "input $str" => sub {
    my $obj = Myapps::Codemod->new($str);
    isa_ok $obj, 'Myapps::Codemod';

    is (ref $obj->string , 'ARRAY', "string is ARRAY");
};

subtest 'no_args decnew' => sub {
   my $obj = Myapps::Codemod->decnew;
   isa_ok $obj, 'Myapps::Codemod';
};

subtest '$str is null decnew' => sub {
    my $str = '';
    my $obj = Myapps::Codemod->decnew($str);
    isa_ok $obj, 'Myapps::Codemod';

    is ( ref $obj->code , 'ARRAY', "maybe undef");   # undefのはず

};

my $code = '3242592839482323942822342';
subtest "input $str" => sub {
    my $obj = Myapps::Codemod->decnew($code);
    isa_ok $obj, 'Myapps::Codemod';

    is (ref $obj->code , 'ARRAY', "string is ARRAY");
};


done_testing;
