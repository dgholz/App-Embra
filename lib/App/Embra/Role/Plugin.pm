use strict;
use warnings;

package App::Embra::Role::Plugin;

# ABSTRACT: something that gets plugged into App::Embra

use Method::Signatures;
use Moo::Role;

=head1 DESCRIPTION

This role provides a few key methods and attributes which all plugins for App::Embra should implement. It consumes the L<Logging role|App::Embra::Role::Logging>, altering L<C<log prefix>|App::Embra::Role::Logging/log_prefix> to include the plugin's name, and L<C<logger>|App::Embra::Role::Logging/logger> to reuse the C<logger> to reuse the C<logger> from the instance of App::Embra being plugged into.

=cut

with 'App::Embra::Role::Logging';

around '_build_log_prefix' => func( $orig, $self ) {
    return "[${ \ $self->name }] ";
};

around '_build_logger' => func( $orig, $self ) {
    $self->embra->logger;
};

=attr embra

The instance of L<App::Embra> into which the plugin was plugged.

=cut

has 'embra' => (
    is => 'ro',
    required => 1,
);

=attr name

The name of the plugin, generally set to the name used in the configuration file when read by L<App::Embra::MVP::Assembler>. Defaults to the class name of the implementer.

=cut

has 'name' => (
    is => 'ro',
    default => method { ref $self },
);

=method register_plugin

    App::Embra::Role::Plugin->register_plugin( $class, $name, $args, $embra );

Static method which creates a new instance of the implementing plugin with its C<name> set to C<$name>, C<embra> set to C<$embra>, and each entry of the C<$args> hash ref passed as an argument to the constructor. It then plugs new instance into C<$embra>.

=cut

method register_plugin( $class:, :$name, HashRef :$args, App::Embra :$embra ) {
    my $self = $class->new( embra => $embra, name => $name, %{ $args } );
    $embra->add_plugin( $self );
}

1;
