use strict;
use warnings;

package App::Embra::Plugin::WrapZillaPlugin;

# ABSTRACT: adapts a Dist::Zilla plugin to work with App::Embra

use Class::Inspector qw<>;
use Module::Runtime qw<>;
use Method::Signatures;
use Moo;

use App::Embra::Plugin::Zilla::WrapLog;

=head1 SYNOPSIS

    # embra.ini
    [WrapZillaPlugin / A::Dist::Zilla::Plugin]
    dist_zilla_plugin_option = this is passed through

    [WrapZillaPlugin / -ShortName::For::Plugin]
    passed_option = this goes to Dist::Zilla::Plugin::Shortname::For::Plugin

=cut

=head1 DESCRIPTION

This plugin wraps a L<Dist::Zilla plugin|Dist::Zilla::Role::Plugin> so it can use C< L<App::Embra> > as if it were C< L<Dist::Zilla> >. This allows you to use some C<Dist::Zilla> plugins when building your site. Set this plugin's C< L<name|App::Embra::Role::Plugin/name> > to the name of the module it should wrap.

You can pass options through to the wrapped plugin by setting them for this plugin. Any options not recognised by this plugin will be collected in C< L</plugin_args> >, and passed to the wrapped plugin.

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
    ( my $plugin_class = $self->name ) =~ s/^-/Dist::Zilla::Plugin::/xms;

    if( not Class::Inspector->loaded( $plugin_class ) ) {
        Module::Runtime::require_module $plugin_class;
    }

    return $plugin_class->new(
        zilla       => $self,
        plugin_name => $self->name,
        logger      => App::Embra::Plugin::Zilla::WrapLog->new(
            log_prefix => '['.$self->name.'] ',
            logger     => $self->logger,
        ),
        %{ $self->plugin_args },
    );
}

=attr plugin_args

The options for C< L</plugin> >. Defaults to the arguments passed to this class's constructor, except for C<embra>, C<name>, & C<plugin>.

=cut

has 'plugin_args' => (
    is => 'ro',
    default => func { {} },
);

method BUILDARGS( @args ) {
    my %args = @args;
    my %attrs;
    for my $attr ( qw< embra name plugin > ) {
        if( exists $args{$attr} ) {
            $attrs{$attr} = delete $args{$attr};
        }
    }

    return { %attrs, plugin_args => \%args };
}

=method isa

    $self->isa('Dist::Zilla'); # true

Extends C<isa> to return true if asked if C<$self> isa C<Dist::Zilla>.

=cut

around 'isa' => func ( $orig, $self, $class ) {
    return $class eq 'Dist::Zilla' || $orig->($self, $class); # cheeky
};

=method publish_site

    $self->publish_site();

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

=method extra_list_deps

Required by L<App::Embra::Role::ExtraListDeps>. Adds the wrapped plugin as an extra requirement to show when C< L<embra listdeps|App::Embra::Command::listdeps> > is run.

=cut

method extra_list_deps($class:, HashRef :$config) {
    ( my $plugin_class = $config->{_name} ) =~ s/^-/Dist::Zilla::Plugin::/xms;
    return $plugin_class;
}

with 'App::Embra::Role::ExtraListDeps';

=attr embra

The instance of L<App::Embra> which is building the site. This is provided by L<App::Embra::Role::Plugin>, and we amend it to delegate calls to C<files> to it.

=cut

has '+embra' => (
    is => 'ro',
    required => 1,
    handles => [ qw< files > ],
);

=attr name

The module to construct C< L</plugin> > from. As a shorthand, when C<plugin> is created, it will replace a leading C<-> in C<name> with C<Dist::Zilla::Plugin::>.

=cut

# hi im name im declared in App::Embra::Role::Plugin

1;
