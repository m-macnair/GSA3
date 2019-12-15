use strict;
use warnings;

package GSA3::Class::Name::Simple;
use Moo;
extends 'GSA3::Class::Name';

=head1
	Maximally simplified - T for track, A for Album, M for maker/artist, `.` for the separator, and integer value 
	To be used for local storage 
=head3
	the fully qualified name on GSA storage which, if appended to a root path, will get the file if you also know the file extension
=cut

sub fullname {
	my ( $self, $p ) = @_;
	my $album_str       = $self->albumstr( $p );
	my $track_str       = $self->trackstr( $p );
	my $versionstr      = $self->versionstr( $p );
	my $album_maker_str = $self->albummakerstr( $p );

	return "$album_maker_str/$album_str/$track_str$versionstr.mp3";
}

sub filename {
	my ( $self, $p ) = @_;
	my $album_str = $self->albumstr( $p );
	my $track_str = $self->trackstr( $p );
	if ( wantarray ) {
		return ( "$album_str$track_str", $self->versionstr( $p ) );
	} else {
		return "$album_str$track_str";
	}

}

sub dirname {
	my ( $self, $p ) = @_;
	my $album_str       = $self->albumstr( $p );
	my $album_maker_str = $self->albummakerstr( $p );
	return "$album_maker_str$album_str";
}

sub albummakerstr {
	my ( $self, $p ) = @_;
	return sprintf( '[AM.%s]', $p->{arow}->{performer_id} );

}

sub trackmakerstr {
	my ( $self, $p ) = @_;
	return sprintf( '[TM.%s]', $p->{mrow}->{id} );

}

sub trackstr {
	my ( $self, $p ) = @_;

	return sprintf( '[%02d][T.%d]', $p->{trow}->{track_no}, $p->{trow}->{id} );
}

sub albumstr {
	my ( $self, $p ) = @_;
	return sprintf( '[A.%s]', $p->{trow}->{album_id} );
}

sub versionstr {
	my ( $self, $p ) = @_;
	if ( $p->{orow} ) {
		return sprintf( '[F.%s]', $p->{orow}->{file_number} );
	}
	return '[F.0]';
}

1;
