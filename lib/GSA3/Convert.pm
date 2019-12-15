package GSA::Convert;
use Moose::Role;
use 5.006;
use strict;
use warnings;
use utf8;
use File::Find;
use File::Basename;
use Audio::Cuefile::Parser;

=head1 NAME

Ase::Okazu - The Okazu Tag Management System

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS
	Absorbs CUE files to the db
=cut

sub cue_test {

	my ( $self ) = @_;
	my $cue_dir = "/store/new_noise/T/TMC/2015 1.06.30 cue sheets/";
	$cue_dir = q|/store/new_noise/T/TMC/test/|;
	find(
		{
			no_chdir => 1,
			wanted   => sub {
				return if -d;
				$self->cue_import( $_ );
			},
		},
		$cue_dir
	);

}

sub cue_import {

	my ( $self, $cue_path ) = @_;
	my $cue = Audio::Cuefile::Parser->new( $cue_path );
	my ( $audio_file, $cd_performer, $cd_title ) = ( $cue->file, $cue->performer, $cue->title );
	my $tracks = scalar( $cue->tracks );

	# 	$cd_title  = 'Crimson Tempest おまけCD';
	my $column_values = {
		performer => $cd_performer,
		title     => $cd_title,
		tracks    => $tracks
	};
	my $album = $self->Album->search( $column_values );
	if ( $album ) {
		return {
			duplicate => 1,
			row = $album,
		};
	} else {
		$album = $self->Album->create( $column_values );
	}
	$self->schema->txn_do(
		sub {
			for my $line ( split( $/, $cue->cuedata ) ) {
				my $index = index( $line, 'REM' );
				if ( $index > -1 ) {
					my ( $name, $value ) = ( $line =~ m/REM ([^ ]*) (.*)/ );
					if ( $name && $value ) {
						$self->AlbumRem->create(
							{
								album_id => $album->id,
								name     => $name,
								value    => $value,
							}
						);
					} else {
						warn "$cd_title tried to add an empty remark";
					}
				}
			}
			foreach my $track ( $cue->tracks ) {
				$self->Track->find_or_new(
					{
						album_id  => $album->id,
						title     => $track->title,
						track_no  => $track->index,
						performer => $track->performer,
					}
				)->insert(); # if exists, non-op
			}
		}
	);
	return $new_album;

}

=head2 string_to_list
	foundation of revised search system - translates tag string(s) to tag_id value(s) and returns in no particular order
=cut

1;
