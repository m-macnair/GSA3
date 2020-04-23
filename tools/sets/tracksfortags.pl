use strict;

package Ryzan;
use base qw/
  Ryza::SimpleClass
  Ryza::Core
  Ryza::Core::Lib::CSV
  /;
1;

package main;
use lib "../../lib";
use warnings;

use Ryza::CombinedCLI;
use GSAC::Common;

#do a tag search from command line to id list
use File::Copy;
main();

sub main {
	my $c = Ryza::CombinedCLI::standard_config(
		{
			tags => undef,
		}
	);
	my $R = Ryzan->new();

	my ( $okazu, $schema ) = GSAC::Common::getokazu();
	$schema->storage->debug( 1 );

	use Data::Dumper;

	$okazu->TrackTagMess->standard_search( $c->{tags} );
	my ( $mess_cloud_rs ) = $okazu->TrackTagMess->standard_search( $c->{tags} );
	my @tag_defs = $mess_cloud_rs->as_subselect_rs->get_column( 'track_id' )->all();
	for ( @tag_defs ) {
		$R->hreftocsv( "tagtracks.csv", {trackid => $_} );
	}
	$R->close_fh();
}
