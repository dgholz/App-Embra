use strict;
use warnings;

package App::Embra::Plugin::WrapZillaPlugin;

# ABSTRACT: adapts a Dist::Zilla plugin to work with App::Embra

use Class::Inspector qw<>;
use Module::Runtime qw<>;
use Method::Signatures;

use App::Embra::Plugin::Zilla::WrapLog;
use Moo;

=head1 DESCRIPTION

This plugin fools something which does L<Dist::Zilla::Role::Plugin> into treating a L<App::Embra> as if it were a L<Dist::Zilla>. Not all Dist::Zilla plugin roles are supported!

=cut

=attr plugin

This is a L<Dist::Zilla> plugin adapted to work on L<App::Embra>;

=cut

has 'plugin' => (
    is => 'lazy',
    isa => func( $plugin ) {
        die q{can't wrap something that isn't a Dist::Zilla plugin!}
            if not $plugin->does( 'Dist::Zilla::Role::Plugin' );
    },
);

has 'plugin_args' => (
    is => 'ro',
    default => func { {} },
);

around 'isa' => func ( $orig, $self, $class ) {
    return $class eq 'Dist::Zilla' or $orig->($self, $class); # cheeky
};

method _build_plugin {
    ( my $plugin_class = $self->name ) =~ s/^-/Dist::Zilla::Plugin::/xms;

    if( not Class::Inspector->loaded( $plugin_class ) ) {
        Module::Runtime::require_module $plugin_class;
    }

    return $plugin_class->new(
        zilla => $self,
        plugin_name => $self->name,
        logger => App::Embra::Plugin::Zilla::WrapLog->new(
            proxy_prefix => '['.$self->name.'] ',
            logger => $self->embra->logger,
        ),
        %{ $self->plugin_args },
    );
}

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

method extra_list_deps($class:, HashRef :$config) {
    ( my $plugin_class = $config->{_name} ) =~ s/^-/Dist::Zilla::Plugin::/xms;
    return $plugin_class;
}

with 'App::Embra::Role::SitePublisher';
with 'App::Embra::Role::ExtraListDeps';

has '+embra' => (
    is => 'ro',
    required => 1,
    handles => [ qw< files > ],
);

1;
