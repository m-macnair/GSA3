use utf8;
require Ryza::Ja;
use open qw/:std :utf8/;
use Data::Dumper;
my $string = "天狗が見ている -Cyber Dimension Mix-";
my $dvj    = Ryza::Ja->new();
die "yip" if $dvj->is_ascii( "yes" );

# 	print "yip" if $dvj->contains_any(
# 	$string,
# 	{
#
# 		ascii => 1
# 	}
# );
