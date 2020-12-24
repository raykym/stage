use strict;
use warnings;
use utf8;
use Test::More;
use MyTestXS;


my @array = ();
for my $i (1 .. 100) {
    push(@array,$i);
}

subtest 'return value' => sub {

    my $res = MyTestXS::increment2(\@array);
    my @tmp = @{$res};
    # とりあえず成功する処理を書いたので意味はないテストです。
    is( $tmp[0] , 1 , 'response ARRAY' );

};

done_testing;
