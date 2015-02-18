use strict;
use warnings;

package App::Embra::Role::PluginBundle;

# ABSTRACT: something that plugs in a bunch of plugins

use Method::Signatures;
use App::Embra::Util qw< expand_config_package_name >;
use Moo::Role;

=head1 DESCRIPTION

This role will allow the composer to be used as a L<Bundle|Config::MVP::Assembler::WithBundles>. It requires the composer to provide a C<configure_bundle> method, which will be called once after the constructor.

=cut

with 'App::Embra::Role::Plugin';

=attr bundled_plugins_config

A list of plugins to be included. Each element should be an arrayref of:

    [ $package_name, $plugin_name, [ @plugin_args ] ]

where C<$package_name> is the name of the plugin package, C<$plugin_name> will be used for the name of the plugin, and C<@plaugin_args> will be passed to the plugin's constructor.

The helper method C< L</add_plugin> > provides a flexible way to populate this list.

=cut

has 'bundled_plugins_config' => (
    is => 'ro',
    default => method { [] },
);

=method add_plugin

    $self->add_plugin('Foo');
    $self->add_plugin('Foo', 'Foo with special name');

    # also recognised name as second parameter
    $self->add_plugin('Foo', extra => 'args', for => 'Foo ctor');
    $self->add_plugin('Foo', { or => 'args', as => 'hashref' });

    # won't recognised name as second parameter
    $self->add_plugin('Foo', { with => 'hashref' }, and => 'named args');

Adds the details of a plugin to be included in the bundle. Call this from your C</configure_bundle> method.

=cut

method add_plugin($pkg, @payload) {
    my %payload;
    my $name;
    if(2 == @payload and 'HASH' eq ref $payload[1]) {
        $name    = shift @payload;
        %payload = %{ shift @payload };
    }
    if(1 == @payload % 2) {
        if('HASH' eq ref $payload[0]) {
            %payload = %{ shift @payload };
        }
        else {
            $name = shift @payload;
        }
    }
    %payload = ( %payload, @payload );
    if( exists $payload{name} ) {
        $name = delete $payload{name};
    }
    else {
        $name ||= $pkg;
    }
    $pkg = expand_config_package_name($pkg);
    push @{ $self->bundled_plugins_config }, [ $pkg, $name, [ %payload ] ];
}

requires 'configure_bundle';

method BUILD($args) {}

after 'BUILD' => method($args) { $self->configure_bundle };

1;
