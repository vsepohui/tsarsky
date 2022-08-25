package Tsarsky::Controller::Static;

use 5.022;
use warnings;

use base 'Tsarsky::Controller';


sub gramota {
	my $self = shift;
	
	state $text;
	unless ($text) {
		my $dir = $self->magiya->dir;
		open my $fh, '<:encoding(UTF-8)', $dir . '/ГРАМОТА';
		my @t = map {sub {my $s = $_[0]; $s =~ s/\s+$//; return $s;}->($_)}  <$fh>;
		$t[0] = "<h1>$t[0]</h1>"; # KING
		$text = join "\n", @t; 
		
		close $fh;
	}
	
	return $self->render(gramota => $text);
}

sub komanda {
	my $self = shift;
	return $self->render;
}


sub bibingo {
	my $self = shift;
	return $self->render;
}


sub bogovor {
	my $self = shift;
	return $self->render;
}

1;
