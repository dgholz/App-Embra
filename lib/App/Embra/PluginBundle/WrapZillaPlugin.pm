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

=attr payload

The options for C< L</plugin> >. This will collect any arguments not recognised by the constructor (i.e. C<embra>, C<name>, & C<plugin>), and pass them to the wrapped plugin's constructor (via L<App::Embra::Plugin::Zilla>). Defaults to an empty hashref.

=cut

has 'payload' => (
    is => 'ro',
    default => method { {} },
);

method BUILD( $unknown_ctor_args ) {
    if( $self->name eq ref $self ) {
        $self->warning('not given a Dist::Zilla plugin to wrap! Expect an error soon...');
    }
    # ugh
    @{ $self->payload }{keys %{ $unknown_ctor_args }} = values %{ $unknown_ctor_args };
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
        %{ $self->payload },
        name    => $self->name,
    );
    $self->add_dependency( q{=}.expand_dist_zilla_plugin_name( $self->name ) );
}

with 'App::Embra::Role::PluginBundle';

1;
