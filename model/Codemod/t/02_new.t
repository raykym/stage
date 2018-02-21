#t/02_new.t

use strict;
use warnings;
use Test::More;
use lib '/home/debian/perlwork/work/model/Codemod';
use Codemod;

subtest 'no_args' => sub {
   my $obj = Codemod->new;
   isa_ok $obj, 'Codemod';
};

subtest '$str is null' => sub {
    my $str = '';
    my $obj = Codemod->new($str);
    isa_ok $obj, 'Codemod';

    is ( ref $obj->string , 'ARRAY', "maybe undef");   # undefのはず

};

my $str = 'いろはにほへとちりぬるを';
subtest "input $str" => sub {
    my $obj = Codemod->new($str);
    isa_ok $obj, 'Codemod';

    is (ref $obj->string , 'ARRAY', "string is ARRAY");
};

subtest 'no_args decnew' => sub {
   my $obj = Codemod->decnew;
   isa_ok $obj, 'Codemod';
};

subtest '$str is null decnew' => sub {
    my $str = '';
    my $obj = Codemod->decnew($str);
    isa_ok $obj, 'Codemod';

    is ( ref $obj->code , 'ARRAY', "maybe undef");   # undefのはず

};

my $code = '3242592839482323942822342';
subtest "input $str" => sub {
    my $obj = Codemod->decnew($code);
    isa_ok $obj, 'Codemod';

    is (ref $obj->code , 'ARRAY', "string is ARRAY");
};


done_testing;
