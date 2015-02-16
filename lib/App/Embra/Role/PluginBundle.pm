use strict;
use warnings;

package App::Embra::Role::PluginBundle;

# ABSTRACT: something that plugs in a bunch of plugins

use Method::Signatures;
use App::Embra::Util qw< expand_config_package_name >;
use Moo::Role;

=head1 DESCRIPTION

This role provides a few key methods and attributes which all plugins for App::Embra should implement. It consumes the L<Logging role|App::Embra::Role::Logging>, altering L<C<log prefix>|App::Embra::Role::Logging/log_prefix> to include the plugin's name, and L<C<logger>|App::Embra::Role::Logging/logger> to reuse the C<logger> from the instance of App::Embra being plugged into.

=cut

with 'App::Embra::Role::Plugin';

has 'bundled_plugins_config' => (
    is => 'ro',
    default => func { [] },
);

method add_plugin($pkg, :$name = $pkg, @payload) {
    $pkg = expand_config_package_name($pkg);

    my %payload;
    if( 1 == @payload and 'HASH' eq $payload[0]) {
        %payload = %{ $payload[0] };
    }
    else {
        %payload = @payload;
    }
    push @{ $self->bundled_plugins }, [ $pkg, $name, \( %payload ) ];
}

require 'configure_bundle';

method BUILD {}

after 'BUILD' => func { $self->configure_bundle };

1;
