use strict;
use warnings;
use Ryza::CSV;
use Ryza::CombinedCLI;
use GSAC::Common;
main();

sub main {
	my $c = Ryza::CombinedCLI::standard_config(
		{
			path => undef,
			root => undef,
			user => 1
		}
	);
	my $csv = Ryza::CSV->new();

	my ( $okazu, $schema ) = GSAC::Common::getokazu();
	$schema->storage->debug( 1 );

	#!?;
	$okazu->TrackTagMess->{schema}->storage->debug( 1 );
	$schema->txn_do(
		sub {
			my $result = $csv->suboncsv(
				$c->{path},
				sub {
					my ( $row ) = @_;
					return unless $row->[0];
					return unless $row->[1];
					my $trackid    = $okazu->TrackStore->PathObj->TitleObj->number_convert_from_1( $row->[0] );
					my $voteparams = {
						user_id  => $c->{user},
						vote     => $row->[1],
						track_id => $trackid
					};
					$schema->resultset( 'TrackVote' )->find_or_create( $voteparams );

					#discard that which has been used
					splice( @$row, 0, 2 );
					return unless $row->[0];

					$okazu->TrackTagMess->bulk_add_cloud_2(
						{
							id        => $trackid,
							def_arref => $row,
							no_txn    => undef,
							blind     => 1,
						}
					);

				}
			);

			# 			die;
		}
	);
}

