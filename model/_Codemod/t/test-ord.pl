#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

use Codemod;
binmode STDIN,":utf8";
binmode STDOUT,":utf8";
binmode STDERR,":utf8";

my $str = << "EOL";
東京都特許許可局許長可
あいうえおかきくけこさしすせそ
アイウエオカキクケコサシスセソ
０１２３４５６７８９
EOL

# 行毎に分ける
my @page = split(/\n/,$str);
my @codepage;

say "start";
say for @page;

for my $i (@page){
    my $obj = Codemod->new($i);
       $obj->ordcode;
    my $numcode = $obj->ordcoderes;
    push(@codepage,$numcode);
}
say "codepage";
say for @codepage;

my @decpage;
for my $i (@codepage){
    my $obj = Codemod->decnew($i);
       $obj->chrcode;
    my $b64chrcode = $obj->chrcoderes;
    push(@decpage,$b64chrcode);
}

say "decode page";
say for @decpage;
