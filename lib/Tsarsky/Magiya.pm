package Tsarsky::Magiya;

use 5.022;
use warnings;

use JSON::XS;
use utf8;


sub json {
	my $class = shift;
	state $json = JSON::XS->new->utf8;
	return $json->latin1;
}


sub zavernut {
	my $class = shift;
	my $perl = shift;
	#$perl = ['asd' => 123];
	#use Data::Dumper;
	my $text = $class->json->encode($perl);
	return $text;
}

sub razvernut {
	my $class = shift;
	my $text = shift;
	return eval {Tsarsky::Magiya->json->decode($text)};
}

1;
