use strict;
use warnings;

package App::Embra::App::Command;

# ABSTRACT: base class for embra commands

use App::Cmd::Setup -command;

use Log::Any::Adapter;
use Log::Any::Adapter::Dispatch;

sub embra {
    return $_[0]->app->embra;
}

sub opt_spec {
    my ( $class, $app ) = @_;
    return (
        [ 'debug|g' => 'show debug messages' ],
    );
}

sub validate_args {
    my ( $self, $opts, $args ) = @_;
    my $min_level = $opts->debug ? 'debug' : 'info';
    Log::Any::Adapter->set( 'Dispatch',
        outputs => [
            [ 'Screen',  min_level => $min_level, newline => 1 ],
        ],
    );
}

1;
