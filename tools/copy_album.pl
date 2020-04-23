#!/usr/bin/perl
use strict;
use warnings;
use lib "../lib";
use Data::Dumper;
use File::Path;
require File::Copy;
require Ryza::CombinedCLI;
require Ryza::CSV;
require GSAC::Common;
use open qw/:std :utf8/;

main();

sub main {

	my $c = Ryza::CombinedCLI::standard_config(
		{
			root     => undef,
			path     => undef,
			album_id => undef,
			out      => undef,

		}
	);
	my $csv = Ryza::CSV->new();
	my ( $okazu, $schema ) = GSAC::Common::getokazu();

	$okazu->TrackStore->PathObj->TitleObj->Version( 2 );
	$okazu->TrackStore->PathObj->Filenumber( 2 );

	my $tracks = [];
	if ( $c->{album_id} ) {

		$tracks = [
			$schema->resultset( 'Track' )->search(
				{
					album_id => $c->{album_id}
				}
			)->get_column( 'id' )->all()
		];

	} else {
		die "no album";
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

