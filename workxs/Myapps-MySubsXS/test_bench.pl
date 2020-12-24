#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature ':5.13';

use ExtUtils::testlib;
use Myapps::MySubsXS;

use Benchmark qw( timethese cmpthese ) ;
my $r = timethese( -5, {
    a => sub{  
             my @array = ();

             for my $i ( 1 .. 100000) {
                 push(@array , $i);
             }

             my $res = Myapps::MySubsXS::increment2(\@array);  
    
         },

    b => sub{
             my @array= ();

             for my $i ( 1 .. 100000) {
                 push(@array , $i);
             } 

             my $res = [];
             for my $i (@array) {
                  my $num = $i * $i;
                  push(@{$res},$num);
             }    
    
         },
} );
cmpthese $r;
