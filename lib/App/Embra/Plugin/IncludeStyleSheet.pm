use strict;
use warnings;

package App::Embra::Plugin::IncludeStyleSheet;

# ABSTRACT: adds a CSS file to your site

use App::Embra::File;
use Moo;
use Method::Signatures;
use URI;

=head1 DESCRIPTION

This plugin will add the CSS file named in L</src> to your site. If C<src> is a URL, it will be linked to directly, and not included in the site.

=cut

=attr src

The source of the CSS file. Can be a path or a URL.

=cut

has 'src' => (
    is       => 'ro',
    required => 1,
    coerce   => func($val) { URI->new( $val ) },
);

has 'fragment' => (
    is => 'lazy',
);

method _build_fragment {
    my $src = $self->has_file ? $self->file->name : $self->src;
    return qq{<link rel="stylesheet" href="$src" />};
}

has 'clipboard' => (
    is      => 'ro',
    default => 'head',
);

with 'App::Embra::Role::Snippet';

has 'file' => (
    is        => 'lazy',
    predicate => 1,
    default   => method { App::Embra::File->new( name => $self->src ) },
);

method gather_files {
    if( not $self->src->has_recognized_scheme ) {
        $self->add_file( $self->file );
    }
}

with 'App::Embra::Role::FileGatherer';

1;
