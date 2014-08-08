use strict;
use warnings;

package App::Embra::Plugin::Zilla;

# ABSTRACT: provides a Dist::Zilla-like object for wrapped plugins

use Moo;
use Method::Signatures;

=head1 DESCRIPTION

This plugin provides enough of the functionality of L<Dist::Zilla> to fool a plugin wrapped by L<App::Embra::Plugin::WrapZillaPlugin>. Not all Dist::Zilla plugin roles are supported!

=cut

has 'zilla' => (
    is => 'lazy',
    default => method { $self->embra },
    handles => [ qw< files > ],
);

method isa( $class ) {
    $class eq ref $self or $class eq 'Dist::Zilla'; # cheeky
}

with 'App::Embra::Role::Plugin';

1;
