package GSA3::Mess::Tag;
our $VERSION = '0.01';
use Moose;
use 5.006;
use strict;
use warnings;
extends 'Ase2::Mess::AliasImply' => {-version => 0.01};
with qw/
  Ase2::Mess::Search
  /;

#and that's it :D
1;
