use strict;
use warnings;

package App::Embra::Role::Plugin;

# ABSTRACT: something that gets plugged into App::Embra

use Method::Signatures;
use Moo::Role;

=head1 DESCRIPTION

This role provides a few key methods and attributes which all plugins for App::Embra should implement. It consumes the L<Logging role|App::Embra::Role::Logging>, altering L<C<log prefix>|App::Embra::Role::Logging/log_prefix> to include the plugin's name, and L<C<logger>|App::Embra::Role::Logging/logger> to reuse the C<logger> from the instance of App::Embra being plugged into.

=cut

method _build_log_prefix {
    return "[${ \ $self->name }] ";
}

method _build_logger {
    $self->embra->logger;
}

with 'App::Embra::Role::Logging';

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

method BUILDARGS( @args ) {
    my %args = @args;
    for my $attr ( qw< name > ) {
        if( not defined $args{$attr} ) {
            delete $args{$attr};
        }
    }

    return \%args;
}

=method register_plugin

    App::Embra::Role::Plugin->register_plugin( $embra, $name, $payload );

This static method creates a new instance of the consuming class, plugs it into C<$embra>, and returns it. The new instance is created with its C<name> set to C<$name>, C<embra> set to C<$embra>, and each entry of the C<$payload> hash ref passed as an argument to the constructor.

=cut

method register_plugin( $class:, App::Embra :$embra, :$name, HashRef :$payload = {} ) {
    my $self = $class->new( embra => $embra, name => $name, %{ $payload } );
    $self->logger->debugf( '%sregistered with %s', $self->log_prefix, $payload );
    $embra->add_plugin( $self );
    return $self;
}

1;
