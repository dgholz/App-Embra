use strict;
use warnings;

package App::Embra::App::Command;

# ABSTRACT: base class for embra commands

use App::Cmd::Setup -command;

use Log::Any::Adapter;
use Log::Any::Adapter::Dispatch;

=head1 DESCRIPTION

This is the base class for commands for the L<embra> command-line tool. This class is based on L<App::Cmd::Command>.

This class also specifies some global options for all commands (in L</GLOBAL OPTIONS>, and configures logging from the internals of L<App::Embra> so they appear on standard out.

=cut

=head1 GLOBAL OPTIONS

=for list

* C<--debug>

    embra -g|--debug # show debug messages

Print debug-level messages to stdout when running the command.

=cut

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

=method embra

    # in App::Embra::App::Command::frobnicate
    sub execute {
        for my $plugin ( @{ $self->embra->plugins } ) {

        ...
    }

Returns the instance of L<App::Embra> being used to build your site. Delegates the method dispatch to C<< $self->app >>, which is an instance of L<App::Embra::App/embra>. Thus, every instance of

    $self->embra

could instead be replace with

    $self->app->embra

=cut

sub embra {
    return $_[0]->app->embra;
}

1;
