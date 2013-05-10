use strict;
use warnings;

package App::Embra::Plugin::TransformMarkdown;

# ABSTRACT: turn markdown files into html

use Moo;
use Method::Signatures;
use File::Basename;

has 'extension' => (
    is => 'ro',
    default => sub { 'md' },
);

has 'converter' => (
    is => 'ro',
    default => sub {
        require Markup::Unified;
        Markup::Unified->new();
    },
);

method transform_files {
    for my $file ( @{ $self->embra->files } ) {
        my $ext = (fileparse( $file->name, qr{ (?<= [.] ) [^.]+ $ }x ))[2];
        next if $ext ne $self->extension;
        $file->content( $self->converter->format( $file->content, 'markdown' ) );
        $file->notes->{converted_from} = 'markdown';
    }
}

with 'App::Embra::Role::FileTransformer';

1;
