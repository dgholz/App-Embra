use strict;
use warnings;

package App::Embra::Plugin::Snippet;

# ABSTRACT: declare some HTML which files can include

use Method::Signatures;

use Moo;

=head1 DESCRIPTION

This plugin will save a fragment of text, and a clipboard name which other plugins can use to retrieve the text.

=cut

=head1 EXAMPLE

    # embra.ini
    [Snippet]
    fragment = <link rel="stylesheet" src="my_cool_style.css">
    clipboard = head

    [Snippet / hidden_comment]
    fragment = <!-- fnord --!>
    clipboard = body

    [SnippetsToNotes]
    [Template::Basic] # or other template that recognises the 'head' and 'body' clipboards

=cut

=attr fragment

HTML to be made available for other plugins to insert.

=cut

=attr clipboard

The name other plugins should use to find this fragment. The value can be any string, so please check with the template you are using to see which clipboard values it recognises. E.g. the L<Template::Basic|App::Embra::Plugin::Template::Basic> plugin will insert snippets in the C<head> clipboard into the C<< <head> >> element of its templates.

=cut

with 'App::Embra::Role::Snippet';

1;
