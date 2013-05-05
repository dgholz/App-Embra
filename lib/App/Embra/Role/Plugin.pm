use strict;
use warnings;

package App::Embra::Role::Plugin;

# ABSTRACT: something that gets plugged into App::Embra

use Method::Signatures;
use Moo::Role;

has 'embra' => (
    is => 'ro',
    required => 1,
);

method register_plugin( $class:, :$name, HashRef :$args, App::Embra :$embra ) {
    my $self = $class->new( embra => $embra, %{ $args } );
    $embra->add_plugin( $self );
}

1;
