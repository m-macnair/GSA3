use strict;
use warnings;
use DBI;
use GSA3::Class::Backend;
use Data::Dumper;
use GSA3::Class::Name::Simple;
use Toolbox::FileSystem;
main( @ARGV );

sub main {
	my ( $dir ) = @_;

	my $dbh = DBI->connect( 'dbi:mysql:gsa', 'root', 'rootpassword' );
	my $p = {};
	$p->{bend} = GSA3::Class::Backend->new(
		{
			dbh => $dbh,
		}
	);
	$p->{name} = GSA3::Class::Name::Simple->new();
	Toolbox::FileSystem::subonfiles(
		sub {

			process_file( $p, shift );
		},
		$dir
	);

}

sub process_file {
	my ( $p, $file ) = @_;
	return 1 unless index( $file, '.mp3' ) != -1;
	return 1 unless index( $file, '[3-' ) != -1;
	my $dir;
	( $file, $dir ) = Toolbox::FileSystem::filebasename( $file );

	my $stripstring = $p->{name}->stripstring( $file );
	next unless $stripstring;

	my $defunkt = $p->{name}->defunk( $stripstring );
	if ( $defunkt ) {
		my $extended = $p->{bend}->get_extended_track( $defunkt );
		my ( $newfile, $version ) = $p->{name}->file_name( $extended );
		my $newpath;
		my $safeishtitle = $extended->{trow}->{safe_title};
		$safeishtitle =~ s|%20| |g;
		if ( index( $safeishtitle, '%' ) == -1 ) {
			$newpath = "$newfile$safeishtitle$version.mp3";
		} else {
			my $counts = {};
			foreach my $code ( split( '%', $safeishtitle ) ) {
				next unless $code;
				my $id = substr( $code, 0, 2 );
				next unless uc( $id ) =~ m/[0-9 A-F]{2}/;
				$counts->{$id}++;
			}
			for ( 21 ... 50 ) {
				delete( $counts->{$_} );
			}
			if ( keys( %{$counts} ) ) {

				#something other than spaces present - don't take risks
				$newpath = "$newfile$version.mp3";
			} else {

				my $safeishtitle = $safeishtitle;

				$newpath = "$newfile$safeishtitle$version.mp3";
			}
		}

		print "$dir/$file\n\t-> $dir/$newpath $/";
		Toolbox::FileSystem::mvf( "$dir/$file", "$dir/$newpath", );

	}

	return 1;
}
