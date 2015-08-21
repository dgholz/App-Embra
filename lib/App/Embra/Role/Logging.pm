use strict;
use warnings;

package App::Embra::Role::Logging;

# ABSTRACT: adds logging methods to a class

use Log::Any;
use Method::Signatures;
use Moo::Role;

=head1 DESCRIPTION

This role adds some basic logging methods to consuming classes. It provides L<a C<logger> attribute|/logger>, which handles all of the standard log methods.

=cut

=attr log_prefix

A string to prefix to all logged messages. Defaults to the empty string. If the consuming class declares a C<_build_log_prefix> method, its return value will be used as the default instead.

=cut

has 'log_prefix' => (
    is      => 'lazy',
    builder => method { q{} },
);

=attr logger

The object which handles all the logging. Defaults to the logger returned by C<< Log::Any->get_logger >>. If the consuming class declares a C<_build_logger> method, its return value will be used as the default instead.

It should respond to L<Log::Any's logging methods|Log::Any/"LOG LEVELS">.
=cut

has 'logger' => (
    is      => 'lazy',
    handles => [ Log::Any->logging_methods ],
    builder => method { Log::Any->get_logger },
);

for my $logging_method ( Log::Any->logging_methods ) {
    around $logging_method => func( $orig, $self, $log_msg ) {
        $self->logger->$logging_method( $self->log_prefix . $log_msg );
    };
}

1;
