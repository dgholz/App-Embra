use strict;
use warnings;

package App::Embra::Role::FilePruner;

# ABSTRACT: something that stops files from appearing in a site

use Method::Signatures;
use Moo::Role;
use List::MoreUtils qw< indexes >;

with 'App::Embra::Role::Plugin';

requires 'exclude_file';

method prune_files {
    my $files = $self->embra->files;
    my @to_remove = indexes { $self->exclude_file( $_ ) } @{ $files };

    for my $i ( reverse sort @to_remove ) {
        $self->debug( "pruning ${ \ $files->[$i] }" );
        splice @{ $files }, $i, 1;
    }

    return;
}

1;

