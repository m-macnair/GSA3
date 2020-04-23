use utf8;
my $string = "yes";

print "yes" if is_ascii( undef, $string );

sub is_ascii {
	my ( $self, $string ) = @_;

	my $res = ( $string =~ /[A-Za-z]/ );
	warn $res;
}
