use strict;
use warnings;

package App::Embra::Plugin::Favicon;

# ABSTRACT: adds a favicon

use Moo;
use Method::Signatures;

=head1 DESCRIPTION

This plugin will add the HTML to the site to include a favicon. You must add the file separately, and then pass the filename to this plugin.

=cut

=attr filename

The name of the favicon. Defaults to F<favicon.ico>.

=cut

has 'filename' => (
    is => 'ro',
    default => sub{ 'favicon.ico' },
);

has 'fragment' => (
    is => 'ro',
    default => method { qq{<link rel="icon" type="image/x-icon" href="$self->filename">} },
    init_arg => undef,
);

has 'clipboard' => (
    is => 'ro',
    default => 'head',
    init_arg => undef,
);

with 'App::Embra::Role::Snippet';

method gather_files {
    $self->add_file( App::Embra::File->new( name => $self->filename ) );
}

with 'App::Embra::Role::FileGatherer';

1;
