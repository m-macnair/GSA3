#!/usr/bin/perl
use strict;
use warnings;
use lib "../lib";
use open qw/:std :utf8/;

main();

sub main {
	use Schema::GsaDB;
	my $schema = Schema::GsaDB->new();

}
