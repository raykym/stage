package Robot::Bow;
use utf8;
use feature ':5.13';

use FindBin;
use lib "$FindBin::Bin/..";
use base 'Robot::Base';

binmode STDOUT , ':utf8';

sub new {
    my $proto = shift;
    my $class = ref $proto || $proto;
    my $self = $class->SUPER::new();
       $self->init();
    return $self;
}

sub init {
    my $self = shift;
    $self->{speed} = 2;
    $self->{agility} = 3;
    return;
}

sub power {
        my $self = shift;
        return $self->strength;
}

sub attackrange {
        my $self = shift;
        return $self->agility;
}

sub durable {
        my $self = shift;
        return $self->defence;
}

1;
