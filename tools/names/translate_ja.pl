use strict;
use warnings;
use lib "/home/m/Perl/Repo/GSAC/lib";
use utf8;
use open qw/:std :utf8/;
use Data::Dumper;
use URI::Escape;
use Lingua::JA::Moji qw( kana2romaji is_kana);
require Data::Validate::Japanese;
use Encode;
main();

sub main {

	my $string = "aりgato";
	$string = substr( $string, 1, 1 );

	# 	$string = '踊子り';
	# 	$string = decode('UTF-8',$string);
	# 	my $romaji = kana2romaji( $string, { style => "hepburn", passport => 1 } );

	my $dvj = Data::Validate::Japanese->new();
	my $map;

	cantranslate( $string, $dvj, $map );

}

sub cantranslate {
	my ( $string, $dvj, $map ) = @_;
	if (
		$dvj->contains_only(
			$string,
			{
				ascii => 1
			}
		)

	  )
	{
		print "ascii$/";
	} elsif (
		$dvj->contains_only(
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
		print "romaji-able$/";

	} elsif (
		$dvj->contains_only(
			$string,
			{
				hiragana   => 1,
				katakana   => 1,
				kanji      => 1,
				h_katakana => 1,
				ascii      => 1
			}
		)
	  )
	{
		print "Kanji present$/";

	} else {
		print "wat : $string$/";

	}

}
