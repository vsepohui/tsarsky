package Tsarsky::Controller::Popast;

use 5.022;
use warnings;

use base 'Tsarsky::Controller';

use Tsarsky::Samopisets;
use Data::Validate::Email;
use utf8;

sub oshybka {
	my $self = shift;
	my $text  = shift;
	$self->stash(noty => [['ОШИБКА' => $text]]);
	return 1;
}


# This action will render a template
sub popast {
	my $self = shift;
	
	
	
	if ($self->req->method eq 'POST') {
		my $imya = $self->param('imya') or return $self->oshybka("ПРИЯТНЫЙ ИМЯ НЕ УКАЗАН");
		return $self->oshybka("ПРИЯТНЫЙ ИМЯ СЛИШКОМ МАЛ") if length $imya < 6;
		return $self->oshybka("ПРИЯТНЫЙ ИМЯ СЛИШКОМ ВЕЛИК") if length $imya > 60;
		
		my $latyn = $self->param('latyn') or return $self->oshybka("ПРИЯТНЫЙ ЛАТЫНЬ НЕ УКАЗАН");
		return $self->oshybka("ПРИЯТНЫЙ ЛАТЫНЬ СЛИШКОМ МАЛ") if length $latyn < 6;
		return $self->oshybka("ПРИЯТНЫЙ ЛАТЫНЬ СЛИШКОМ ВЕЛИК") if length $latyn > 60;
		
		my $pochta = $self->param('pochta') or return $self->oshybka("ПРИЯТНЫЙ ПОЧТА НЕ УКАЗАН");
		return $self->oshybka("ПРИЯТНЫЙ ПОЧТА СЛИШКА МАЛ") if length $pochta < 6;
		return $self->oshybka("ПРИЯТНЫЙ ПОЧТА СЛИШКОМ ВЕЛИК") if length $pochta > 600;
		return $self->oshybka('ПЛОХОЙ ПОЧТА') unless $self->magiya->proverka_pochty($pochta);
		
		my $pol = $self->param('pol') or return $self->oshybka("ПРИЯТНЫЙ ПОЛ НЕ УКАЗАН");
		return $self->oshybka('ЦАРСКИ СТРАЖА ЛОВИТЬ ХАКЕР') unless $pol ~~ [qw/М Ж/];


		my $priyatny = $self->param('priyatny') or return $self->oshybka("ПРИЯТНЫЙ ВОСПРОС НЕ ОТВЕТИН");
		my $razmer = $self->param('razmer') or return $self->oshybka("ПРИЯТНЫЙ РАЗМЕР НЕ УКАЗАН");
		my $secret = $self->param('secret') or return $self->oshybka("ПРИЯТНЫЙ СЕКРЕТ НЕ УКАЗАН");
		my $poyasneniya = $self->param('poyasneniya') or return $self->oshybka("ПРИЯТНЫЙ НЕ ПОЯСНИЛ ЗА СЕБЯ");
		return $self->oshybka('СЛИШКОМ МАЛО ПОЯСНИЛ') if length $poyasneniya <= 50;
		#die  $self->session('popast_kogda') ;
		return $self->oshybka('ЦАРСКИ СТРАЖА НЕ ПУСКАТЬ СКОРОХОДА') if ($self->session('popast_kogda') || time ()) + 60  > time();
		
		my $ip = $self->ip;
		my $k = "popast:limit:$ip";
		$self->redis->get($k);
		if ($k) {
			$self->oshybka('ЦАРСКИ ПОПАСТЬ ПО ОДНОМУ ИП МОЖНО ТОЛЬКО РАЗ В ЧАС');
		}
		$self->redis->setex($k, 60*60, 1);
		

		Tsarsky::Samopisets->pishy(
			'ИП' 	=> $self->ip,
			'ВРЕМЯ' => time(),
			#'ПРИЯТНЫЙ' => undef,
			'ТИП' 	=> 'ЦАРСКИ ПОПАСТЬ ХОТЕЛ',
			'ДЕЛО' 	=> {
				'ИМЯ'		=> $imya,
				'ЛАТЫНЬ'	=> $latyn,
				'ПОЧТА'		=> $pochta,
				'ПОЛ' 		=> $pol,
				'ПРИЯТНЫЙ?'	=> $priyatny,
				'РАЗМЕР'	=> $razmer,
				#'СЕКРЕТ'		=> $secret,
				'ПОЯСНЕНИЯ'	=> $poyasneniya,
			},
		);
	} else {
		$self->session('popast_kogda' => time());
	}
}


sub popadesh {
	my $self = shift;
	return $self->render;
}

1;
