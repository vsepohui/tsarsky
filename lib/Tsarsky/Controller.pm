package Tsarsky::Controller;

use 5.022;
use warnings;

use base 'Mojolicious::Controller';

use Tsarsky::Redis;
use Tsarsky::Magiya;
use Encode;
use utf8;


sub magiya {
	my $self = shift;
	my $magiya = Tsarsky::Magiya->new;
	return $magiya;
}

sub redis {
	my $self = shift;
	return Tsarsky::Redis->redis;
}

sub ip {
	my $self = shift;
	return (($self->tx->req->headers->{headers}->{'x-forwarded-for'}||[[]])->[0]->[0]) || $self->tx->remote_address;
}


sub nazad {
	my $self = shift;

	if (my $nazad = $self->param('nazad')) {
		return $self->redirect_to($nazad);
	}	

	my $key = 'nazad';
	if ($self->flash($key)) {
		$self->redirect_to('/');
	} else {
		$self->flash($key => 1);
		$self->redirect_to($self->req->headers->referrer // '/');
	}
}


sub oshybka {
	my $self = shift;
	my $text  = shift;
	$self->noty('ОШИБКА' => $text);
	return $self->nazad;
}


sub noty {
	my $self = shift;
	my ($type, $msg) = @_;
	my $noty = $self->flash('noty') || [];
	Encode::encode_utf8($type);
	Encode::encode_utf8($msg);
	push @$noty, [$type, $msg];
	
	#my $text = Tsarsky::Magiya->zavernut($noty);
	#die $text;
	$self->flash('noty' => $noty);
	$self->stash('noty' => $noty);
}

1;
