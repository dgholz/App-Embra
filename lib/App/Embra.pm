use strict;
use warnings;

package App::Embra;

# ABSTRACT: build a site from parts

use Method::Signatures;
use Moo;

=head1 DESCRIPTION

App::Embra collates your content into a static website. This class stores the steps necessary to build your site, and can execute them.

=cut

method _build_log_prefix { "[Embra] " }

with 'App::Embra::Role::Logging';

=attr plugins

The objects which will help you build your site. An array reference of objects which implement L<App::Embra::Role::Plugin>.

=cut

has 'plugins' => (
    is => 'ro',
    default => method { [] },
);

=attr files

Your site content. An array reference of L<App::Embra::File> instances. Plugins add, remove, read, and alter files via this attribute.

=cut

has 'files' => (
    is => 'ro',
    default => method { [] },
);

=method from_config_mvp_sequence

    my $embra = App::Embra->from_config_mvp_sequence( $sequence );

Returns a new C<App::Embra> with its attributes & plugins taken from a L<Config::MVP::Sequence>. Called by the L<command-line base class|App::Embra::App::Command> whenever L<embra> is run.

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

Adds a plugin to C<L</plugins>>. C<$plugin> must implement L<App::Embra::Role::Plugin>.

=cut

# UNIVERSAL::DOES works on non-refs, Moo->does does not
method add_plugin( $plugin where { $_->DOES( "App::Embra::Role::Plugin" ) } ) {
    push @{ $self->plugins }, $plugin;
}

=method find_plugin

    my $plugin = $embra->find_plugin( $package );

Returns the first plugin in C<L</plugins>> whose package name is C<$package>. Returns an empty list if no plugin is found.

=cut

method find_plugin( $package ) {
    # this is a slice, since it's a subscript of a list, not a scalar
    # so returns empty list when [0] doesn't exist
    ( grep { ref $_ eq $package } @{ $self->plugins } )[0];
}

=method collate

    $embra->collate;

Assembles your site. For each of these methods:

=for :list
* C<L<gather_files|App::Embra::Role::FileGatherer>>
* C<L<prune_files|App::Embra::Role::FilePruner>>
* C<L<transform_files|App::Embra::Role::FileTransformer>>
* C<L<assemble_files|App::Embra::Role::FileAssembler>>
* C<L<publish_site|App::Embra::Role::SitePublisher>>

call the method on elements of C<L</plugins>> which consume the linked role.

=cut

method collate {
    $self->debug( 'collating' );
    $_->gather_files    for $self->plugins_with( -FileGatherer );
    $_->prune_files     for $self->plugins_with( -FilePruner );
    $_->transform_files for $self->plugins_with( -FileTransformer );
    $_->assemble_files  for $self->plugins_with( -FileAssembler );
    $_->publish_site    for $self->plugins_with( -SitePublisher );
}

=method plugins_with

    say for $embra->plugins_with( $rolename );

Returns all elements of C<L</plugins>> which implement C<$rolename>. Role names should be fully specified; as a shorthand, you can pass C<< -<relative_role_name> >> and it will be treated as if you had specified C<< App::Embra::Role::<relative_role_name> >>.

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
