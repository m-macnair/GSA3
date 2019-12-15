package GSA3::Okazu::Path;
our $VERSION = 0.01;
use 5.006;
use strict;
use warnings;
use Moose;
extends 'Ase2::Okazu::Path' => {-version => 0.01};
has 'TitleObj'   => ( is => 'rw', );
has 'Version'    => ( is => 'rw', default => 1 );
has 'Filenumber' => ( is => 'rw' );

sub okazutracktitle {

	my ( $self, $okazu_row ) = @_;
	my $okazu_to_track = $okazu_row->search_related( 'okazus_to_track' )->first();
	die "No matching okazus_to_track record " unless ( $okazu_to_track );
	my $track_row = $okazu_to_track->search_related( 'track' )->first();
	die "No matching track record (?!)" unless ( $track_row );
	my $filenumber = defined( $self->Filenumber ) ? $self->Filenumber : $okazu_to_track->file_number; # if the object file number is set, use that for preference
	my $result = $self->TitleObj->gettrackfilename( undef, undef, $track_row, $filenumber );

}

sub filenamesub {

	my ( $self, $okazu_row ) = @_;
	return sprintf( '%s.%s', $self->okazutracktitle( $okazu_row )->{name}, $self->ext_for( $okazu_row ), );

}

sub safenamesub {

	my ( $self, $okazu_row ) = @_;
	return sprintf( '%s.%s', $self->okazutracktitle( $okazu_row )->{name}, $self->ext_for( $okazu_row ), );

}

sub albumdirfor {

	my ( $self, $okazu_row ) = @_;
	my $album_row = $okazu_row->search_related( 'okazus_to_track' )->search_related( 'track' )->search_related( 'album' )->first();
	if ( $album_row ) {
		my $path = sprintf( '%s/%s', $self->TitleObj->getartistdirname( $album_row ) || '[GSA-No_artist]', $self->TitleObj->getalbumfilename( undef, $album_row ), );

		#warn $path;
		return $path;
	} else {
		die $okazu_row->id . " could not get an album row";
	}

}
1;
