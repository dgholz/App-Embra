use strict;
use warnings;

package App::Embra;

# ABSTRACT: build-a-blog from parts

use Moo;
use Method::Signatures;

has 'plugins' => (
    is => 'ro',
    default => sub{[]},
);

method from_config_mvp_sequence( $class:, Config::MVP::Sequence :$sequence ) {
    my $root_section = $sequence->section_named( '_' );
    my $creatura = $class->new( $root_section->payload );
    for my $plugin_section ( $sequence->sections ) {
        next if $plugin_section == $root_section;
        $plugin_section->package->register_plugin(
            name => $plugin_section->name,
            args => $plugin_section->payload,
            embra => $creatura,
        );
    }
    $creatura;
}

method add_plugin( $plugin where { $_->DOES( "App::Embra::Role::Plugin" ) } ) {
    push @{ $self->plugins}, $plugin;
}

1;
