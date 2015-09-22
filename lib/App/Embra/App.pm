use strict;
use warnings;

package App::Embra::App;

# ABSTRACT: App::Embra's App::Cmd

use App::Cmd::Setup -app;

=head1 DESCRIPTION

This class is instantiated from L<the command-line tool|embra>. It is based on L<App::Cmd>, so it performs all of its functions: notably, examining the command given to C<embra> and dispatching to the appropriate L<App::Embra::App::Command>.

It also instantiates an instance of L<App::Embra>, configured from the F<embra.ini> config file. Read L<about the C<embra> attribute|/embra> for further details.

=cut

=method embra

Returns the L<App::Embra> that will be used to build the site. It will be constructed by calling L<App::Embra/from_config_mvp_sequence> with the settings from F<embra.ini> in the current working directory.

The format for F<embra.ini> is:

     # values for App::Embra constructor
     # these must come first in the file
     name = My Cool Site
     publisher = Your Name Here

     # plugins to be used
     [PluginName]
     plugin_option = value
     # shorthand for
     [App::Embra::Plugin::PluginName]

     # bundles of plugins to be used
     [@BundleName]
     bundle_option = value
     # shorthand for
     [App::Embra::PluginBundle::BundleName]

Each section has an associated name, which defaults to the section header (the package name inside square brackets). Names must be unique (a requirement of L<Config::MVP::Sequence>). To add a plugin more than once, specify an alternative name for its sections by appending it after the package name, separated by a slash:

     [Plugin / first instance for foo]
     file = foo

     [Plugin / second instance for bar]
     file = bar

The name will be passed to the plugin as its C<L<name|App::Embra::Role::Plugin/name>> attribute (likewise for L<plugin bundles|App::Embra::Role::PluginBundle/name>).

=cut

sub embra {
    my ( $self ) = @_;
    use 5.010;
    require App::Embra;
    use feature qw< state >;
    state $embra = App::Embra->from_config_mvp_sequence( sequence => $self->_create_seq );
}

=func _missing_pkg

    die _missing_pkg( $config_mvp_error );

Returns a string explaining that the L<App::Embra> instance could not be created due to a missing package, and explains how to resolve the issue. Called from L</_reword_exception>.

=cut

sub _missing_pkg {
    my ($exception) = @_;
    my $package = $exception->package;

    my $bundle = $package =~ /^@/ ? ' bundle' : '';
    return <<"EOM";
Required plugin$bundle [$package] isn't installed.

Run 'embra listdeps' to see a list of all required plugins.
You can pipe the list to your CPAN client to install or update them:

    embra listdeps | cpanm

EOM
}

=func _no_config

    die _no_config;

Returns a string explaining that the L<App::Embra> instance could not be created because no F<embra.ini> file could be found to configure it, and reminds the user to run L<C<embra>|embra> in the same directory as their F<embra.ini> file. Called from L</_reword_exception>.

=cut

sub _no_config {
    return <<"EOM";
No embra.ini found! Make sure you ran 'embra' in the same directory as your site settings file.

EOM
}

=func _reword_exception

    die _reword_exception( $config_mvp_error );

Examines C<$config_mvp_error> (an instance of L<Config::MVP::Error>) to see if an alternative message could be shown to the command-line user (instead of a stack-trace).

=cut

sub _reword_exception {
    my( $e ) = @_;
    my %match = (
        'package not installed'   => \&_missing_pkg,
        'no viable configuration' => \&_no_config,
    );
    while( my( $msg, $error_sub ) = each %match ) {
        if( $e->ident =~ /$msg/ ) {
            return $error_sub->($e);
        }
    }
    return $e;
}

# from Dist::Zilla::Dist::Build, where it is known as _load_config

=func _create_seq

    my $config_mvp_sequence = $self->_create_seq;

Returns an instance of L<Config::MVP::Sequence> created from the contents of F<embra.ini>. It will die if it encounters an error, L<rewording the error|/_reword_exception> if it can.

Uses L<App::Embra::MVP::Assembler> to transform section names to packages, and to expand bundles into their component plugins.

=cut

sub _create_seq {
    my ( $self, %assembler_args ) = @_;
    require Config::MVP::Reader::Finder;
    require App::Embra::MVP::Assembler;
    use Try::Tiny;
    try {
        Config::MVP::Reader::Finder->read_config(
            'embra',
            {
                assembler => App::Embra::MVP::Assembler->new( %assembler_args ),
            }
        );
    } catch {
        die $_ if not try { $_->isa('Config::MVP::Error') };
        die _reword_exception($_);
    };
}

1;
