#!/usr/bin/perl

package MooseX::Types::Authen::Passphrase;

use strict;
use warnings;

our $VERSION = "0.02";

use Authen::Passphrase;
use Authen::Passphrase::RejectAll;

use MooseX::Types::Moose qw(Str Undef);

use MooseX::Types -declare => [qw(Passphrase)];

use namespace::clean;

class_type "Authen::Passphrase";
class_type Passphrase, { class => "Authen::Passphrase" };

foreach my $type ( "Authen::Passphrase", Passphrase ) {
    coerce( $type,
		from Undef, via { Authen::Passphrase::RejectAll->new },
		from Str, via {
			if ( /^\{/ ) {
				return Authen::Passphrase->from_rfc2307($_);
			} else {
				return Authen::Passphrase->from_crypt($_);
				#my ( $p, $e ) = do { local $@; my $p = eval { Authen::Passphrase->from_crypt($_) }; ( $p, $@ ) };

				#if ( ref $p and $p->isa("Authen::Passphrase::RejectAll") and length($_) ) {
				#	warn "e: $e";
				#	return Authen::Passphrase::Clear->new($_);
				#} elsif ( $e ) {
				#	die $e;
				#} else {
				#	return $p;
				#}
			}		
		},
	);
}

__PACKAGE__

__END__

=pod

=head1 NAME

MooseX::Types::Authen::Passphrase - L<Authen::Passphrase> type constraint and
coercions

=head1 SYNOPSIS

	package User;
	use Moose;

	use MooseX::Types::Authen::Passphrase qw(Passphrase);

	has pass => (
		isa => Passphrase,
		coerce => 1,
		handles => { check_password => "match" },
	);

	User->new( pass => undef ); # Authen::Passphrase::RejectAll

	my $u = User->new( pass => "{SSHA}ixZcpJbwT507Ch1IRB0KjajkjGZUMzX8gA==" );

	$u->check_password("foo"); # great success

	User->new( pass => Authen::Passphrase::Clear->new("foo") ); # clear text is not coerced by default

=head1 DESCRIPTION

This L<MooseX::Types> library provides string coercions for the
L<Authen::Passphrase> family of classes.

=head1 TYPES

=over 4

=item C<Authen::Passphrase>

This is defined as a class type

The following coercions are defined

=over 4

=item from C<Undef>

Returns L<Authen::Passphrase::RejectAll>

=item from C<Str>

Parses using C<from_rfc2307> if the string begins with a C<{>, or using
C<from_crypt> otherwise.

=back

=back

=head1 VERSION CONTROL

This module is maintained using Darcs. You can get the latest version from
L<http://nothingmuch.woobling.org/code>, and use C<darcs send> to commit
changes.

=head1 AUTHOR

Yuval Kogman E<lt>nothingmuch@woobling.orgE<gt>

=head1 COPYRIGHT

	Copyright (c) 2008 Yuval Kogman. All rights reserved
	This program is free software; you can redistribute
	it and/or modify it under the same terms as Perl itself.

=cut
