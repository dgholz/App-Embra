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

method collate {
    $_->gather_files    for $self->plugins_with( -FileGatherer );
    $_->transform_files for $self->plugins_with( -FileTransformer );
    $_->render_files    for $self->plugins_with( -FileRenderer );
    $_->publish_files   for $self->plugins_with( -FilePublisher );
}

method plugins_with( $rolename ) {
  $rolename =~ s/^-/App::Embra::Role::/xms;
  return grep { $_->does( $rolename ) } @{ $self->plugins };
}

1;
