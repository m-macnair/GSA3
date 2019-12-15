package GSA3::Okazu::StoreLocal;
our $VERSION = 0.01;
use 5.006;
use Moose;
use Ase2::Mess;
use namespace::autoclean;
extends 'Ase2::Okazu::Store::Local' => {-version => 0.01};
has 'TitleObj' => ( is => 'rw', );

#always with okazu rows
sub parentdirectory {

	my ( $self, $row ) = @_;
	my $album_row = $row->search_related( 'okazus_to_track' )->search_related( 'track' )->search_related( 'album' )->first();
	if ( $album_row ) {
		my $path = sprintf( '%s/%s/%s', $self->{local_path}, $self->TitleObj->getartistdirname( $album_row ) || 'GSA-No_artist', $self->TitleObj->getalbumfilename( undef, $album_row ), );

		# 		warn $path;
		return $path;
	} else {
		die $row->id . " could not get an album row";
	}

}

sub filename {

	my ( $self, $okazu_row ) = @_;
	my $okazu_to_track = $okazu_row->search_related( 'okazus_to_track' )->first(); #can only ever be 1
	die "No matching okazus_to_track record " unless ( $okazu_to_track );
	my $track_row = $okazu_to_track->search_related( 'track' )->first();
	die "No matching track record (?!)" unless ( $track_row );
	my $result = $self->TitleObj->gettrackfilename( undef, undef, $track_row, $okazu_to_track->file_number );
	use Data::Dumper;

	# 	die Dumper($result);
	# 	warn "file name candidate : " . $result->{name};
	my $ext = $okazu_row->mime->extension;
	unless ( $ext ) {
		warn "$okazu_row->id Mime row does not have a defined extension" if ( $self->{warning} > 1 );
		return undef;
	}
	$ext =~ s/\.//g;
	return sprintf( '%s.%s', $result->{name}, lc( $ext ), );

}
1;
