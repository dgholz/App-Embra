use strict;
use warnings;

package App::Embra;

# ABSTRACT: build a site from parts

use Moo;
use Method::Signatures;

=head1 DESCRIPTION

App::Embra collates your content into a static website.

=cut

with 'App::Embra::Role::Logging';

around '_build_log_prefix' => func( $orig, $self ) {
    return "[Embra] ";
};

around '_build_logger' => func( $orig, $self ) {
    return Log::Any->get_logger;
};

=attr plugins

The objects which will help you build your site. An array reference of objects which implement L<App::Embra::Role::Plugin>.

=cut

has 'plugins' => (
    is => 'ro',
    default => sub{[]},
);

=attr files

Your site content. An array reference of L<App::Embra::File> instances. Plugins add, remove, read, and alter files via this attribute.

=cut

has 'files' => (
    is => 'ro',
    default => sub{[]},
);

=method from_config_mvp_sequence

    my $embra = App::Embra->from_config_mvp_sequence( $sequence );

Returns a new instance with its initial attributes set from an instance of L<Config::MVP::Sequence>. Called by the L<command-line base class|App::Embra::App::Command> whenever the L<embra> is run.

=cut

method from_config_mvp_sequence( $class:, Config::MVP::Sequence :$sequence ) {
    my $payload = {};
    if ( my $root_section = $sequence->section_named( '_' ) ) {
        $payload = $root_section->payload;
    }
    my $creatura = $class->new( $payload );
    for my $plugin_section ( $sequence->sections ) {
        next if $plugin_section->name eq '_';
        $plugin_section->package->register_plugin(
            name => $plugin_section->name,
            args => $plugin_section->payload,
            embra => $creatura,
        );
    }
    $creatura;
}

=method add_plugin

    $embra->add_plugin( $plugin );

Adds a plugin to L<C</plugins>>. C<$plugin> must implement L<App::Embra::Role::Plugin>.

=cut

method add_plugin( $plugin where { $_->DOES( "App::Embra::Role::Plugin" ) } ) {
    push @{ $self->plugins}, $plugin;
}

=method collate

    $embra->collate;

Assembles your site. Plugins are called in this order:

=for :list
* gather
* prune
* transform
* assemble
* publish

For each of the types, all plugins which implement C<< App::Embra::Role::File<Type> >> have their C<< <type>_files> >> method called, in ths same order as they appear in L<C</plugins>>.

=cut

method collate {
    $self->debug( 'collating' );
    $_->gather_files    for $self->plugins_with( -FileGatherer );
    $_->prune_files     for $self->plugins_with( -FilePruner );
    $_->transform_files for $self->plugins_with( -FileTransformer );
    $_->assemble_files  for $self->plugins_with( -FileAssembler );
    $_->publish_files   for $self->plugins_with( -FilePublisher );
}

=method plugins_with

    say for $embra->plugins_with(  $rolename );

Returns all elements of L<C</plugins>> which implement C<$rolename>. Role names should be fully specified; as a shorthand, you can pass C<<-<relative_role_name> >> and it will be treated as if you had specified C<< App::Embra::Role::<relative_role_name> >>.

=cut

method plugins_with( $rolename ) {
  $rolename =~ s/^-/App::Embra::Role::/xms;
  return grep { $_->does( $rolename ) } @{ $self->plugins };
}

=head1 SEE ALSO

=for :list
* L<Blio>
* L<jekyll|http://jekyllrb.com/>
* L<Octopress|https://github.com/imathis/octopress#readme>

=cut

1;
