use strict;
use warnings;

package GSA3::Class::Name;
use Math::Base36 ':all';
use Try::Tiny;
use Moo;
use utf8;

#get the [] element out of a track file title
sub stripstring {
	my ( $self, $string, $p ) = @_;
	my $stringstarter = $p->{stringstarter} || '\[3\-';
	my ( $indicator, $newstring ) = ( $string =~ m|($stringstarter)([^.-/]*)[.-]?| );
	if ( wantarray ) {
		return ( $newstring, $indicator );
	}
	return $newstring;
}

#turn to integer
sub defunk {
	my ( $self, $string ) = @_;
	die "No string provided" unless $string;
	my $return;
	try {
		$return = decode_base36( lc( $string ) );
	}
	catch {
		Carp::confess( "$string is invalid" );
	};
	return $return; #return !

}

#turn to 'memorable' string
sub funk {
	my ( $self, $int ) = @_;
	return lc( encode_base36( $int ) );
}

1;
