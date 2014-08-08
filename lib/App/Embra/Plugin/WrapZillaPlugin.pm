use strict;
use warnings;

package App::Embra::Plugin::WrapZillaPlugin;

# ABSTRACT: adapts a Dist::Zilla plugin to work with App::Embra

use Moo;
use Method::Signatures;
use App::Embra::Plugin::Zilla;

=head1 DESCRIPTION

This plugin fools something which does L<Dist::Zilla::Role::Plugin> into treating a L<App::Embra> as if it were a L<Dist::Zilla>. Not all Dist::Zilla plugin roles are supported!

=cut

=attr plugin

This is a L<Dist::Zilla> plugin adapted to work on L<App::Embra>;

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
    die q{can't wrap something that isn't a Dist::Zilla plugin} if not $plugin_class->does( 'Dist::Zilla::Role::Plugin' );
    my $plugin = $plugin_class->new( zilla => find_zilla( $embra ), plugin_name => $name, %args );

    return { embra => $embra, plugin => $plugin };
}

method publish_site {
    my @wraps = ( [ '-BeforeRelease' => func( $plugin ) { $plugin->before_release() } ] );
    for my $wrap ( @wraps ) {
        my( $role, $shim ) = @{ $wrap };
        $role =~ s/^-/Dist::Zilla::Role::/xms;
        if( $self->plugin->does( $role ) ) {
            $shim->( $self->plugin );
        }
    }
}

with 'App::Embra::Role::SitePublisher';

1;
