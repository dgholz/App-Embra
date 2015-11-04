use strict;
use warnings;

package App::Embra::Plugin::Snippet;

# ABSTRACT: a fragment of content to be inserted into files

use Method::Signatures;
use Moo;

=head1 SYNOPSIS

In your F<embra.ini>:

    [Snippet]
    fragment = <link rel="alternate" type="application/atom+xml" title="My Weblog feed" href="/feed/" />
    clipboard = head

    [Snippet / hidden_comment]
    fragment = <!-- fnord --!>
    clipboard = body


    [SnippetsToNotes]

    [Template::Basic] # or other template that recognises the 'head' and 'body' clipboards

=cut

=head1 DESCRIPTION

This plugin will save some content, and identify where that content should be inserted.

=cut

=attr fragment

Content for other plugins to read.

=cut

# hi I'm fragment I'm defined in App::Embra::Role::Snippet

method _build_fragment {}

=attr clipboard

The name other plugins should use to find this fragment. The value can be any string, so please check with the template you are using to see which clipboard values it recognises. E.g. the L<Template::Basic|App::Embra::Plugin::Template::Basic> plugin will insert snippets in the C<head> clipboard into the C<< <head> >> element of its templates.

=cut

# hi I'm clipboard I'm defined in App::Embra::Role::Snippet

method _build_clipboard {}

with 'App::Embra::Role::Snippet';

1;
