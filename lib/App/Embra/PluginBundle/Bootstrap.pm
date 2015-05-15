use strict;
use warnings;

package App::Embra::PluginBundle::Bootstrap;

# ABSTRACT: adds the Bootstrap CSS & JS to your site

use Method::Signatures;

use Moo;

=head1 DESCRIPTION

This bundle will add a precompiled version of L<Bootstrap|http://getbootstrap.com/> to your site.

=cut

method configure_bundle {
    $self->add_plugin( 'IncludeStyleSheet',
        name => 'Bootstrap CSS',
        src => 'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css',
    );
    $self->add_plugin( 'IncludeStyleSheet',
        name => 'Bootstrap theme',
        src => 'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css',
    );
    $self->add_plugin( 'IncludeJavaScript',
        name => 'Bootstrap JS',
        src => 'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js',
    );
}

with 'App::Embra::Role::PluginBundle';

1;
