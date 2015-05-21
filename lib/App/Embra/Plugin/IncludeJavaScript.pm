use strict;
use warnings;

package App::Embra::Plugin::IncludeJavaScript;

# ABSTRACT: adds a JS file to your site

use Moo;
use Method::Signatures;

=head1 DESCRIPTION

This plugin will add a L<snippet|App::Embra::Role::Snippet> to your site which links to the JavaScript file L<C<src>|/src>. If C<src> is a URL, it will be linked to directly; if it is a local file, it will be included in the site.

=cut

=attr src

Where to find the JavaScript file. Can be a path or a URL.

=cut

# hi I'm src I'm defined in App::Embra::Role::IncludeFromSrc

has 'fragment' => (
    is => 'lazy',
);

method _build_fragment { qq{<script src="${ \ $self->src }"></script>} }

has 'clipboard' => (
    is      => 'ro',
    default => 'body',
);

with 'App::Embra::Role::Snippet';
with 'App::Embra::Role::IncludeFromSrc';

1;
