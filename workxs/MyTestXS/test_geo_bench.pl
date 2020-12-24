#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature ':5.13';

use ExtUtils::testlib;
use MyTestXS;
use Math::Trig qw( great_circle_distance rad2deg deg2rad pi );

use Benchmark qw( timethese cmpthese ) ;
my $r = timethese( -5, {
    a => sub{  

	     my $lat1 = rand(90);
	     my $lng1 = rand(180);
	     my $lat2 = rand(90);
	     my $lng2 = rand(180);

             my $res = MyTestXS::geoDirection($lat1,$lng1,$lat2,$lng2);  
    
         },

    b => sub{

	     my $lat1 = rand(90);
	     my $lng1 = rand(180);
	     my $lat2 = rand(90);
	     my $lng2 = rand(180);

    my $Y = cos ($lng2 * pi / 180) * sin($lat2 * pi / 180 - $lat1 * pi / 180);

    my $X = cos ($lng1 * pi / 180) * sin($lng2 * pi / 180 ) - sin($lng1 * pi /180) * cos($lng2 * pi / 180 ) * cos($lat2 * pi / 180 - $lat1 * pi / 180);

    my $dirE0 = 180 * atan2($Y,$X) / pi;
    if ($dirE0 < 0 ) {
        $dirE0 = $dirE0 + 360;
       }
    my $dirN0 = ($dirE0 + 90) % 360;
    
         },
} );
cmpthese $r;
