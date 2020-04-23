#!/usr/bin/perl
use strict;
use warnings;
use lib "../lib";
use open qw/:std :utf8/;

main();

sub main {
	use Schema::GsaDB;
	use DBI;
	my $dbh = DBI->connect( "dbi:mysql:gsa_db", "ase", "ase", {RaiseError => 1, PrintError => 1, mysql_enable_utf8 => 1} );

	my $schema     = Schema::GsaDB->connect( sub { return $dbh } );
	my $statements = $schema->deployment_statements(
		undef, undef, undef,
		{
			quote_identifiers => 1,
			no_comments       => 1,
		}
	);
	print "$statements\n";

}
