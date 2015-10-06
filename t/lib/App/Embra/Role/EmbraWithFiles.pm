use strict;
use warnings;

package App::Embra::Role::EmbraWithFiles;

use Test::Roo::Role;

requires 'embra';

has embra_files => (
    is => 'ro',
    default => sub { [] },
);

after 'setup' => sub {
    my $self = shift;
    push @{ $self->embra->files }, @{ $self->embra_files };
};

1;
