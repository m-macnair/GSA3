use lib "./lib/";
use strict;
use warnings;
use Ryza::CSV;
use Ryza::CombinedCLI;
use GSAC::Common;

#for a list of files, detect the jump code and apply tags supplied from command line and/or the [1] column
main();

sub main {

	my $c = Ryza::CombinedCLI::standard_config(
		{
			file => undef,
			tags => undef
		}
	);

	my @tags = split( " ", $c->{tags} );
	use Data::Dumper;

	my ( $okazu, $schema ) = GSAC::Common::getokazu();
	$schema->storage->debug( 0 );
	my $idtrack;
	GSAC::Common::listtotrackaction(
		$c->{file},
		$okazu, $schema,
		sub {
			my ( $path, $dbresult, $row ) = @_;

			my @extratags = split( " ", $row->[1] || "" );

			# 				die Dumper(@extratags);
			my $thesetags = [ @tags, @extratags ];

			$okazu->TrackTagMess->bulk_add_cloud_2(
				{
					id        => $dbresult->get_column( 'id' ),
					def_arref => $thesetags,
					no_txn    => undef,
					blind     => 1,
				}
			);
		}
	);
}
