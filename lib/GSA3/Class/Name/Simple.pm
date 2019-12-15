use strict;
use warnings;

package GSA3::Class::Name::Simple;
use Moo;
extends 'GSA3::Class::Name';

=head1
	Maximally simplified - T for track, A for Album, M for maker/artist, `.` for the separator, and integer value 
	To be used for local storage 
=cut

sub file_name {
	my ( $self, $p ) = @_;
	my $album_str = $self->album_str( $p );
	my $track_str = $self->track_str( $p );
	if ( wantarray ) {
		return ( "$album_str$track_str", $self->version_str( $p ) );
	} else {
		return "$album_str$track_str";
	}

}

sub dir_name {
	my ( $self, $p ) = @_;
	my $album_str       = $self->album_str( $p );
	my $album_maker_str = $self->album_maker_str( $p );
	return "$album_maker_str$album_str";
}

sub album_maker_str {
	my ( $self, $p ) = @_;
	return sprintf( '[AM.%s]', $p->{arow}->{performer_id} );

}

sub track_maker_str {
	my ( $self, $p ) = @_;
	return sprintf( '[TM.%s]', $p->{mrow}->{id} );

}

sub track_str {
	my ( $self, $p ) = @_;

	return sprintf( '[%02d][T.%d]', $p->{trow}->{track_no}, $p->{trow}->{id} );
}

sub album_str {
	my ( $self, $p ) = @_;
	return sprintf( '[A.%s]', $p->{trow}->{album_id} );
}

sub version_str {
	my ( $self, $p ) = @_;
	if ( $p->{frow} ) {
		return sprintf( '[V.%s]', $p->{frow}->{version} );
	}
	return '[V.0]';
}

1;
