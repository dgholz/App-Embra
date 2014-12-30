use strict;
use warnings;

package App::Embra::Plugin::Zilla::WrapLog;

# ABSTRACT: wraps embra logger to suit dzil plugins

use Method::Signatures;
use Moo;

with 'App::Embra::Role::Logging';

has 'wrap_logger' => (
    is => 'lazy',
    handles => {
        log => 'info',
        log_debug => 'debug',
        log_fatal => 'fatal',
    },
    default => method { $self->logger },
);

1;
