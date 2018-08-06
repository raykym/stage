
use strict;
use Test::More;
use utf8;

use lib '../lib';

use Myapps::Rsacrypt;

subtest 'no_args' => sub {
   my $obj = Myapps::Rsacrypt->new;
   isa_ok $obj, 'Myapps::Rsacrypt';
};

subtest '$str is null' => sub {
    my $str = '';
    my $obj = Myapps::Rsacrypt->new($str);
    isa_ok $obj, 'Myapps::Rsacrypt';
};

subtest '$str is num' => sub {
    my $str= << "EOF";
455667788990102
6576878798701091228459
8384858678485911198,
EOF

    my $obj = Myapps::Rsacrypt->new($str);
    isa_ok $obj , 'Myapps::Rsacrypt';
    is ( ref $obj->{string} , 'ARRAY' , 'new input test');
};

subtest 'pubkey input' => sub {
    my $str= << "EOF";
455667788990102
6576878798701091228459
8384858678485911198,
EOF

    my $obj = Myapps::Rsacrypt->new($str);
    my $num = 123456789012345678901234567890123456789012345678990123456789012345678901234556789;  # randum num
       $obj->pubkey($num);
    my $res = $obj->pkey;
    is ( ref $res , 'HASH' ,' HASH response ');
    is ( ref $obj->string , 'ARRAY' , 'pubkey befor new input test');
};

subtest 'privkey input' => sub {
    my $str= << "EOF";
455667788990102
6576878798701091228459
8384858678485911198,
EOF

    my $obj = Myapps::Rsacrypt->new($str);
    my $d = 12345678901234567890123456789012345678901234567899;  #random num
    my $num = 123456789012345678901234567890123456789012345678990123456789012345678901234556789;  # random num
       $obj->privkey({d=>$d, n=>$num});
    my $res = $obj->vkey;
    is ( ref $res , 'HASH' ,' HASH response ');
    is ( ref $obj->string , 'ARRAY' , 'privkey befor new input test');
};


done_testing;
