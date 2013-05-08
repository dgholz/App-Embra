use strict;
use warnings;

package App::Embra::Role::WithFrontMatter;

# ABSTRACT: a file with some leading metadata

use Moo::Role;

has 'front_matter' => (
    is => 'rw',
    default => sub{ {} },
);

1;
