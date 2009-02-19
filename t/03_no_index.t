#!/usr/bin/perl

use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use Test::More tests => 8;
use File::Spec::Functions ':ALL';
use File::Find::Rule       ();
use File::Find::Rule::Perl ();

use constant FFR => 'File::Find::Rule';





#####################################################################
# Run four variations of the standard query

my @params = (
	[ ],
	[ curdir() ],
	[ 'META.yml' ],
	[ { directory => [ 'inc', 't' ] } ],
);

foreach my $p ( @params ) {
	my $rule  = FFR->no_index(@$p)->relative->file;
	isa_ok( $rule, 'File::Find::Rule' );

	my %ignore = map { $_ => 1 } qw{
		Makefile
		MANIFEST
		LICENSE
		README
		pm_to_blib
	};
	my @files = sort grep {
		! /\.svn\b/
		and
		! /\bblib\b/
		and
		! $ignore{$_}
	} $rule->in( curdir() );

	is_deeply( \@files, [ qw{
		Changes
		META.yml
		Makefile.PL
		lib/File/Find/Rule/Perl.pm
	} ], 'Found the expected files' );
}
