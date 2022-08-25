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
	$self->sessions->cookie_name('pechy');
	$self->sessions->cookie_domain($config->{domain});
	$self->sessions->secure($config->{proto} eq 'https');
	$self->sessions->default_expiration(60*60*24*7);

	my $r = $self->routes;

	$r->get('/')->to('welcome#welcome');
	$r->any('/popast')->to('popast#popast');
	$r->get('/popast/popadesh')->to('popast#popadesh');
	$r->get('/samopisets')->to('samopisets#samopisets');
	
	$self->helper(
		'json' => sub {
			my $self = shift;
			return Tsarsky::Magiya->zavernut(shift);
		},
	);
}

1;
