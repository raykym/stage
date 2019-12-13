#!/usr/bin/env perl
#
use strict;
use warnings;
use utf8;
use feature 'say';

use Myapps::Privkeymake;
use Mojo::JSON qw/ from_json to_json /;
use Time::HiRes qw/ time gettimeofday tv_interval /;
use EV;
use Mojo::IOLoop;
use AnyEvent;

# forkとIOLoop:
# 4core

my $proc = 0;
my $term = 1;
my @pids;
my $cvpid;
my @w;

    while ( $term ) {

	# watcherが複数あっても、1個がキャッチすれば全体を再チェックさせる。
       $cvpid = AnyEvent->condvar;

       for ( my $i=0; $i <= $proc ; $i++){

	if (defined $pids[$i]){
            next;
	}

        my $pid = fork();
	$pids[$i] = $pid;

        if ($pid) {
        # 親プロセス


        }  else {
        # child process

	  my $loopid = Mojo::IOLoop->timer( 0 => &baseloop() );

	    Mojo::IOLoop->start unless Mojo::IOLoop->is_running;

	    Mojo::IOLoop->remove($loopid);
	
	    exit;

        }


        } # for $i

     for my $i ( 0 .. 2 ){

	$w[$i] = AnyEvent->child ( pid => $pids[$i] , cb => sub {

	    undef $pids[$i];
            $cvpid->send;

	});
     }

        $cvpid->recv;

    } # while 

    exit;

sub baseloop {
	my $self = @_;

    my $cv = AE::cv;
    my $idle = AnyEvent->idle( cb => sub {


        my $t0 = [ gettimeofday ];

	my $key = Myapps::Privkeymake->new;
	   $key->make;

        my $interval = tv_interval($t0) * 1000;

        say "$interval msec";

	my $keyjson = to_json($key->result);

	say $keyjson;

	$cv->send;

    }); # $idle 

    # TERMシグナルを受けるとメッセージを記録して終了する
    my $sig = AnyEvent->signal(
          signal => 'TERM',
          cb => sub {

              say "GET signal TERM";

              $cv->send;  # timer loop stop 

             });

    $cv->recv;

    exit;

}
