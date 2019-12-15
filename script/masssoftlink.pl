#!/usr/bin/perl
# ABSTRACT: move bad GSA identifiers to the new shiny, and softlink in the old shiny

use strict;
use warnings;
use DBI;
use GSA3::Class::Backend;
use Data::Dumper;
use GSA3::Class::Name::Simple;
use Toolbox::FileSystem;

main( @ARGV );

sub main {
	my ( $source, $target ) = @_;
	die "Source directory [$source] is not a directory" unless ( -d $source );
	die "Target directory [$target] is not a directory" unless ( -d $target );
	die " Same directory provided twice!"               unless ( $source ne $target );

	$source = Toolbox::FileSystem::abspath( $source );
	$target = Toolbox::FileSystem::abspath( $target );
	my $dbh = DBI->connect( 'dbi:mysql:gsa3;host=192.168.0.16', 'gsa', 'gsa' );
	my $p = {};
	$p->{bend} = GSA3::Class::Backend->new(
		{
			dbh => $dbh,
		}
	);
	$p->{name}   = GSA3::Class::Name::Simple->new();
	$p->{target} = $target;
	Toolbox::FileSystem::subonfiles(
		sub {

			process_file( $p, shift );
		},
		$source
	);

}

sub process_file {
	my ( $p, $file ) = @_;

	return unless index( $file, '.mp3' ) != -1;
	return unless index( $file, '[3.' ) != -1;

	my $dir;
	( $file, $dir ) = Toolbox::FileSystem::filebasename( $file );
	warn $file;
	my $stripstring = $p->{name}->stripstring(
		$file,
		{
			stringstarter => '\[3\.'
		}
	);

	return unless $stripstring;

	my $defunkt = $p->{name}->defunk( $stripstring );
	if ( $defunkt ) {
		my $extended = $p->{bend}->getextendedtrack( $defunkt );
		my $newfile  = $p->{name}->fullname( $extended );

		my $ntarget = "$p->{target}/$newfile";

		# 		print "$dir/$file\n\t-> $ntarget$/";
		my ( $tfile, $tdir ) = Toolbox::FileSystem::filebasename( $ntarget );
		Toolbox::FileSystem::mkpath( $tdir );
		Toolbox::FileSystem::mvf( "$dir/$file", $ntarget );
		symlink( $ntarget, "$dir/$file" );
	}

	return;
}
