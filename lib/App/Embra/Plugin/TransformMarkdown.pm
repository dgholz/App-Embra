use strict;
use warnings;

package App::Embra::Plugin::TransformMarkdown;

# ABSTRACT: turn markdown files in your site into html files

use File::Basename;
use Method::Signatures;
use Moo;

=head1 SYNOPSIS

    # embra.ini
    [TransformMarkdown]
    extension = md # default

=cut

=head1 DESCRIPTION

This plugin will transform the content of Markdown files into HTML and change the file's extension to C<.html>.

=cut

=attr extension

Transform files whose extension matches this. Defaults to C<md>.

=cut

has 'extension' => (
    is => 'ro',
    default => sub { 'md' },
);

=attr converter

The object to use to convert the file content from Markdown to HTML. Defaults to an instance of L<Text::Markdown>.

This attribute should provide a method C<markdown>, which works like:

    my $hmtl_content = $self->converter->markdown( $markdown_content );

=cut

has 'converter' => (
    is => 'ro',
    default => sub {
        require Text::Markdown;
        Text::Markdown->new;
    },
);

method transform_files {
    for my $file ( @{ $self->embra->files } ) {
        next if $file->ext ne $self->extension;
        $file->content( $self->converter->markdown( $file->content ) );
        $file->notes->{transformed_by} = __PACKAGE__;
        $file->ext( 'html' );
    }
}

with 'App::Embra::Role::FileTransformer';

1;
