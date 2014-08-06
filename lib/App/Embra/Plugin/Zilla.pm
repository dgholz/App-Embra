use strict;
use warnings;

package App::Embra::Plugin::Zilla;

# ABSTRACT: adapts a Dist::Zilla plugin to work with App::Embra

use Moo;
use Method::Signatures;

=head1 DESCRIPTION

This plugin fools something which does L<Dist::Zilla::Role::Plugin> into treating a L<App::Embra> as if it were a L<Dist::Zilla>. Not all Dist::Zilla plugin roles are supported!

=cut

=attr wrapped_plugin

This is a L<Dist::Zilla> plugin to adapt to work on L<App::Embra>;

=cut

has 'plugin' => (
    is => 'ro',
    required => 1,
);

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
