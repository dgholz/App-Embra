use strict;
use warnings;

package App::Embra::Role::WithFrontMatter;

# ABSTRACT: a file with some leading metadata

use Moo::Role;

has 'front_matter' => (
    is => 'lazy',
);

sub _build_front_matter {
    {};
}

sub update_front_matter {
    my ($self, $update) = @_;
    @{ $self->front_matter }{ keys %$update } = values %$update;
}

1;
