use strict;
use warnings;

package App::Embra::Role::Plugin;

# ABSTRACT: something that gets plugged into App::Embra

use Method::Signatures;
use Moo::Role;

=head1 DESCRIPTION

This should be consumed by classes who want to be configured and plugged into an L<App::Embra>. Classes which consume just this role will not get any of their methods called when collating the site. If your plugin want to change which files are included or how they appear in the site, then it should instead consume one (or more) of L<the roles used to collate the site|App::Embra/collate>.

This role consumes the L<Logging role|App::Embra::Role::Logging>, altering L<C<log prefix>|App::Embra::Role::Logging/log_prefix> to include the plugin's name, and L<C<logger>|App::Embra::Role::Logging/logger> to reuse the C<logger> from the instance of App::Embra being plugged into.

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

The name of the plugin. Defaults to the plugin's full class name.

=cut

has 'name' => (
    is => 'ro',
    default => method { ref $self },
);

=method register_plugin

    App::Embra::Role::Plugin->register_plugin( $embra, $name, $payload );

This static method creates a new instance of the consuming class, plugs it into C<$embra>, and returns it. The new instance is created with its C<name> set to C<$name>, C<embra> set to C<$embra>, and each entry of the C<$payload> hash ref passed as an argument to the constructor.

This is called from L<App::Embra::from_config_mvp_sequence>, using the section name from the config as the name for the plugin.
=cut

method register_plugin( $class:, App::Embra :$embra, :$name, HashRef :$payload = {} ) {
    if( defined $name ) {
        $payload->{name} = $name;
    }
    my $self = $class->new( embra => $embra, %{ $payload } );
    $self->logger->debugf( '%sregistered with %s', $self->log_prefix, $payload );
    $embra->add_plugin( $self );
    return $self;
}

1;
