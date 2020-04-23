use strict;
use warnings;
use DBI;
use open qw/:std :utf8/;
use Data::Dumper;
use URI::Escape;
use MP3::Tag;
use open qw/:std :utf8/;
main( @ARGV );

sub main {
	my ( $filename ) = @_;

	# 	my $filename = "./[02]Wheel[3-v7c.1].mp3";
	my $mp3 = MP3::Tag->new( $filename );
	my ( $title, $track, $artist, $album, $comment, $year, $genre ) = $mp3->autoinfo();
	print join( " ", ( $title, $track, $artist, $album, $comment, $year, $genre ) );
	print $/;
	$mp3->get_tags;

	if ( exists $mp3->{ID3v1} ) {
		$mp3->{ID3v1}->remove_tag;
	}

	if ( exists $mp3->{ID3v2} ) {
		$mp3->{ID3v2}->remove_tag;
	}

	$mp3->close();

}
