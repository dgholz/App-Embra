use strict;
use warnings;

package App::Embra::Plugin::SnippetsToNotes;

# ABSTRACT: add fragments of HTML from plugins to file notes

use Method::Signatures;
use Moo;

=head1 DESCRIPTION

This plugin will find all the plugins which have L<snippets|App::Embra::Plugin::Snippets>, and then add their HTML fragments as notes to the files in your site.

This is a L<FileTransformer|App::Embra::Role::FileTransformer> plugin.

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
