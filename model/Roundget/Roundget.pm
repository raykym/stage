package Roundget;

use strict;
use warnings;
use utf8;
use feature 'say';
use Encode;
#use Clone qw(clone);
use Data::Dumper;


# 配列を受けて、ループして返す
sub new {
  # Roundget->new(@hogehoge)
  my ($class,@arg) = @_;
  return bless {array => \@arg},$class;
}

my @tmp = ();

sub get {
   my $self = shift;
   my $array = $self->{array};
      @tmp = @$array if (! defined $tmp[0] );

   my $res = shift(@tmp);
       return $res;
}

sub array {
   my $self = shift;

   Dumper $self->{array} ;
}

1;
