use strict;
use warnings;

package App::Embra::PluginBundle::WrapZillaPlugin;

# ABSTRACT: wraps a Dist::Zilla plugin to work with App::Embra

use String::RewritePrefix;
use Method::Signatures;
use Moo;

=head1 DESCRIPTION

This bundle will add a L<Dist::Zilla> plugin to your site, and wrap it with C< L<App::Embra::Plugin::Zilla> >.

=cut

has 'plugin_name' => (
    is => 'lazy',
);

method _build_plugin_name {
    expand_dist_zilla_plugin_name( $self->name );
}

after 'BUILDARGS' => method( @args ) {
    my %args = @args;
    if( $args{name} eq ref $self ) {
        $self->warn('not given a Dist::Zilla plugin to wrap! Expect an error soon...');
    }
};

func expand_dist_zilla_plugin_name( $plugin_name ) {
    String::RewritePrefix->rewrite(
        {
          '=' => '',
          '@' => 'Dist::Zilla::PluginBundle::',
          ''  => 'Dist::Zilla::Plugin::',
        },
        $plugin_name,
    );
}

method configure_bundle {
    $self->add_plugin( $self->plugin_name,
        name => $self->name,
    );
    $self->add_plugin( 'Zilla',
        name => $self->plugin_name,
    );
}

with 'App::Embra::Role::PluginBundle';

1;
