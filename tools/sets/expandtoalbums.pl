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
use Data::Dumper;

use Ryza::CombinedCLI;
use GSAC::Common;

# get all the tracks in the albums that a list of tracks belong to
main();

sub main {
	my $c = Ryza::CombinedCLI::standard_config(
		{
			file => undef,
		}
	);
	my $R = Ryzan->new();

	my ( $okazu, $schema ) = GSAC::Common::getokazu();
	$schema->storage->debug( 1 );

	my $tracks;
	my $first;
	$R->suboncsv(
		$c->{file},
		sub {
			my ( $columns ) = @_;
			push( @{$tracks}, $columns->[0] ) if $first;
			$first = 1;
		}
	);

	my $albumrs = $schema->resultset( 'Track' )->search(
		{
			id => $tracks
		},
		{
			columns => [qw/album_id/]
		}
	);

	my $fulltrackrs = $schema->resultset( 'Track' )->search(
		{
			album_id => [ $albumrs->get_column( 'album_id' )->all() ]
		},
		{
			columns => [qw/id/]
		}
	);

	for ( $fulltrackrs->get_column( 'id' )->all() ) {
		$R->hreftocsv( 'fulltracks.csv', {id => $_} );
	}
}
