use strict;
use warnings;

package App::Embra::Plugin::IncludeJavaScript;

# ABSTRACT: adds a JS file to your site

use App::Embra::File;
use Moo;
use Method::Signatures;
use URI;

=head1 DESCRIPTION

This plugin will add the JS file named in L</src> to your site. If C<src> is a URL, it will be linked to directly, and not included in the site.

=cut

=attr src

The source of the JS file. Can be a path or a URL.

=cut

has 'fragment' => (
    is => 'lazy',
);

method _build_fragment {
    my $src = $self->has_file ? $self->file->name : $self->src;
    return qq{<script src="$src"></script>};
}

has 'clipboard' => (
    is      => 'ro',
    default => 'body',
);

with 'App::Embra::Role::Snippet';
with 'App::Embra::Role::IncludeFromSrc';

1;
