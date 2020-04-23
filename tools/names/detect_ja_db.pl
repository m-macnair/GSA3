use strict;
use warnings;
use lib "/home/m/Perl/Repo/GSAC/lib";
use utf8;
use open qw/:std :utf8/;
use Data::Dumper;
use URI::Escape;
use Lingua::JA::Moji qw( kana2romaji is_kana);
require Ryza::Ja;

use Encode;

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
	my $linktable = 'Track';
	my $lctable   = lc( $linktable );
	$schema->storage->debug( 1 );
	my $map = {};

	my $dvj = Ryza::Ja->new();

	my $trackrs = $schema->resultset( $linktable )->search(
		undef,

		# 	{rows => 100 }
	);
	while ( my $row = $trackrs->next() ) {
		cantranslate( $row->title, $dvj, $map, $row->id );

	}
	for my $set ( sort ( keys( %{$map} ) ) ) {
		open my $ofh, ">", "./$set.csv" or die $!;
		for ( @{$map->{$set}} ) {
			print $ofh "$_$/";
		}
		close $ofh;
	}

	print "It is done. Move on!$/";
}

sub cantranslate {
	my ( $string, $dvj, $map, $id ) = @_;
	if (
		$dvj->is_ascii( $string, )

	  )
	{
		push( @{$map->{ascii}}, $id );
		return;
	} elsif (
		$dvj->contains_any(
			$string,
			{
				hiragana   => 1,
				katakana   => 1,
				h_katakana => 1,
				ascii      => 1
			}
		)
	  )
	{

		if ( $dvj->contains_any( $string, {kanji => 1} ) ) {
			push( @{$map->{kanji}}, $id );
			return;
		} else {
			push( @{$map->{kanas}}, $id );
			return;
		}
	} else {
		push( @{$map->{wat}}, $id );
		return;
	}

}
