package GSA3::Okazu;
our $VERSION = 0.01;
use 5.006;
use Moose;
use Ase2::Mess;
use namespace::autoclean;
extends 'Ase2::Okazu' => {-version => 0.01};
use Encode;
use GSA3::Title;
use GSA3::Mess::Tag;
use GSA3::Okazu::Path::URL;
use GSA3::Okazu::Path::Local;
use Ase2::Okazu::Store::Local;
with qw/
  Ase2::Okazu::Method::Install
  /;

#Gemba
has 'Track'             => ( is => 'rw', );
has 'Album'             => ( is => 'rw', );
has 'TitleObj'          => ( is => 'rw', );
has 'TrackTagMessCloud' => ( is => 'rw', );
has 'TrackTagMess'      => ( is => 'rw', );
has 'OkazuToTrack'      => ( is => 'rw', );

#remarks
has 'AlbumRemarkMessDef'   => ( is => 'rw', );
has 'AlbumRemarkMessCloud' => ( is => 'rw', );
has 'AlbumRemarkMess'      => ( is => 'rw', );

#performers
has 'SharedPerformerMessDef' => ( is => 'rw', );
has 'TrackPerformerMess'     => ( is => 'rw', );
has 'AlbumPerformerMess'     => ( is => 'rw', );

#stores/paths/methods
has 'TrackStore' => ( is => 'rw', );
has 'URLPath'    => ( is => 'rw', );
has 'url_path_to_track_okazu' => (
	is => 'rw',

	# 	default => 'localhost:3000/static/okazu/'
);
has 'local_path' => ( is => 'rw', ); #Store::Local requirement, which is used by TrackStore

sub BUILD {

	my ( $self ) = @_;
	my @schema_array = qw(
	  AlbumRemarkMessDef
	  AlbumRemarkMessCloud
	  SharedPerformerMessDef
	  Track
	  Album
	  OkazuToTrack
	  TrackTagMessCloud
	);
	$self->init_db_shortcuts( \@schema_array );

	# 	die;
	$self->{AlbumRemarkMess} = Ase2::Mess->new(
		{
			%$self,
			'MessCloud' => $self->{AlbumRemarkMessCloud},
			'MessDef'   => $self->{AlbumRemarkMessDef},
		}
	);

	# 	die;
	#these two can share a cache
	$self->{AlbumPerformerMess} = Ase2::Mess->new(
		{
			force_lc => undef,
			%$self,
			cloud_to_foreign_key => '',
			cloud_to_def_key     => 'performer_id',
			'MessCloud'          => $self->{Album},
			'MessDef'            => $self->{SharedPerformerMessDef},
		}
	);

	# 	die;
	$self->{TrackPerformerMess} = Ase2::Mess->new(
		{
			force_lc => undef,
			%$self,
			cloud_to_foreign_key => 'album_id',
			cloud_to_def_key     => 'performer_id',
			'MessCloud'          => $self->{Track},
			'MessDef'            => $self->{SharedPerformerMessDef},
		}
	);

	#/cache
	$self->{TrackTagMess} = GSA3::Mess::Tag->new(
		{
			%$self,
			'ImplyResultset'     => $self->{OkazuTagImply},                       #CHAAAANGE THIS
			'cloud_to_def_name'  => 'tag_def',                                    #this could conceivably replace the following 2
			'Cache'              => Ase2::DBCache::Chi::init_generic( {%$self,} ),
			cloud_to_foreign_key => 'track_id',
			cloud_to_def_key     => 'tag_def_id',
			'MessCloud'          => $self->{TrackTagMessCloud},
			'MessDef'            => $self->{SharedTagMessDef},
		}
	);
	$self->{OkazuTagMess} = Ase2::Mess::AliasImply->new(
		{
			%$self,
			'ImplyResultset'     => $self->{OkazuTagImply},
			'cloud_to_def_name'  => 'tag_def',                                    #this could conceivably replace the following 2
			'Cache'              => Ase2::DBCache::Chi::init_generic( {%$self,} ),
			cloud_to_foreign_key => 'track_id',
			cloud_to_def_key     => 'tag_def_id',
			'MessCloud'          => $self->{TrackTagMessCloud},
			'MessDef'            => $self->{SharedTagMessDef},
		}
	);
	$self->{TitleObj} = GSA3::Title->new( {%$self} );
	$self->{TrackStore} = Ase2::Okazu::Store::Local->new(
		{
			PathObj => GSA3::Okazu::Path::Local->new( {%$self} ),                 #uses $self->{TitleObj}
		}
	);
	$self->{URLPath} = GSA3::Okazu::Path::URL->new(
		{
			%$self,
			host_path => $self->{'url_path_to_track_okazu'},
			protocol  => 'http://',
		}
	);

}

#this allows for more than one version of each file
sub installlocaltrack {

	my ( $self, $local_file_path, $track_id ) = @_;
	my $href = $self->prepare_local_file( $local_file_path );
	$self->{schema}->txn_do(
		sub {
			my $create_result = $self->create_okazu_record( $href );

			#new entry, so we have to create an okazu_to_track record before anything else.
			my $search_criteria = {
				okazu_id => $create_result->{row}->id,
				track_id => $track_id,
			}; #row id can be blank in some cases, which will be a byproduct of not {success} or {duplicate}
			if ( $create_result->{success} && defined( $track_id ) ) {

				#new record, dance parties forever
				$self->newokazutotrack( $search_criteria );
			} else {
				if ( $create_result->{duplicate} ) {
					my $okazu_to_track_row = $self->OkazuToTrack->find(
						$search_criteria,
						{
							key => 'okazu_id_2',
						}
					);
					if ( $okazu_to_track_row ) {
						if ( $okazu_to_track_row->file_number ) {

							#SAKAMOTO GA INAI PUTAIN
						} else {

							#old format record, update
							$okazu_to_track_row->update(
								{
									file_number => $self->newtrackfilenumber( $track_id ),
								}
							);
						}
					} else {

						#no record, make a new one
						$self->newokazutotrack( $search_criteria );
					}
				} else {
					die "track id: $track_id";
				}

				#refreshing old okazu
			}

			#store file will now know what to call the file as a result of the row
			$self->{TrackStore}->store_file( $local_file_path, $create_result->{row}, ) or die "Failed to store file";
			return ( $create_result->{row}, $create_result, );
		}
	);

}

sub newtrackfilenumber {

	my ( $self, $track_id ) = @_;
	my $file_number = $self->OkazuToTrack->search( {track_id => $track_id} )->get_column( 'file_number' )->max();
	if ( $file_number ) {
		$file_number++;
	} else {
		$file_number = 1;
	}
	return $file_number;

}

sub newokazutotrack {

	my ( $self, $row_data ) = @_;
	my $file_number = $self->newtrackfilenumber( $row_data->{track_id} );
	$row_data->{file_number} = $file_number;
	return $self->OkazuToTrack->create( $row_data );

}

=head2 track

=cut

sub fulltrack {

}
__PACKAGE__->meta->make_immutable;
1;
