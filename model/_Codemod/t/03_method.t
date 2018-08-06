#t/03_method.t

use strict;
use warnings;
use utf8;
use feature 'say';
use Test::More;
#use lib '/home/debian/perlwork/work/model/Codemod';
use lib '../lib';
#use lib '/home/debian/perlwork/work/model/Primechk/lib';  # for SPVM
use Codemod;
use Data::Dumper;
use Encode;

# method TEST SAMPLE

my $str = "あいうえおかきくけこさしすせそ";
my $obj = Codemod->new($str);

subtest 'string method' => sub {

       $obj->string;  # print $str
    my $string = join("",@{$obj->string});
       $string = decode_utf8($string);
    is $string , $str;
};

subtest 'ordcode method' => sub {
       $obj->ordcode;
    my $codestr = $obj->ordcoderes;
    is $codestr , '525271675252716952527171525271735252717552527176525271785252718052527182525271845252718652527188525271905252719852527110042';

 #   say "res: $codestr";
         
};

my $ordcoderes = $obj->ordcoderes;   # エンコード出力 ($obj)

my $obj2 = Codemod->decnew($ordcoderes);   # デコード入力 ($obj2)

subtest 'code method' => sub {
    my $code = join("",@{$obj2->code});  # デコード側コンストラクターの入力
       $code = decode_utf8($code);  # 比較のためにdecode
    my $ordcode = join("",@{$obj->{ordcode}});  # エンコード側の配列から取得
    is $code , $ordcode;
};

subtest 'chrcode method' => sub {
        $obj2->chrcode;
     my $string = $obj2->chrcoderes;   # decodeされた平文
     is $string , $str;
     say $string;
};

my $str2 = << "EOL";
!"#$%&'()=~|{}[]<>_
EOL

my $obj3 = Codemod->new($str2);
   $obj3->ordcode;
my $ordcode2 = $obj3->ordcoderes;

my $obj4 = Codemod->decnew($ordcode2);

subtest 'char test' => sub {

   my $code = join("",@{$obj4->code});
      $code = decode_utf8($code);
   my $ordcode = join("",@{$obj3->{ordcode}});
   is $code , $ordcode;
};

done_testing;
