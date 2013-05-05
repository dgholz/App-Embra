use strict;
use warnings;

package App::Embra::Role::FileGatherer;

# ABSTRACT: something that gathers files for App::Embra to turn into a site

use Method::Signatures;
use Moo::Role;

with 'App::Embra::Role::Plugin';

requires 'gather_files';

method add_file( App::Embra::File $file ) {
    push @{ $self->embra->files }, $file;
}

1;

