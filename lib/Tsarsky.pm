package Tsarsky;

use 5.022;
use warnings;
 
use Mojo::Base 'Mojolicious';

use Tsarsky::Magiya;
use utf8;


sub startup {
	my $self = shift;

	my $config = $self->plugin('Config');
	#die $config;

	$self->secrets($config->{secrets});

	my $r = $self->routes;

	$r->get('/')->to('welcome#welcome');
	$r->any('/popast')->to('popast#popast');
	$r->get('/samopisets')->to('samopisets#samopisets');
	
	$self->helper(
		'json' => sub {
			my $self = shift;
			return Tsarsky::Magiya->zavernut(shift);
		},
	);
}

1;
