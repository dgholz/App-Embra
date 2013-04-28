use strict;
use warnings;

package App::Embra::Role::Plugin;

# ABSTRACT: something that gets plugged into App::Embra

use Method::Signatures;
use Role::Tiny;

method register_plugin( $class:, :$name, HashRef :$args, App::Embra :$embra ) {
    my $self = $class->new( %{ $args } );
    $embra->add_plugin( $self );
}

1;
