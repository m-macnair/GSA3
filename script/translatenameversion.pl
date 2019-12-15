use strict;
use warnings;
use DBI;
use GSA3::Class::Backend;
use Data::Dumper;
use GSA3::Class::Name::Simple;
main( @ARGV );

sub main {
	my ( $string ) = @_;
	die "Nothing supplied" unless $string;
	my $dbh = DBI->connect( 'dbi:mysql:gsa', 'root', 'rootpassword' );

	my $gsa_be = GSA3::Class::Backend->new(
		{
			dbh => $dbh,
		}
	);
	my $gsa_name_simple = GSA3::Class::Name::Simple->new();
	my $extended        = $gsa_be->getextendedtrack( $gsa_name_simple->defunk( $string ) );
	my ( $file, $version ) = $gsa_name_simple->filename( $extended );
	my $path = $gsa_name_simple->dirname( $extended );

	print "$path/$file$extended->{trow}->{safe_title}$version.mp3$/";

}
