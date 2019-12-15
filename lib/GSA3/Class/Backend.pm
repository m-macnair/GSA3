use strict;
use warnings;

package GSA3::Class::Backend;
use Moo;
use Toolbox::SqlAbstract;

ACCESSORS: {
	has dbh => (
		is       => 'rw',
		required => 1,
	);
	has tsqla => (
		is      => 'rw',
		lazy    => 1,
		builder => '_buildtsqla'
	);
}

sub getextendedtrack {
	my ( $self, $trackint ) = @_;

	my $trow = $self->tsqla->get(
		'track',
		{
			id => $trackint
		}
	);

	die "Row not found for [$trackint]" unless $trow;

	my $arow = $self->tsqla->get(
		'album',
		{
			id => $trow->{album_id},
		}
	);

	my $mrow = $self->tsqla->get(
		'shared_performer_mess_def',
		{
			id => $trow->{performer_id},
		}
	);
	
	my $orow = $self->tsqla->get(
		'okazu_to_track',
		{
			track_id => $trow->{id},
		}
	);

	return {
		trow => $trow,
		arow => $arow,
		mrow => $mrow,
		orow => $orow
	};

}

sub _buildtsqla {
	my ( $self ) = @_;
	my $sqla = Toolbox::SqlAbstract->new(
		{
			dbh => $self->dbh(),
		}
	);

}

1;
