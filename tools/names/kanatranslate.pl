use strict;
use warnings;
use lib "/home/m/Perl/Repo/GSAC/lib";
use open qw/:std :utf8/;
use Data::Dumper;
use URI::Escape;
use Lingua::JA::Moji qw( kana2romaji);
main();

sub main {
	require GSAC::Common;
	require Ryza::Common;
	my ( $okazu, $schema ) = GSAC::Common::getokazu();
	my $linktable = 'Track';
	my $lctable   = lc( $linktable );
	$schema->storage->debug( 1 );
	my $something;

	my @trackids;
	Ryza::Common::suboncsv(
		"./data/kanas.csv",
		sub {
			my ( $trackid ) = @_;
			push( @trackids, $trackid );
		}
	);

	do {
		$something = 0;
		$schema->txn_do(
			sub {
				my @set = splice( @trackids, 0, 100 );

				#this is entirely the wrong way to do it but my eyes are closing
				# the join is wrong; the result set is wrong, and the ids are wrong f
				my $rs = $schema->resultset( $linktable . "Title" )->search(
					{
						"track.id" => \@set,
					},
					{
						prefetch => [qw/ track title/]
					}
				);
				while ( my $row = $rs->next() ) {

					my $doners = $row->search_related(
						"title",
						{
							language => 'JA',
							meta1    => 'romaji',
						}
					);
					my $stop;
					while ( my $donerow = $doners->next() ) {
						$stop = 1;
						last;
					}
					next if $stop;
					my $newtitle = kana2romaji(
						$row->$lctable->title(),
						{
							style => "common",

						}
					);

					my $titlerow = $schema->resultset( 'Title' )->find_or_create(
						{
							title    => $newtitle,
							language => "JA",
							meta1    => "romaji",
							meta2    => "common",
						}
					);

					#

					my $joinrow = $schema->resultset( $linktable . "Title" )->create(
						{
							title_id         => $titlerow->id(),
							$lctable . "_id" => $row->$lctable->id
						}
					);
				}

				# 				exit;
			}
		);

	} while ( @trackids );
	print "It is done. Move on!$/";
}
