#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

use lib '..';
use lib '../lib';
use Primechk;

my $obj = Primechk->new(1234511);

#   $obj->check;
#my $resc = $obj->result;
#   say "check: $resc";

   $obj->factor;

   say $obj->string;
say "-----factor";

   my $res = $obj->factorres;
   my @facts = @$res;

   for my $i (@$res){
       say $i;
   }

#say "-------divisor";

#  $obj->divisor;

#     $res = $obj->divisorres;

#  for my $i (@$res){
#     say $i;
#  }

#say "------ cnt";

#    $obj->factor;
#       $res = $obj->factorres;
#    my %hash;
#    my @nocomp = grep !$hash{$_}++ , @$res;
#    my @count;
#    my $cnt = 1;
#       for my $i (@nocomp){
#           my $c = 0;
#           for my $j (@$res){
#               if ($i == $j) {
#                   $c++;
#               }
#           }
#           push(@count,$c);
#       }

#       for my $i (@count){
#           $cnt = $cnt * ($i + 1);
#       }

#       say "cnt: $cnt";
