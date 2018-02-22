#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use feature 'say';

use Digest::SHA3;

my $SHA3 = Digest::SHA3->new;
   $SHA3->add('test1@test.com');
my $hash = $SHA3->hexdigest();
say $hash;

