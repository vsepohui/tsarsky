package Tsarsky::Magiya;

use 5.022;
use warnings;

use Data::Validate::Email qw(is_email);
use JSON::XS;
use utf8;


sub new {
	my $class = shift;
	state $magiya = bless {}, $class;
	return $magiya;
}

sub proverka_pochty {
	my $class = shift;
	my $pochta = shift;
	return is_email ($pochta);
}

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
