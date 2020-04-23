use strict;
use warnings;
use lib "/home/m/Perl/Repo/GSAC/lib";
use open qw/:std :utf8/;
use Data::Dumper;
use URI::Escape;
main();

sub main {
	require GSAC::Common;
	my ( $okazu, $schema ) = GSAC::Common::getokazu();
	my $linktable = 'Album';
	my $lctable   = lc( $linktable );
	$schema->storage->debug( 1 );
	my $something;
	my $page;
	do {
		$something = 0;
		$page++;
		$schema->txn_do(
			sub {
				my $trackrs = $schema->resultset( $linktable )->search(
					{

					},
					{
						prefetch => "$lctable\_titles",
						rows     => 1000,
						page     => $page,
					}
				);
				while ( my $row = $trackrs->next() ) {
					$something = 1;
					my $titlerow = $schema->resultset( 'Title' )->find_or_create(
						{
							title    => $row->title(),
							language => "??",
							meta1    => "original"
						}
					);
					my $joinrow = $row->create_related(
						"$lctable\_titles",
						{
							title_id => $titlerow->id()
						}
					);
				}
			}
		);
	} while ( $something );
	print "It is done. Move on!$/";
}
