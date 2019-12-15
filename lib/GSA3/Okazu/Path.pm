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

sub okazu_track_title {

	my ( $self, $okazu_row ) = @_;
	my $okazu_to_track = $okazu_row->search_related( 'okazus_to_track' )->first();
	die "No matching okazus_to_track record " unless ( $okazu_to_track );
	my $track_row = $okazu_to_track->search_related( 'track' )->first();
	die "No matching track record (?!)" unless ( $track_row );
	my $filenumber = defined( $self->Filenumber ) ? $self->Filenumber : $okazu_to_track->file_number; # if the object file number is set, use that for preference
	my $result = $self->TitleObj->get_track_filename( undef, undef, $track_row, $filenumber );

}

sub file_name_sub {

	my ( $self, $okazu_row ) = @_;
	return sprintf( '%s.%s', $self->okazu_track_title( $okazu_row )->{name}, $self->ext_for( $okazu_row ), );

}

sub safe_name_sub {

	my ( $self, $okazu_row ) = @_;
	return sprintf( '%s.%s', $self->okazu_track_title( $okazu_row )->{name}, $self->ext_for( $okazu_row ), );

}

sub album_dir_for {

	my ( $self, $okazu_row ) = @_;
	my $album_row = $okazu_row->search_related( 'okazus_to_track' )->search_related( 'track' )->search_related( 'album' )->first();
	if ( $album_row ) {
		my $path = sprintf( '%s/%s', $self->TitleObj->get_artist_dirname( $album_row ) || '[GSA-No_artist]', $self->TitleObj->get_album_filename( undef, $album_row ), );

		#warn $path;
		return $path;
	} else {
		die $okazu_row->id . " could not get an album row";
	}

}
1;
