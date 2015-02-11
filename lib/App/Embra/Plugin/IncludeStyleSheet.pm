use strict;
use warnings;

package App::Embra::Plugin::IncludeStyleSheet;

# ABSTRACT: adds a CSS file to your site

use App::Embra::File;
use Moo;
use Method::Signatures;

=head1 DESCRIPTION

This plugin will add the CSS file named in L</src> to your site.

=cut

=attr src

The source of the CSS file. Can be a path or a URL.

=cut

has 'src' => (
    is       => 'ro',
    required => 1,
);

has 'fragment' => (
    is      => 'lazy',
    default => method { qq{<link rel="stylesheet" href="${ \ $self->file->name }" />} },
);

has 'clipboard' => (
    is => 'ro',
    default => 'head',
);

with 'App::Embra::Role::Snippet';

has 'file' => (
    is      => 'lazy',
    default => method { App::Embra::File->new( name => $self->src ) },
);

method gather_files {
    $self->add_file( $self->file );
}

with 'App::Embra::Role::FileGatherer';

1;
