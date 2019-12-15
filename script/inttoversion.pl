use strict;
use warnings;
use GSA3::Name;
main( @ARGV );

sub main {
	my ( $string ) = @_;
	( $string ) = ( $string =~ m|([^.-]*)[.-]([^.-]*)[.-]| );

}
