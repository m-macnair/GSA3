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

#remove $unwanted tracks from a track list
main();

sub main {
	my $c = Ryza::CombinedCLI::standard_config(
		{
			file    => undef,
			tags    => undef,
			maxvote => undef,
			minvote => undef,
			unvoted => undef,
		}
	);
	my @bad_tags = split( " ", $c->{tags} );
	my $R        = Ryzan->new();

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

	my $filtered;
	my $searchparams = {
		'-and' => [
			"me.id" => $tracks,
		]
	};
	my $ors;
	push( @{$ors}, {"tag_def.name" => \@bad_tags} );
	if ( $c->{unvoted} ) {
		push( @{$ors}, {"me.avg_vote" => {'!=' => undef}} );
	} else {

		my $nulls = {"me.avg_vote" => undef};

		#this is inverted since we're getting the EXCLUSION LIST
		if ( $c->{maxvote} ) {
			push(
				@{$ors},
				{
					"me.avg_vote" => {'>=' => $c->{maxvote}}
				}
			);
		}

		if ( $c->{minvote} ) {

			push(
				@{$ors},
				{
					"me.avg_vote" => {'<=' => $c->{minvote}}
				}
			);
		}
		push( @{$ors}, $nulls );
	}

	my $badtrackrs = $schema->resultset( 'Track' )->search(
		{
			%{$searchparams}, '-or' => $ors || [],
		},
		{
			prefetch => {track_tag_mess_clouds => 'tag_def'}
		}
	);

	my $badtracks;
	for ( $badtrackrs->get_column( 'me.id' )->all() ) {
		$badtracks->{int( $_ )} = 1;
	}
	for ( @$tracks ) {
		$R->hreftocsv( "filtered.csv", {trackid => $_} ) unless $badtracks->{int( $_ )};
	}
	print Dumper( $badtracks );
}
