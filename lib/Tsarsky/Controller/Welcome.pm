package Tsarsky::Controller::Welcome;

use 5.022;
use warnings;

use base 'Tsarsky::Controller';


sub welcome  {
	my $self = shift;
	$self->render();
}

1;
