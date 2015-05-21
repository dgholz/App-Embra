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

The source for the file. Can be a path or a URL. If the former, it will be a L<App::Embra::File>; if the latter, a L<URI>.

=cut

has 'src' => (
    is       => 'ro',
    required => 1,
    alias    => [ qw< href > ],
    coerce   => func($val) {
                   my $v = URI->new( $val );
                   return $v->has_recognized_scheme ? $v
                                                    : App::Embra::File->new( $val );
                },
    builder  => 1,
);

=attr href

An alias for C<src>.

=cut

method gather_files {}

around 'gather_files' => func( $orig, $self ) {
    if( $self->src->DOES('App::Embra::File') ) {
        $self->add_file( $self->src );
    }
};

with 'App::Embra::Role::FileGatherer';

1;
