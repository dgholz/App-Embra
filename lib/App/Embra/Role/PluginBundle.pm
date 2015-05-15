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

=attr name

The name of this plugin. Defaults to the name of the package.

=cut

has 'name' => (
    is => 'ro',
    default => method { ref $self },
);

=attr bundled_plugins

A list of plugins to be included. Each element should be an arrayref of:

    [ $plugin_name, $package_args [ @plugin_args ] ]

where C<$plugin_name> is the name attribute for the plugin, C<$package_name> is the plugin's package, and C<@plugin_args> will be passed to the plugin's constructor.

The helper method L<C<add_plugin>|/add_plugin> provides a flexible way to populate this list.

=cut

has 'bundled_plugins' => (
    is => 'ro',
    default => method { [] },
);

=method bundled_plugins_config

    $class->bundled_plugins_config( { $name, $pkg, [ $args ] } );

Constructs an instance of the composing class and returns the L<C<bundled_plugins>|/bundled_plugins>.

=cut

method bundled_plugins_config($class:, $args) {
    my( $name, $pkg, $ctor_args ) = @{ $args }{ qw< name package payload >};
    my $bun = $class->new(name => $name, %{$ctor_args});
    $bun->configure_bundle;
    return @{ $bun->bundled_plugins };
}

=method add_plugin

    add_plugin($pkg, @payload);
    add_plugin($pkg, $name, @payload);
    add_plugin($pkg, $name, HashRef $payload);
    add_plugin($pkg, HashRef $payload, @payload);

    $self->add_plugin('Foo');
    $self->add_plugin('Foo', name => 'Foo with special name');
    $self->add_plugin('Foo', { name => 'Foo with special name' });

    # also recognise name as second parameter
    $self->add_plugin('Foo', 'Foo with special name');
    $self->add_plugin('Foo', 'Foo with name', extra => 'args', for => 'Foo ctor');
    $self->add_plugin('Foo', 'Foo with another name', { or => 'args', as => 'hashref' });

    # won't recognise name as second parameter if @payload and $payload passed
    $self->add_plugin('Foo', 'Foo no name', { with => 'hashref' }, and => 'named args'); # ✘
    $self->add_plugin('Foo', { with => 'hashref', name => 'Foo hashref name' }, and => 'named args'); # ✔
    $self->add_plugin('Foo', { with => 'hashref' }, and => 'named args', name => 'Foo param name'); # ✔

Adds the details of a plugin to be included in the bundle. Call this from your L</configure_bundle> method.

C<$pkg> will be expanded into a fully-qualified package by L<App::Embra::Util/expand_config_package_name>. C<$name> defaults to the value of the C<name> key in C<$payload> or C<@payload>, then the unexpanded value of C<$pkg>.

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
    push @{ $self->bundled_plugins }, [ $name, $pkg, [ %payload ] ];
}

requires 'configure_bundle';

1;
