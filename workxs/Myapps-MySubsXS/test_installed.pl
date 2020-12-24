#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature ':5.13';

#use ExtUtils::testlib;
use Myapps::MySubsXS;

$|=0;

my @array;

for my $i ( 1 .. 100000) {
    push(@array , $i);
}

#print "100 + 2 = " . MyTestXS::increment2(\@array) . "\n";
my $res = Myapps::MySubsXS::increment2(\@array);

say $_ for @$res;

say "";

my $lat1 = 35.248481;
my $lng1 = 138.622106;

#my $lat2 = 35.250374;   # 北方向
#my $lng2 = 138.621494;

my $lat2 = 35.249051;
my $lng2 = 138.624756;

my $ret = Myapps::MySubsXS::geoDirection($lat1,$lng1,$lat2,$lng2);

say "ret: $ret";

