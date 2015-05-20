use strict;
use warnings;

package App::Embra::Role::IncludeFromSrc;

# ABSTRACT: something which adds a local or remote file to your site

use App::Embra::File;
use Moo::Role;
use MooX::Aliases;
use Method::Signatures;
use URI;

=head1 DESCRIPTION

This role provides a L</src> and L</file> attribute to its consumer, and augments L</gather_files> to add C<file> to your site (if it is local).

=cut

=attr src

The source for the file. Can be a path or a URL. The attribute is coerced into a L<URI>.

=cut

has 'src' => (
    is       => 'ro',
    required => 1,
    alias    => [ qw< href > ],
    coerce   => func($val) { URI->new( $val ) },
    builder  => 1,
);

has 'file' => (
    is        => 'lazy',
    predicate => 1,
    default   => method { App::Embra::File->new( name => $self->src ) },
);

=attr href

An alias for C<src>.

=cut

method gather_files {}

around 'gather_files' => func( $orig, $self ) {
    if( not $self->src->has_recognized_scheme ) {
        $self->add_file( $self->file );
    }
};

with 'App::Embra::Role::FileGatherer';

1;
