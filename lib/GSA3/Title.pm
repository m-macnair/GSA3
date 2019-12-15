package GSA3::Title;
our $VERSION = 0.01;
use Moose;
use utf8;
use Encode;
use Math::Base36 ':all';
extends 'Ase2' => {-version => 0.01};
has 'Track'      => ( is => 'rw', );
has 'Album'      => ( is => 'rw', );
has 'warnings'   => ( is => 'rw', default => 1 );
has 'simplemode' => ( is => 'rw', default => 0 );
has 'Version'    => ( is => 'rw', default => 1 );

sub get_album_filename {

	my ( $self, $album_id, $album_row ) = @_;
	$album_row = $self->Album->find(
		{
			id => $album_id,
		}
	) unless $album_row;
	if ( $self->Version == 2 ) {
		return sprintf( '[2.%s]', $self->number_convert_to_1( $album_row->id ) );
	} else {
		return sprintf( '%s[2-%s]', $album_row->title, $self->number_convert_to_1( $album_row->id ), );
	}

}

sub number_convert_to_1 {

	my ( $self, $int ) = @_;
	return lc( encode_base36( $int ) );

}

sub number_convert_from_1 {

	my ( $self, $string ) = @_;
	return decode_base36( lc( $string ) );

}

sub get_artist_dirname {

	my ( $self, $album_row ) = @_;
	my $performer_row = $album_row->search_related( 'performer' )->first();
	unless ( $performer_row ) {
		warn "No performer for $album_row->id";
		return undef;
	}

	# 	warn $performer_row->name;
	if ( $self->Version == 2 ) {
		return sprintf( '[1.%s]', $self->number_convert_to_1( $performer_row->id ), );
	} else {
		return sprintf( '%s[1-%s]', $performer_row->name, $self->number_convert_to_1( $performer_row->id ), );
	}

}

sub get_track_filename {

	my ( $self, $album_id, $track_no, $track_row_tmp, $file_number ) = @_;
	if ( $self->warnings > 2 ) { warn "Get track filename"; }
	my ( $track_id, $gsa_track_id, $track_row ) = $self->track_id_for( $album_id, $track_no, $track_row_tmp );
	die "$album_id:$track_no track not found" unless ( $track_row );
	my $track;
	if ( $self->Version == 2 ) {
		$track = sprintf( '[%02d][%s.%s]', $track_row->track_no, $gsa_track_id, $file_number || 0 );
	} elsif ( $self->Version == 3 ) {
		$track = sprintf( '[%02d][%s.%s]%s', $track_row->track_no, $gsa_track_id, $file_number || 0, $track_row->safe_title || $track_id );
	} elsif ( $self->Version == 4 ) {

		# 		die "yes";
		$track = sprintf( '[2-%s][%02d][%s.%s][m-%s]%s', $self->number_convert_to_1( $track_row->album_id ), $track_row->track_no, $gsa_track_id, $file_number || 0, $track_row->performer_id, $track_row->safe_title || $track_id );
	} else {
		$track = sprintf( '[%02d]%s[%s.%s]', $track_row->track_no, $track_row->title, $gsa_track_id, $file_number || 0 );
	}
	if ( $self->warnings > 2 ) { warn "new file name : $track"; }
	return {
		name => $track,
		row  => $track_row,
	};

}

sub track_id_for {

	my ( $self, $album_id, $track_no, $track_row ) = @_;
	$track_row = $self->Track->find(
		{
			album_id => $album_id,
			track_no => $track_no,
		},
		{
			key => 'album_id_2',
		}
	) unless ( $track_row );
	die "no track found" unless ( $track_row );
	my $sprintstring;
	if ( $self->Version == 2 ) {
		$sprintstring = '3.%s';
	} else {
		$sprintstring = '3-%s';
	}
	return ( $track_row->id, sprintf( $sprintstring, $self->number_convert_to_1( $track_row->id ) ), $track_row );

}
1;
