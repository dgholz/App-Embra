use strict;
use warnings;

package App::Embra::Plugin::Zilla;

# ABSTRACT: adapts a Dist::Zilla plugin to work with App::Embra

use Class::Inspector qw<>;
use Module::Runtime qw<>;
use String::RewritePrefix;
use Method::Signatures;
use Moo;

use App::Embra::Plugin::Zilla::WrapLog;
use App::Embra::PluginBundle::WrapZillaPlugin;

=head1 SYNOPSIS

    # embra.ini
    [Zilla / =Dist::Zilla::Plugin]
    dist_zilla_plugin_option = this is passed through to D::Z::P

    [Zilla / ShortName::For::Plugin]
    passed_option = this goes to Dist::Zilla::Plugin::Shortname::For::Plugin

=cut

=head1 DESCRIPTION

This wraps something which does L<Dist::Zilla::Role::Plugin> so it can treat an L<App::Embra> as if it were a L<Dist::Zilla>. Not all Dist::Zilla plugin roles are supported!

You can then use some C<Dist::Zilla> plugins when building your site. Set this plugin's C< L<name|App::Embra::Role::Plugin/name> > to the name of the module it should wrap.

This plugin will save any unrecognised constructor arguments in C< L</payload> >, and use them as the arguments for the constructor of the wrapped plugin.

The plugin maps L<App::Embra::Role::PublishSite> to some C<Dist::Zilla> roles in C< L</publish_files> >.

=cut

=attr plugin

This is the L<Dist::Zilla> plugin to be wrapped. It is an instance of the module given in C< L</name> >, and is constructed using C< L</plugins_args> > as its arguments.

=cut

has 'plugin' => (
    is => 'lazy',
    isa => func( $plugin ) {
        die q{can't wrap something that isn't a Dist::Zilla plugin!}
            if not $plugin->does( 'Dist::Zilla::Role::Plugin' );
    },
);

method _build_plugin {

    my $dzil_pkg = $self->_dzil_pkg;
    if( not Class::Inspector->loaded( $dzil_pkg ) ) {
        Module::Runtime::require_module $dzil_pkg;
    }

    return $dzil_pkg->new(
        zilla       => $self,
        plugin_name => $self->name,
        logger => App::Embra::Plugin::Zilla::WrapLog->new(
            logger => $self,
        ),
        %{ $self->payload },
    );
}

=attr payload

The options for C< L</plugin> >. This will collect any arguments not recognised by the constructor (i.e. C<embra>, C<name>, & C<plugin>), and pass them to the wrapped plugin's constructor (via L<App::Embra::Plugin::Zilla>). Defaults to an empty hashref.

=cut

has 'payload' => (
    is => 'ro',
    default => method { {} },
);

method BUILD( $unknown_ctor_args ) {
    @{ $self->payload }{keys %{ $unknown_ctor_args }} = values %{ $unknown_ctor_args };
}

=method isa

    $self->isa('Dist::Zilla'); # true

Extends C<isa> to return true if asked if C<$self> isa C<Dist::Zilla>.

=cut

around 'isa' => func ( $orig, $self, $class ) {
    return $class eq 'Dist::Zilla' || $orig->($self, $class); # cheeky
};

=method publish_site

    $self->publish_site;

Calls the appropriate method on the C< L</plugin> >, if it consumes L<Dist::Zilla::Role::AfterBuild> or L<Dist::Zilla::Role::BeforeRelease>.

=cut

method publish_site {
    my @wraps = (
        [ '-AfterBuild'    => func( $plugin ) { $plugin->after_build({ build_root => q<.> }) } ],
        [ '-BeforeRelease' => func( $plugin ) { $plugin->before_release()                    } ],
    );
    for my $wrap ( @wraps ) {
        my( $role, $shim ) = @{ $wrap };
        $role =~ s/^-/Dist::Zilla::Role::/xms;
        if( $self->plugin->does( $role ) ) {
            local *Dist::Zilla::VERSION = method { 4 }; # App::Embra::File->content, not ->encoded_content
            $shim->( $self->plugin );
        }
    }
}

with 'App::Embra::Role::SitePublisher';

=attr embra

The instance of L<App::Embra> which is building the site. This is provided by L<App::Embra::Role::Plugin>, and we amend it to delegate calls to C<files> to it.

=cut

has '+embra' => (
    is => 'ro',
    required => 1,
    handles => [ qw< files > ],
);

=attr name

The name of the C<Dist::Zilla> package to use to construct C< L</plugin> >.

=cut

# hi im name im declared in App::Embra::Role::Plugin

=attr _dzil_pkg

The full package name of the wrapped Dist::Zilla plugin. Set to the L<C<name>|/name> of this plugin, prefixed by C<Dist::Zilla::Plugin::>. If the first charater of the C<name> is <=>, it is stripped and used verbatim.

=cut

has '_dzil_pkg' => (
    is => 'lazy',
);

method _build__dzil_pkg {
    App::Embra::PluginBundle::WrapZillaPlugin::expand_dist_zilla_plugin_name( $self->name );
}

1;
