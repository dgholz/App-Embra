use strict;
use warnings;

package App::Embra::Role::Logging;

# ABSTRACT: adds logging methods to a class

use Moo::Role;
use Method::Signatures;
use Log::Any;

=head1 DESCRIPTION

This role adds some basic logging methods to its implementer. It provides L<a C<logger> attribute|/logger>r which handles all of the standard log methods.

=cut

=attr log_prefix

A string to prefix to all logged messages. Defaults to the empty string.

=cut

has 'log_prefix' => (
    is => 'lazy',
);

=method _build_log_prefix

    say $app_embra_role_logging->_build_log_prefix;

Returns the log prefix. Present only so it can be modified by implementors with L<around|Method::Modifiers/around>.

=cut

method _build_log_prefix { 
    return q{};
}

=attr logger

The object which handles all the logging. It must accept any of L<Log::Any's logging methods|Log::Any/logging_methods>.

=cut

has 'logger' => (
    is => 'lazy',
    handles => [ Log::Any->logging_methods ],
);

=method _build_logger

    my $logger = $app_embra_role_logging->_build_logger;

Returns a new instance of L<Log::Any>. Present only so it can be modified by implementors with L<around|Method::Modifiers/around>.

=cut

method _build_logger {
    return Log::Any->get_logger;
}

for my $logging_method ( Log::Any->logging_methods ) {
    around $logging_method => func( $orig, $self, $log_msg ) {
        $self->logger->$logging_method( $self->log_prefix . $log_msg );
    };
}

1;
