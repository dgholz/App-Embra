use strict;
use warnings;

package App::Embra::App;

# ABSTRACT: App::Embra's App::Cmd

use App::Cmd::Setup -app;

use Log::Any::Adapter;
use Log::Any::Adapter::Dispatch;

sub global_opt_spec {
    return (
        [ 'debug|g', 'show debug messages' ],
    );
}

sub prepare_command {
    my $self = shift;
    my @res = $self->SUPER::prepare_command( @_ );
    my $min_level = 'info';
    if ( $self->global_options->debug ) {
        $min_level = 'debug';
    }
    Log::Any::Adapter->set( 'Dispatch',
        outputs => [
            [ 'Screen',  min_level => $min_level, newline => 1 ],
        ],
    );
    return @res;
}

1;
