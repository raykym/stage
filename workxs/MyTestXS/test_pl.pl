#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature ':5.13';

use ExtUtils::testlib;
use MyTestXS;

$|=0;

my @array;

for my $i ( 1 .. 100000) {
    push(@array , $i);
}

#print "100 + 2 = " . MyTestXS::increment2(\@array) . "\n";
#my $res = MyTestXS::increment2(\@array);
my $res = [];
for my $i (@array) {
    my $num = $i * $i; 
    push(@{$res},$num);
}

say $_ for @$res;


