package GSA3::Okazu::StoreLocal;
our $VERSION = 0.01;
use 5.006;
use Moose;
use Ase2::Mess;
use namespace::autoclean;
extends 'Ase2::Okazu::Store::Local' => {-version => 0.01};
has 'TitleObj' => ( is => 'rw', );

#always with okazu rows
sub parent_directory {

	my ( $self, $row ) = @_;
	my $album_row = $row->search_related( 'okazus_to_track' )->search_related( 'track' )->search_related( 'album' )->first();
	if ( $album_row ) {
		my $path = sprintf( '%s/%s/%s', $self->{local_path}, $self->TitleObj->get_artist_dirname( $album_row ) || 'GSA-No_artist', $self->TitleObj->get_album_filename( undef, $album_row ), );

		# 		warn $path;
		return $path;
	} else {
		die $row->id . " could not get an album row";
	}

}
1;
