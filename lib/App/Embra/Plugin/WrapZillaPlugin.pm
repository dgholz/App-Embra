use strict;
use warnings;

package App::Embra::Plugin::WrapZillaPlugin;

# ABSTRACT: adapts a Dist::Zilla plugin to work with App::Embra

use Class::Inspector qw<>;
use Module::Runtime qw<>;
use Method::Signatures;

use App::Embra::Plugin::Zilla;
use App::Embra::Plugin::Zilla::WrapLog;
use Moo;

=head1 DESCRIPTION

This plugin fools something which does L<Dist::Zilla::Role::Plugin> into treating a L<App::Embra> as if it were a L<Dist::Zilla>. Not all Dist::Zilla plugin roles are supported!

=cut

=attr plugin

This is the name of a L<Dist::Zilla> plugin adapted to work on L<App::Embra>;

=cut

has 'plugin' => (
    is => 'ro',
    required => 1,
);

func find_zilla( App::Embra $embra ) {
    my $zilla_class = 'App::Embra::Plugin::Zilla';
    my $zilla = $embra->find_plugin( $zilla_class );
    if ( ! $zilla ) {
        $zilla = $zilla_class->register_plugin( embra => $embra, name => $zilla_class );
    }
    return $zilla;
}

method BUILDARGS( @args ) {
    my %args = @args;
    my $embra = delete $args{embra};
    my $name = delete $args{name};
    die q{must have a plugin to wrap!} if not defined $name;
    ( my $plugin_class = $name ) =~ s/^-/Dist::Zilla::Plugin::/xms;

    if( not Class::Inspector->loaded( $plugin_class ) ) {
        Module::Runtime::require_module $plugin_class;
    }

    die q{can't wrap something that isn't a Dist::Zilla plugin} if not $plugin_class->does( 'Dist::Zilla::Role::Plugin' );
    my $plugin = $plugin_class->new(
        zilla => find_zilla( $embra ),
        plugin_name => $name,
        logger => App::Embra::Plugin::Zilla::WrapLog->new( proxy_prefix => "[$name] ", logger => $embra->logger ),
        %args
    );

    return { embra => $embra, plugin => $plugin };
}

method publish_site {
    my @wraps = (
        [ '-AfterBuild' => func( $plugin ) { $plugin->after_build({ build_root => q<.> } ) } ],
        [ '-BeforeRelease' => func( $plugin ) { $plugin->before_release() } ],
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

method extra_list_deps($class:, HashRef :$config) {
    ( my $plugin_class = $config->{_name} ) =~ s/^-/Dist::Zilla::Plugin::/xms;
    return $plugin_class;
}

with 'App::Embra::Role::SitePublisher';
with 'App::Embra::Role::ExtraListDeps';

1;
