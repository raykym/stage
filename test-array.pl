#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

my @array = ( 1, 1, 2, 3, 4, 4, 5, 6, 7, 7, 8, 9, 10);
my %hash;

#my @new = grep $hash{$_}++ ,@array ;  # 重複抽出
my @new = grep !$hash{$_}++ ,@array ;  # 重複排除

for my $i (@new) {
    say $i ;
}
