# in a script
use DBIx::Class::Schema::Loader qw/ make_schema_at /;
make_schema_at(
	'Schema::GsaDB',
	{
		debug          => 1,
		dump_directory => '../lib',
	},
	[
		'dbi:mysql:gsa_db;host=192.168.0.16', 'ase', 'ase',

		# 		{ loader_class => 'MyLoader' } # optionally
	],
);

