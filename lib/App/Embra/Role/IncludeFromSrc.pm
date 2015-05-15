use strict;
use warnings;

package App::Embra::Role::IncludeFromSrc;

# ABSTRACT: something which adds a local or remote file to your site

use App::Embra::File;
use Moo::Role;
use Method::Signatures;
use URI;

=head1 DESCRIPTION

This role provides a L</src> and L</file> attribute to its consumer, and augments L</gather_files> to add the local files to your site.

=cut

=attr src

The source for the file. Can be a path or a URL.

=cut

has 'src' => (
    is       => 'ro',
    required => 1,
    coerce   => func($val) { URI->new( $val ) },
);

has 'file' => (
    is        => 'lazy',
    predicate => 1,
    default   => method { App::Embra::File->new( name => $self->src ) },
);

method gather_files {}

around 'gather_files' => func( $orig, $self ) {
    if( not $self->src->has_recognized_scheme ) {
        $self->add_file( $self->file );
    }
};

with 'App::Embra::Role::FileGatherer';

1;
