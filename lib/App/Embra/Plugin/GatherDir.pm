use strict;
use warnings;

package App::Embra::Plugin::GatherDir;

# ABSTRACT: gather all the files in a directory

use Moo;
use Method::Signatures;

use App::Embra::File;
use Path::Class::Dir;

has 'from' => (
    is => 'ro',
    required => 1,
    default => sub { '.' },
    coerce => sub { Path::Class::Dir->new( $_[0] ) },
);

method gather_files {
    $self->from->recurse( callback => func( $file ) {
        return if $file->is_dir;
        $self->add_file( App::Embra::File->new( name => $file->stringify ) );
    } );
}

with 'App::Embra::Role::FileGatherer';

1;
