use strict; 
use warnings; 
use GSA3::Name;
main(@ARGV);

sub main {
	my ($string) = @_;
	warn $string;
	my ($major,$minor) = ( $string =~ m|([3,2]?)[.-]?([^.-]*)[.-]?|);
	warn ("$major,$minor");
	die GSA3::Name::defunk(undef,$minor);

}