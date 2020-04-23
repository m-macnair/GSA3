use strict;
use warnings;
use Ryza::CSV;
use Ryza::CombinedCLI;
use GSAC::Common;

#transfer a file lists's id values to a collection
use File::Copy;
main();

sub main {
	my $c = Ryza::CombinedCLI::standard_config(
		{
			file         => undef,
			collectionid => undef
		}
	);

	my ( $okazu, $schema ) = GSAC::Common::getokazu();
	$schema->storage->debug( 1 );
	my $collectionrow = $schema->resultset( 'TrackCollection' )->find( $c->{collectionid} );
	$schema->txn_do(
		sub {
			if ( $collectionrow ) {

				#de nada
			} else {
				die "Collection row [$c->{collectionid}] not found";
			}
			my $idtrack;
			GSAC::Common::listtotrackaction(
				$c->{file},
				$okazu, $schema,
				sub {
					my ( $path, $row ) = @_;
					$collectionrow->create_related(
						'track_collection_entries',
						{
							track_id => $row->get_column( 'id' )
						}
					);
				}
			);

			# 		die;
		}
	);

}
