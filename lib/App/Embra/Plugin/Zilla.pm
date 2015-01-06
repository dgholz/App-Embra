use strict;
use warnings;

package App::Embra::Plugin::Zilla;

# ABSTRACT: provides a Dist::Zilla-like object for wrapped plugins

use Method::Signatures;
use Moo;

=head1 DESCRIPTION

This plugin provides enough of the functionality of L<Dist::Zilla> to fool a plugin wrapped by L<App::Embra::Plugin::WrapZillaPlugin>. Not all Dist::Zilla plugin roles are supported!

=cut

has 'zilla' => (
    is => 'lazy',
    default => method { $self->embra },
    handles => [ qw< files > ],
);

around 'isa' => func ( $orig, $self, $class ) {
    return $class eq 'Dist::Zilla' or $orig->($self, $class); # cheeky
};

with 'App::Embra::Role::Plugin';

1;
