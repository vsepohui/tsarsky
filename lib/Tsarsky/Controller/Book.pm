package Tsarsky::Controller::Book;

use 5.022;
use warnings;

use base 'Tsarsky::Controller';


sub book {
	my $self = shift;
	$self->render();
}

1;
