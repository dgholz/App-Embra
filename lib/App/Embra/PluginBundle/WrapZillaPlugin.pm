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

method BUILD( $unknown_ctor_args ) {
    if( $self->name eq ref $self ) {
        $self->warning('not given a Dist::Zilla plugin to wrap! Expect an error soon...');
    }
}

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

method add_dependency( @_ )  {
    if( $App::Embra::MODE // q{} eq 'deps' ) {
        $self->add_plugin( @_ );
    }
}

method configure_bundle {
    $self->add_plugin( 'Zilla',
        name => $self->name,
    );
    $self->add_dependency( q{=}.expand_dist_zilla_plugin_name( $self->name ) );
}

with 'App::Embra::Role::PluginBundle';

1;
