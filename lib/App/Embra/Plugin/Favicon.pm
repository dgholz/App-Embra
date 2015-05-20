use strict;
use warnings;

package App::Embra::Plugin::Favicon;

# ABSTRACT: adds a favicon

use Moo;
use Method::Signatures;

=head1 DESCRIPTION

This plugin creates a favicon L<snippet|App::Embra::Role::Snippet>, suitable for inserting into the HTML files of your site. It doesn't add the snippet to your HTML files; include L<C<[SnippetsToNotes]>|App::Embra::Plugin::SnippetsToNotes> & a snippet-aware template (like L<C<[Template::Basic]>|App::Embra::Plugin::Template::Basic>) in your F<embra.ini> to insert your snippets in your files.

=cut

=attr filename

The name of the favicon. Defaults to F<favicon.ico>.

=cut

has 'filename' => (
    is => 'ro',
    default => 'favicon.ico',
);

has 'file' => (
    is => 'lazy',
    default => method {
        App::Embra::File->new( name => $self->filename )
    },
);

=attr fragment

The HTML fragment which links to the favicon. Set automatically to follow L<HTML5 best practices|http://www.diveintohtml5.com/semantics.html#new-relations> & can't be changed. Required by L<App::Embra::Role::Snippet>.

=cut

has 'fragment' => (
    is => 'ro',
    default => method { qq{<link rel="shortcut icon" href="${ \ $self->file->name }">} },
    init_arg => undef,
);

=attr clipboard

Where the L<C<fragment>|/fragment> should end up in the file. Defaults to 'head'. Required by L<App::Embra::Role::Snippet>.

=cut

has 'clipboard' => (
    is => 'ro',
    default => 'head',
    init_arg => undef,
);

with 'App::Embra::Role::Snippet';

method gather_files {
    $self->add_file( $self->file );
}

with 'App::Embra::Role::FileGatherer';

1;
