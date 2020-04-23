#!/usr/bin/perl
use strict;
use warnings;

use lib "../../lib";

main();

sub main {
	use GSAC::Common;
	my ( $okazu, $schema ) = GSAC::Common::getokazu();

	#identify performer
	my $performer_id     = 766;
	my $tag_string_array = [
		qw/
		  misato

		  /
	];

	#identify performer tracks
	my $rs = $schema->resultset( 'Track' )->search( {performer_id => $performer_id} );

	use Data::Dumper;
	while ( my $row = {$rs->next->get_inflated_columns()} ) {

		warn Dumper( $row );

		#$c->model('Okazu')->TrackTagMess->{warning} = 2;
		$okazu->TrackTagMess->bulk_add_cloud( $row->{id}, $tag_string_array );

	}

}
