#!/usr/bin/perl
use strict;
use warnings;
use lib "../../lib";
use Data::Dumper;
use File::Path;
require File::Copy;
require Ryza::CombinedCLI;
require Ryza::CSV;
require GSAC::Common;
use open qw/:std :utf8/;

#only works in 'flat' i.e. one folder for everything
main();

sub main {

	my $c = Ryza::CombinedCLI::standard_config(
		{
			root         => undef,
			path         => undef,
			collectionid => undef,
			out          => undef,
			flat         => undef,

		}
	);
	my $csv = Ryza::CSV->new();
	my ( $okazu, $schema ) = GSAC::Common::getokazu();

	$okazu->TrackStore->PathObj->TitleObj->Version( 4 );
	$okazu->TrackStore->PathObj->Filenumber( 2 );

	my $tracks = [];
	if ( $c->{collectionid} ) {

		$tracks = [
			$schema->resultset( 'TrackCollectionEntry' )->search(
				{
					track_collection_id => $c->{collectionid},
				}
			)->get_column( 'track_id' )->all()
		];

	} else {
		my $result = $csv->suboncsv(
			$c->{path},
			sub {
				my ( $row ) = @_;
				return unless int( $row->[0] );
				push( @$tracks, $row->[0] );
			}
		);
	}

	my $tracksrs = $schema->resultset( 'OkazuToTrack' )->search(
		{
			track_id => $tracks
		}
	);
	print "mkdir $c->{out}/$/";

	while ( my $crossrow = $tracksrs->next() ) {
		GSAC::Common::copytrack( $okazu, $crossrow, $c );
	}
}
