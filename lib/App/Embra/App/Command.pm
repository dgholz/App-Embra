use strict;
use warnings;

package App::Embra::App::Command;

# ABSTRACT: base class for embra commands

use App::Cmd::Setup -command;

=method embra

This returns the App::Embra object in use by the command. it will be constructed by calling C<< App::Embra->from_config_mvp_sequence >> with the settings from C< embra.ini >.

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
