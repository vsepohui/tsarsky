package Tsarsky;

use 5.022;
use warnings;
 
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
	my $self = shift;

	# Load configuration from config file
	my $config = $self->plugin('NotYAMLConfig');

	# Configure the application
	$self->secrets($config->{secrets});

	# Router
	my $r = $self->routes;

	# Normal route to controller
	$r->get('/')->to('welcome#welcome');
	$r->get('/popast')->to('popast#popast');
}

1;
