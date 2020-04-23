use strict;
use warnings;
use DBI;
use open qw/:std :utf8/;
use Data::Dumper;
use URI::Escape;
main();

sub main {
	my $table  = "shared_performer_mess_def";
	my $unsafe = 'name';
	my $dbh    = DBI->connect(
		"dbi:mysql:gsa_db_live",
		"ase",
		"ase",
		{RaiseError => 1, PrintError => 1, mysql_enable_utf8 => 1}

	) or die DBI::errstr;
	my $getsth    = $dbh->prepare( "select * from $table where safe_title is null" );
	my $updatesth = $dbh->prepare( "update $table set safe_title = ? where id = ? " );
	$dbh->{AutoCommit}          = 0;
	$dbh->{'mysql_enable_utf8'} = 0;
	use Encode;

	# 	print "彼岸帰航-Hell or Heaven Mix-",$/;
	# 	print decode_utf8( "彼岸帰航-Hell or Heaven Mix-"),$/;
	# 	exit;
	$getsth->execute();
	my $counter = 0;
	while ( my $row = $getsth->fetchrow_hashref() ) {
		$counter++;

		# 		print decode_utf8( $row->{title}) ,$/;

		my $safe_title = URI::Escape::uri_escape_utf8( decode_utf8( $row->{$unsafe} ) );

		# 		print $safe_title,$/;
		$updatesth->execute( $safe_title, $row->{id} );

		if ( $counter == 1000 ) {
			$dbh->commit();
			$counter = 1;
		}
	}
	$dbh->commit();
}
