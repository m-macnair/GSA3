use strict;
use warnings;

# use lib "../lib";
#common command line utilities
package GSAC::Common;

sub getokazu {

	use Schema::GsaDB;
	my $schema = Schema::GsaDB->connect( "dbi:mysql:gsa_live;host=192.168.0.16", "gsa", "gsa", {RaiseError => 1, PrintError => 1, mysql_enable_utf8 => 1} );
	use GSA2::Okazu;
	my $okazu = GSA2::Okazu->new(
		{
			schema     => $schema,
			local_path => "/home/m/Fun/Okazus/GSA/",
		}
	);
	return ( $okazu, $schema );
}

#return true if a track has a specific tag

sub findtracktag {
	my ( $schema, $trackrow, $tag ) = @_;
	my $tagrow = $schema->resultset( "SharedTagMessDef" )->find(
		{
			name => $tag
		}
	);
	if ( $tagrow ) {
		my $cloudrow = $tagrow->search_related(
			"track_tag_mess_clouds",
			{
				track_id => $trackrow->id
			}
		)->first();

		if ( $cloudrow ) {
			return 1;
		}
	} else {
		return 0;
	}
}

sub listtotrackaction {
	my ( $file, $okazu, $schema, $sub ) = @_;
	use Ryza::CSV;
	use File::Basename;
	my $csv    = Ryza::CSV->new();
	my $result = $csv->suboncsv(
		$file,
		sub {
			my ( $row ) = @_;
			return unless -e $row->[0];
			my ( $name, $path, $suffix ) = fileparse( $row->[0], qr/\.[^.]*/ );
			my ( $code ) = ( $name =~ m|\[3[-.](.*)\..*\]| );
			if ( $code ) {
				my $trackid = $okazu->TrackStore->PathObj->TitleObj->number_convert_from_1( $code );
				if ( $trackid ) {
					my $trackrow = $schema->resultset( 'Track' )->find( $trackid );
					&$sub( $row->[0], $trackrow, $row );
				} else {
					die "unknown track(?!)";
				}
			}

		}
	);
}

sub copytrack {
	my ( $okazu, $crossrow, $c ) = @_;

	my $okazurow = $crossrow->search_related( 'okazu' )->first();
	my $dir      = $okazu->TrackStore->PathObj->album_dir_for( $okazurow );
	my $fname    = $okazu->TrackStore->PathObj->file_name( $okazurow );
	my $path     = "$c->{root}/$dir/$fname";

	$path =~ s|//|/|g;

	my $albumdir;
	if ( $c->{flat} ) {
		$albumdir = "$c->{out}/";

	} else {
		die "whit";
		$albumdir = "$c->{out}/$dir/";
		print "mkdir $c->{out}/$dir/$/";
	}
	$okazu->TrackStore->PathObj->TitleObj->Version( 4 );
	my $newfname = $okazu->TrackStore->PathObj->file_name( $okazurow );
	$okazu->TrackStore->PathObj->TitleObj->Version( 2 );
	if ( $c->{copy} ) {
		File::Copy::cp( $path, "$albumdir/$newfname" ) or die $!;
	} else {
		print "cp $path $albumdir/$newfname $/";
	}
}

1;
