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
			my $remove;
			my $vote = $row->get_column( 'avg_vote' );

			if ( $idtrack->{$row->get_column( 'id' )} ) {
				$remove = 1;
			} elsif ( $vote && $vote <= 10 ) {
				$remove = 1;
			} else {
				my $remove = GSAC::Common::findtracktag( $schema, $row, 'remove' );
			}
			if ( $remove ) {
				print "Removing $path$/";
				unlink( $path );
			}
			$idtrack->{$row->get_column( 'id' )} = 1;
		}
	);

}
