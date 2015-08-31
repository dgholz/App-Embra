use strict;
use warnings;

package App::Embra::PluginBundle::Bootstrap;

# ABSTRACT: adds the Bootstrap CSS & JS to your site

use Method::Signatures;

use Moo;

=head1 DESCRIPTION

This bundle will add links to a precompiled version of L<Bootstrap|http://getbootstrap.com/> to your site.

=cut

=attr version

Which version of Bootstrap to use. Defaults to C<3.3.2>.

=cut

has 'version' => (
    is      => 'ro',
    default => '3.3.2',
);

method configure_bundle {
    $self->add_plugin( 'IncludeStyleSheet',
        name => 'Bootstrap CSS',
        src  => "https://maxcdn.bootstrapcdn.com/bootstrap/${ \ $self->version }/css/bootstrap.min.css",
    );
    $self->add_plugin( 'IncludeStyleSheet',
        name => 'Bootstrap theme',
        src  => "https://maxcdn.bootstrapcdn.com/bootstrap/${ \ $self->version }/css/bootstrap-theme.min.css",
    );
    $self->add_plugin( 'IncludeJavaScript',
        name => 'Bootstrap JS',
        src  => "https://maxcdn.bootstrapcdn.com/bootstrap/${ \ $self->version }/js/bootstrap.min.js",
    );
}

with 'App::Embra::Role::PluginBundle';

1;
