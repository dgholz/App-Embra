use strict;
use warnings;

package App::Embra::Plugin::PublishFiles;

# ABSTRACT: write site files into a directory

use Moo;
use Method::Signatures;
use Path::Class qw<>;

has 'to' => (
    is => 'ro',
    required => 1,
    default => sub { '.' },
    coerce => sub { Path::Class::dir( $_[0] ) },
);

method publish_files {
    for my $file ( @{ $self->embra->files } ) {
        my $f = $self->to->file( $file->name );
        $f->parent->mkpath;
        $f->spew( $file->content );
    }
}

method exclude_file( $file ) {
    return 1 if $self->to->subsumes( $file->name );
    return;
}

with 'App::Embra::Role::FilePublisher';
with 'App::Embra::Role::FilePruner';

1;
