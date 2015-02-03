use strict;
use warnings;

package App::Embra::Role::Snippet;

# ABSTRACT: an HTML fragment to be inserted into some pages of your site

use Method::Signatures;
use Moo::Role;

=head1 DESCRIPTION

This role provides a few key methods and attributes to add fragments of HTML to pages in your site.

=cut

=attr fragment

The HTML to insert into a page.

=cut

has 'fragment' => (
    is => 'ro',
    default => '',
);

=attr clipboard

Where the fragment belongs.

=cut

has 'clipboard' => (
    is => 'ro',
    default => '',
);

1;
