package Robot::Cavalry;

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
       $self->{speed} = 7;
       $self->{defence} = 2;
       $self->{strength} = 3;
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

# override
sub move {
        my ($self,@robots) = @_;
        # Cavalreは移動範囲に居た相手にダメージを与える
        #say "DEBUG: Cavalry::move";
        my $roboinfo_move = $self->SUPER::move(@robots);

        my @plist;
        # 動いていない場合を除いて      
        if ($roboinfo_move->{direct} != 4){
             @plist = check_position($self,$roboinfo_move);
        }

        for my $point (@plist){
                my @po = @{$point};
            for my $r (@robots){
                if (($po[0] == $r->loc_x) && ($po[1] == $r->loc_y)) {
                    $roboinfo_move->{Cavalry_attack} = 4;
                    $roboinfo_move->{damage_name} = $r->name;
                    $r->life($roboinfo_move->{Cavalry_attack});  #減算処理
		    #  my $tmp = $r->name;
		    #say "DEBUG: $tmp damaged";
                }
            } # $r      
        } # point
        $roboinfo_move->{robots} = \@robots;   #反映用

        return $roboinfo_move;

        sub check_position {
            my ($self,$roboinfo_move) = @_;
            my @plist;
            my $count = $roboinfo_move->{count};
            my $direct = $roboinfo_move->{direct};

            # 移動と逆向きに配列の添字を取得する
            for (my $i=1; $i<=$count; $i++){
                if ($direct == 0) {
                    my $x = $self->loc_x + $i;
                    my $y = $self->loc_y + $i;
                    push(@plist, [$x,$y]);
                } elsif ($direct == 1) {
                    my $x = $self->loc_x;
                    my $y = $self->loc_y + $i;
                    push(@plist, [$x,$y]);
                } elsif ($direct == 2) {
                    my $x = $self->loc_x - $i;
                    my $y = $self->loc_y + $i;
                    push(@plist, [$x,$y]);
                } elsif ($direct == 3) {
                    my $x = $self->loc_x + $i;
                    my $y = $self->loc_y;
                    push(@plist, [$x,$y]);
                } elsif ($direct == 5) {
                    my $x = $self->loc_x - $i;
                    my $y = $self->loc_y;
                    push(@plist, [$x,$y]);
                } elsif ($direct == 6) {
                    my $x = $self->loc_x + $i;
                    my $y = $self->loc_y - $i;
                    push(@plist, [$x,$y]);
                } elsif ($direct == 7) {
                    my $x = $self->loc_x;
                    my $y = $self->loc_y - $i;
                    push(@plist, [$x,$y]);
                } elsif ($direct == 8) {
                    my $x = $self->loc_x - $i;
                    my $y = $self->loc_y - $i;
                    push(@plist, [$x,$y]);
                }
            } # for
            # @point = ( [$x,$y] , [$x , $y] ,,, );
            return @plist;
        } # sub
}

1;
