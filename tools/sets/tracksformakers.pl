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
			performer_id => undef,
		}
	);
	my $R = Ryzan->new();

	my ( $okazu, $schema ) = GSAC::Common::getokazu();
	$schema->storage->debug( 1 );

	use Data::Dumper;

	# 	$okazu->TrackTagMess->standard_search( $c->{tags} );
	my ( $mess_cloud_rs ) = $schema->resultset( 'Track' )->search_rs(
		{
			performer_id => $c->{performer_id}
		}
	);

	my @rows = $mess_cloud_rs->get_column( 'id' )->all();
	for ( @rows ) {
		$R->hreftocsv( $c->{performer_id}, {trackid => $_} );
	}
	$R->close_fh();
}
