use strict;
use warnings;

package App::Embra::App;

# ABSTRACT: App::Embra's App::Cmd

use App::Cmd::Setup -app;

=head1 DESCRIPTION

=cut

=method embra

Returns the L<App::Embra> that will be used to build the site. It will be constructed by calling L<< App::Embra->from_config_mvp_sequence >> with the settings from F<embra.ini> in the current working directory.

The format for F<embra.ini> is:

     # values for L<App::Embra> constructor
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

Section headers can optionally have a name appended to the package name, separated by a slash:

     [Plugin / first instance for foo]
     file = foo

     [Plugin / second instance for bar]
     file = bar

The name will be passed to the package as its C<name> attr (either for L<plugins|App::Embra::Role::Plugin> or L<bundles|App::Embra::Role::PluginBundle>).

=cut

sub embra {
    my ( $self ) = @_;
    use 5.010;
    require App::Embra;
    use feature qw< state >;
    state $embra = App::Embra->from_config_mvp_sequence( sequence => $self->_create_seq );
}

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

sub _no_config {
    return <<"EOM";
No embra.ini found! Make sure you ran 'embra' in the same directory as your site settings file.

EOM
}

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

sub _create_seq {
    my ( $self ) = @_;
    require Config::MVP::Reader::Finder;
    require App::Embra::MVP::Assembler;
    use Try::Tiny;
    try {
        Config::MVP::Reader::Finder->read_config(
            'embra',
            {
                assembler => App::Embra::MVP::Assembler->new,
            }
        );
    } catch {
        die $_ if not try { $_->isa('Config::MVP::Error') };
        die _reword_exception($_);
    };
}

1;
