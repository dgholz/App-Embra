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
        my $e = $_;
        try {
            $e->isa('Config::MVP:Error') and 'package not installed' eq $e->ident;
        } catch {
            die $e;
        };
        my $package = $_->package;

        my $bundle = $package =~ /^@/ ? ' bundle' : '';
        die <<"END_DIE";
Required plugin$bundle [$package] isn't installed.

Run 'embra listdeps' to see a list of all required plugins.
You can pipe the list to your CPAN client to install or update them:

    embra listdeps | cpanm

END_DIE
    };
}

1;
