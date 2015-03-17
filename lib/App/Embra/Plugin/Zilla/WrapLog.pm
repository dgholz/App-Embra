use strict;
use warnings;

package App::Embra::Plugin::Zilla::WrapLog;

# ABSTRACT: wraps embra logger to suit dzil plugins

use Method::Signatures;
use Moo;

=head1 SYNOPSIS

    use App::Embra::Plugin::Zilla::WrapLog;
    use App::Embra; # or something else that does Log::Any
    use Dist::Zilla::Plugin::CoolPlugin;

    my $embra = App::Embra->new();
    my $wraplog = App::Embra::Plugin::WrapZillaPlugin->new(
        logger => $embra, # log to whereever $embra is configured to log to
        log_prefix => '[CoolPlugin (wrapped)] ',
    );

    my $cool_plugin = Dist::Zilla::Plugin::CoolPlugin->new( logger => $wraplog );

=cut

=head1 DESCRIPTION

This provides logging methods which match the semantics of L<Log::Dispatchouli>. It's passed by L<App::Embra::Plugin::WrapZillaPlugin> to the wrapped L<Dist::Zilla> plugin as its C<logger> attribute.

It consumes L<App::Embra::Role::Logging>.

L<Log::Dispatchouli> methods are mapped to L<Log::Any/LOG LEVELS>:

=for :list
* L<log|Log::Dispatchouli/log> => C<info>
* L<log_debug|Log::Dispatchouli/log_debug> => C<debug>
* L<log_fatal|Log::Dispatchouli/log_fatal> => C<fatal>

=cut

my %_log_level_map = (
    log => 'info',
    log_debug => 'debug',
    log_fatal => 'fatal',
);

# App::Embra::Role::Logging provides $self->logger & $self->log_prefix

has '_wrap_logger' => (
    is => 'lazy',
    handles => \%_log_level_map,
    default => method { $self->logger },
);

while( my ($w, $r) = each %_log_level_map ) {
    around $w => func( $orig, $self, $log_msg ) {
        $self->logger->$r( $self->log_prefix . $log_msg );
    };
}

with 'App::Embra::Role::Logging';

1;
