use strict;
use warnings;

package App::Embra::Role::Logging;

# ABSTRACT: adds logging methods to a class

use Moo::Role;
use Method::Signatures;
use Log::Any;

has 'log_prefix' => (
    is => 'lazy',
);

method _build_log_prefix { 
    return q{};
}

has 'logger' => (
    is => 'lazy',
    handles => [ Log::Any->logging_methods ],
);

method _build_logger {
    return Log::Any->get_logger;
}

for my $logging_method ( Log::Any->logging_methods ) {
    around $logging_method => func( $orig, $self, $log_msg ) {
        $self->logger->$logging_method( $self->log_prefix . $log_msg );
    };
}

1;
