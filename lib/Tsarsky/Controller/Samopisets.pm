package Tsarsky::Controller::Samopisets;

use 5.022;
use warnings;

use base 'Tsarsky::Controller';

use Tsarsky::Samopisets;


# This action will render a template
sub samopisets {
	my $self = shift;
	
	my $karma = Tsarsky::Samopisets->day();
	#use Data::Dumper;
	#die Dumper $karma;
	return $self->render(
		karma => $karma,
	);
}

1;
