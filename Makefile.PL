#!/usr/bin/perl -w

use strict;

use ExtUtils::MakeMaker;

WriteMakefile(
	NAME         => 'MooseX::Types::Authen::Passphrase',
	VERSION_FROM => 'lib/MooseX/Types/Authen/Passphrase.pm',
	INSTALLDIRS  => 'site',
	SIGN         => 1,
	PL_FILES     => { },
	PREREQ_PM    => {
		'Test::use::ok' => 0,
	},
);

