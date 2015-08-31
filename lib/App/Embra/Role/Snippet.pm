use strict;
use warnings;

package App::Embra::Role::Snippet;

# ABSTRACT: something which wants to insert a fragment of content into files

use Method::Signatures;
use Moo::Role;

=head1 DESCRIPTION

This lets the consumer provide a L</fragment> of content which they want to be included in all files in your site. It also lets them say L<where the fragment should be inserted|/clipboard>.

This doesn't insert the content into the files--something else mush examine the list of plugins for snippets, and add them to the files in your site.

=cut

=attr fragment

The content to insert into a file.

=cut

has 'fragment' => (
    is => 'lazy',
);

requires '_build_fragment';

=attr clipboard

Where the content should be inserted. This will be used by whatever actually inserts the fragment.

=cut

has 'clipboard' => (
    is => 'lazy',
);

requires '_build_clipboard';

1;
