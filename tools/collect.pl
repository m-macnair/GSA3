#!/usr/bin/perl
use strict;
use warnings;
use lib "../lib";
use Data::Dumper;
use File::Path;
require File::Copy;
use open qw/:std :utf8/;
main();

sub main {
	my $tracks = [
		qw/ 2830
		  2900
		  3429
		  3431
		  3433
		  3441
		  3461
		  3462
		  3471
		  3481
		  3491
		  3499
		  3500
		  3504
		  3509
		  3520
		  3527
		  3528
		  3534
		  3538
		  3554
		  3555
		  3556
		  3566
		  3568
		  3571
		  3573
		  3578
		  3579
		  6443
		  9290
		  13616
		  14249
		  14468
		  14471
		  14987
		  14990
		  15038
		  15039
		  15042
		  16467
		  16475
		  16484
		  31322
		  32523
		  32555
		  40369
		  40371
		  40372
		  40374
		  40376
		  40377
		  40378
		  40379
		  40380
		  40381
		  40382
		  40385
		  40386
		  40388
		  40391
		  40393
		  40402
		  40404
		  40408
		  40409
		  40410
		  40412
		  40415
		  40420
		  40423
		  40426
		  40431
		  40435
		  40441
		  40442
		  40443
		  40445
		  40447
		  40449
		  40452
		  40456
		  40458
		  40461
		  40462
		  40468
		  42390
		  42391
		  42392
		  42394
		  48372
		  48792
		  48882
		  /
	];

	use Schema::GsaDB;
	my $schema = Schema::GsaDB->connect( "dbi:mysql:gsa_db;host=192.168.0.16", "ase", "ase", {RaiseError => 1, PrintError => 1, mysql_enable_utf8 => 1} );
	use GSA2::Okazu;
	my $okazu = GSA2::Okazu->new(
		{
			schema     => $schema,
			local_path => "/home/m/Fun/Okazus/GSA/",
		}
	);

	$okazu->TrackStore->PathObj->TitleObj->Version( 2 );
	$okazu->TrackStore->PathObj->Filenumber( 2 );

	# 	my $okazurow = $schema->resultset('Track')->find(5428)
	# 		->search_related('okazus_to_track')->first()
	# 		->search_related('okazu')->first();

	my $output = "./Artist 643";
	mkdir $output;

	my $tracksrs = $schema->resultset( 'OkazuToTrack' )->search(
		{
			track_id => $tracks
		}
	);
	while ( my $crossrow = $tracksrs->next() ) {

		my $okazurow = $crossrow->search_related( 'okazu' )->first();
		my $dir      = $okazu->TrackStore->PathObj->album_dir_for( $okazurow );
		my $fname    = $okazu->TrackStore->PathObj->file_name( $okazurow );
		my $path     = "$okazu->{local_path}/$dir/$fname";
		$path =~ s|//|/|g;
		if ( -e $path ) {
			my $albumdir = "$output/$dir/";
			mkpath( $albumdir ) unless -e $albumdir;

			$okazu->TrackStore->PathObj->TitleObj->Version( 3 );
			my $newfname = $okazu->TrackStore->PathObj->file_name( $okazurow );
			$okazu->TrackStore->PathObj->TitleObj->Version( 2 );
			print "$fname -> $albumdir/$newfname $/";
			File::Copy::cp( $path, "$albumdir/$newfname" ) or die $!;
		} else {
			print "$path not found $/";
		}
	}

}
