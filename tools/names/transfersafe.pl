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
	do {
		$something = 0;
		$schema->txn_do(
			sub {
				my $trackrs = $schema->resultset( $linktable )->search(
					{
						"$lctable\_titles.id" => undef,
					},
					{
						prefetch => "$lctable\_titles",
						rows     => 1000
					}
				);
				while ( my $row = $trackrs->next() ) {
					$something = 1;
					my $titlerow = $schema->resultset( 'Title' )->create(
						{
							title    => $row->safe_title(),
							language => "??",
							meta     => "safe title"
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
