use strict;
use warnings;

package App::Embra::Plugin::Zilla::WrapLog;

# ABSTRACT: wraps embra logger to suit dzil plugins

use Method::Signatures;
use Moo;

with 'App::Embra::Role::Logging';

my %_log_level_map = (
    log => 'info',
    log_debug => 'debug',
    log_fatal => 'fatal',
);

has '_wrap_logger' => (
    is => 'lazy',
    handles => \%_log_level_map,
    default => method { $self->logger },
);

has 'proxy_prefix' => (
    is => 'ro',
    required => 1,
);

around 'log_prefix' => func( $orig, $self ) {
    $self->proxy_prefix;
};

while( my ($w, $r) = each %_log_level_map ) {
    around $w => func( $orig, $self, $log_msg ) {
        $self->logger->$r( $self->log_prefix . $log_msg );
    };
}

1;
