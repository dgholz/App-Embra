use strict;
use warnings;

package App::Embra::Plugin::Favicon;

# ABSTRACT: adds a favicon

use Moo;
use Method::Signatures;

=head1 SYNOPSIS

    # embra.ini
    [Favicon]
    src = my_cool_fav.ico

=cut

=head1 DESCRIPTION

This plugin creates a favicon L<snippet|App::Embra::Role::Snippet>, suitable for inserting into the HTML files of your site. It doesn't add the snippet to your HTML files; include L<C<[SnippetsToNotes]>|App::Embra::Plugin::SnippetsToNotes> & a snippet-aware template (like L<C<[Template::Basic]>|App::Embra::Plugin::Template::Basic>) in your F<embra.ini> to insert your snippets in your files.

=cut

=attr src

The name of the favicon. Defaults to F<favicon.ico>.

=cut

# hi I'm src I'm defined in App::Embra::Role::IncludeFromSrc

method _build_src { 'favicon.ico' }

=attr fragment

The HTML fragment which links to the favicon. Set automatically to follow L<HTML5 best practices|http://www.diveintohtml5.com/semantics.html#new-relations> & can't be changed. Required by L<App::Embra::Role::Snippet>.

=cut

# hi I'm fragment I'm defined in App::Embra::Role::Snippet

method _build_fragment { qq{<link rel="shortcut icon" href="${ \ $self->href }">} }

=attr clipboard

Where the L<C<fragment>|/fragment> should end up in the file. Defaults to 'head'. Required by L<App::Embra::Role::Snippet>.

=cut

# hi I'm clipboard I'm defined in App::Embra::Role::Snippet

method _build_clipboard { 'head' }

with 'App::Embra::Role::Snippet';
with 'App::Embra::Role::IncludeFromSrc';

1;
