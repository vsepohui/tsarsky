package Tsarsky::Samopisets;

use 5.022;
use warnings;

use Tsarsky::Redis;
use Tsarsky::Magiya;

use Encode;
use utf8;

use Carp;


sub new {
	my $class = shift;
	my $samopisets = {};
	return bless $samopisets, $class;
}

sub redis {
	return Tsarsky::Redis->redis;
}

sub pishy {
	my $samopisets = shift;
	my %karma = (
		'ИП'		=> undef,
		#'ВРЕМЯ' 	=> undef,
		'ПРИЯТНЫЙ' 	=> undef,
		'ТИП' 		=> undef,
		'ДЕЛО' 		=> undef,
		@_,
	);
	

	confess 'НЕ УКАЗАН ИП' unless $karma{'ИП'};
	#confess 'НЕ УКАЗАНО ВРЕМЯ' unless $karma{'ВРЕМЯ'};
	$karma{'ВРЕМЯ'} = time();
	# confess 'НЕ УКАЗАН ПРИЯТНЫЙ' unless $karma->{'ПРИЯТНЫЙ'};
	confess 'НЕ УКАЗАН ТИП' unless $karma{'ТИП'};
	confess 'НЕ УКАЗАНО ДЕЛОы' unless $karma{'ДЕЛО'};

	
	my $text = Tsarsky::Magiya->zavernut(\%karma);
	Encode::encode_utf8($text);
	#Encode::encode
	
	$samopisets->redis->rpush(samopisets => $text);
	
	return;
}

sub day {
	my $samopisets = shift;
	my @data = $samopisets->redis->lrange('samopisets', 0, -1);
	#Encode::decode_utf8($d);
	return [map {Tsarsky::Magiya->razvernut($_)} @data];
}

1;
