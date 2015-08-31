use strict;
use warnings;

package App::Embra::Plugin::IncludeJavaScript;

# ABSTRACT: adds a JS file to your site

use Moo;
use Method::Signatures;

=head1 SYNOPSIS

    # embra.ini
    [IncludeJavaScript]
    src = js/local_file.js

    [IncludeJavaScript / Example.com datepicker]
    src = http://example.com/js/datepicker.js

=cut

=head1 DESCRIPTION

This plugin will add a L<snippet|App::Embra::Role::Snippet> to your site which links to the JavaScript file L<C<src>|/src>. If C<src> is a URL, it will be linked to directly; if it is a local file, it will be included in the site.

=cut

=attr src

Where to find the JavaScript file. Can be a path or a URL.

=cut

# hi I'm src I'm defined in App::Embra::Role::IncludeFromSrc

=attr fragment

The HTML fragment which links to the favicon. Set automatically & can't be changed. Required by L<App::Embra::Role::Snippet>.

=cut

# hi I'm fragment I'm defined in App::Embra::Role::Snippet

method _build_fragment { qq{<script src="${ \ $self->src }"></script>} }

=attr clipboard

Where the L<C<fragment>|/fragment> should end up in files in your site. Defaults to 'head'. Required by L<App::Embra::Role::Snippet>.

=cut

# hi I'm clipboard I'm defined in App::Embra::Role::Snippet

method _build_clipboard { 'body' }

with 'App::Embra::Role::Snippet';
with 'App::Embra::Role::IncludeFromSrc';

1;
