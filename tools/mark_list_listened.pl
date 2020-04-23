use strict;
use warnings;
use Ryza::CSV;
use Ryza::CombinedCLI;
use GSAC::Common;

use File::Copy;
main();

sub main {
	my $c = Ryza::CombinedCLI::standard_config(
		{
			file => undef
		}
	);

	my ( $okazu, $schema ) = GSAC::Common::getokazu();
	$schema->storage->debug( 0 );
	my $idtrack;
	GSAC::Common::listtotrackaction(
		$c->{file},
		$okazu, $schema,
		sub {
			my ( $path, $row ) = @_;

			$okazu->TrackTagMess->bulk_add_cloud_2(
				{
					id        => $row->get_column( 'id' ),
					def_arref => [qw/ listened /],
					no_txn    => undef,
					blind     => 1,
				}
			);
		}
	);
}
