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
    default => method { ref $self },
);

method register_plugin( $class:, :$name, HashRef :$args, App::Embra :$embra ) {
    my $self = $class->new( embra => $embra, name => $name, %{ $args } );
    $embra->add_plugin( $self );
}

with 'App::Embra::Role::Logging';

around '_build_logger' => func( $orig, $self ) {
    $self->embra->logger;
};

around '_build_log_prefix' => func( $orig, $self ) {
    return "[${ \ $self->name }] ";
};

1;
