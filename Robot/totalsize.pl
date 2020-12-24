#!/usr/bin/env perl
#

use strict;
use warnings;
use utf8;
use feature ':5.13';

binmode STDOUT , ':utf8';

use Devel::Size qw/ size total_size /;

use FindBin;
use lib "$FindBin::Bin/..";
use Robot::Soldier;
use Robot::Bow;
use Robot::Cavalry;
use Robot::Spear;
use Robot::Medic;

my @robots;
push(@robots , Robot::Soldier->new);
push(@robots , Robot::Bow->new);
push(@robots , Robot::Cavalry->new);
push(@robots , Robot::Spear->new);
push(@robots , Robot::Medic->new);

my $total = total_size(\@robots);
my $soldier = total_size(\$robots[0]);
my $bow = total_size(\$robots[1]);
my $cavalry = total_size(\$robots[2]);
my $spear = total_size(\$robots[3]);
my $medic = total_size(\$robots[4]);

say "total size: $total byte";
say "Soldier: $soldier byte";
say "Bow: $bow byte";
say "Cavalry: $cavalry byte";
say "Spear: $spear byte";
say "Medic: $medic byte";

