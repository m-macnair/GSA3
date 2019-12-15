package GSA3::Okazu::Path::Local;
our $VERSION = 0.01;
use 5.006;
use strict;
use warnings;
use Moose;
extends 'GSA3::Okazu::Path' => {-version => 0.01};
has 'local_path' => ( is => 'rw', default => "./" );

sub directorynamesub {

	my ( $self, $okazu_row ) = @_;
	if ( $okazu_row->content_block_id ) {
		my $path = sprintf( '%s/%s', $self->{local_path}, $self->albumdirfor( $okazu_row ) );
		return $path;
	} else {
		warn $okazu_row->id, " has no content block" if ( $self->{warning} > 0 );
		return;
	}

}
1;
