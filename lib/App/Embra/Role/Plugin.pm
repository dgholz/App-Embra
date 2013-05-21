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

has 'name' => (
    is => 'ro',
    default => sub { __PACKAGE__ },
);

method register_plugin( $class:, :$name, HashRef :$args, App::Embra :$embra ) {
    my $self = $class->new( embra => $embra, name => $name, %{ $args } );
    $embra->add_plugin( $self );
}

1;
