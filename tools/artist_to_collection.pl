use strict;
use warnings;
use Ryza::CSV;
use Ryza::CombinedCLI;
use GSAC::Common;

#add all tracks by an artist to a collection, possibly making a new one
use File::Copy;
main();

sub main {
	my $c = Ryza::CombinedCLI::standard_config(
		{
			performer_id => undef,
			collectionid => undef
		}
	);
	my ( $okazu, $schema ) = GSAC::Common::getokazu();
	$schema->storage->debug( 1 );
	$schema->txn_do(
		sub {

			my $collectionrow = $schema->resultset( 'TrackCollection' )->find( $c->{collectionid} );
			my $artistrow     = $schema->resultset( 'SharedPerformerMessDef' )->find( $c->{performer_id} );
			unless ( $artistrow ) {
				die "performer [$c->performer_id] not found";
			}
			if ( $collectionrow ) {

				#de nada
			} else {

				$collectionrow = $schema->resultset( 'TrackCollection' )->create(
					{
						name    => $artistrow->get_column( 'safe_title' ),
						user_id => 1,
					}
				);
			}

			my $trackrs = $schema->resultset( 'Track' )->search(
				{
					performer_id => $c->{performer_id}
				}
			);

			while ( my $trackrow = $trackrs->next() ) {
				$collectionrow->create_related(
					'track_collection_entries',
					{
						track_id => $trackrow->get_column( 'id' )
					}
				);
			}

		}
	);
}

