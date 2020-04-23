use strict;
use warnings;
use Ryza::CSV;
use Ryza::CombinedCLI;
use GSAC::Common;

#remove any tracks in this collection that appear in other collections
use File::Copy;
main();

sub main {
	my $c = Ryza::CombinedCLI::standard_config(
		{
			collectionid => undef
		}
	);
	print "No collectionid provided" unless $c->{collectionid};
	my ( $okazu, $schema ) = GSAC::Common::getokazu();
	$schema->storage->debug( 1 );

	my $othercollectiontracks = [
		$schema->resultset( 'TrackCollectionEntry' )->search(
			{
				track_collection_id => {'!=' => $c->{collectionid}}
			}
		)->get_column( 'track_id' )->all()
	];

	use Data::Dumper;

	# 	print Dumper($othercollectiontracks);

	print $schema->resultset( 'TrackCollectionEntry' )->search(
		{
			track_collection_id => $c->{collectionid},
			track_id            => $othercollectiontracks
		}
	)->delete();
}

