use strict;
use warnings;

package App::Embra::Plugin::SnippetsToNotes;

# ABSTRACT: adds snippets of data from plugins to file notes

use Method::Signatures;
use Moo;

=head1 SYNOPSIS

    # embra.ini
    [SnippetsToNotes]

=cut

=head1 DESCRIPTION

This plugin examines all plugins for L<snippets|App::Embra::Plugin::Snippets>, and adds them as notes to the files in your site. Snippets are grouped by L<C<clipboard>|App::Embra::Plugin::Snippets/clipboard>, and are appended to C<$file->notes->{snippets}->{<clipboard>}>

This is a L<FileTransformer|App::Embra::Role::FileTransformer> plugin.

=cut

=head1 EXAMPLE

    # embra.ini
    [Template::My::Cool::Template]

    [Snippet / foo]
    clipboard = head
    fragment = <!-- made with foo by bar -->

    [Snippet / charset]
    clipboard = head
    fragment = <meta charset="UTF-8">

    [SnippetsToNotes]

    [GatherDir]
    from = site_directory

    # then in the Template::My::Cool::Template templates
    # assuming the file's notes are available as 'notes'
    <html><head><% for head_snippet in notes.snippets.head %><%= head_snippet %><% end %></head>
    ... etc.

    # results in the templated files from site_directory starting like
    <html><head><!-- made with foo by bar --><meta charset="UTF-8"></head> ... etc.


=cut

method transform_files {
    my %snippets;
    for my $snippet ( $self->embra->plugins_with( '-Snippet' ) ) {
        push @{ $snippets{ $snippet->clipboard } }, $snippet->fragment;
    }
    for ( @{ $self->embra->files } ) {
        $_->update_notes( snippets => \%snippets );
    }
}

with 'App::Embra::Role::FileTransformer';

1;
