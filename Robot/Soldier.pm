package Robot::Soldier;

use utf8;
use feature ':5.13';

use FindBin;
use lib "$FindBin::Bin/..";
use base "Robot::Base";

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
    $self->{defence} = 3;
    return;
}

# 攻撃力
sub power {
        my $self = shift;
        return $self->strength;
}

# 攻撃範囲
sub attackrange {
        my $self = shift;
        return $self->agility;
}

# 攻撃耐久性 
sub durable {
        my $self = shift;
        return $self->defence;
}

1;
