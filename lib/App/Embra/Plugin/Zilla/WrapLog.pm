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

1;
