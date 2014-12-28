use strict;
use warnings;

package App::Embra::App::Command::listdeps;

# ABSTRACT: list plugins required to collate your site

use App::Embra::App -command;
use App::Embra::Util;

=head1 SYNOPSIS

    embra listdeps [ --root /path/to/site/ ] [ --missing ] [ --versions ]

=head1 DESCRIPTION

=cut

sub abstract { 'list required plugins' }

=head1 EXAMPLE

    $ embra listdeps
    $ embra listdeps --missing | cpanm

=cut

sub opt_spec {
    return (
        [ 'root=s'   => 'where to find embra.ini; defaults to .' ],
        [ 'missing'  => 'list only the missing dependencies' ],
        [ 'versions' => 'include required version numbers in listing' ],
    );
}

=head1 OPTIONS

=head2 --root

Specifies the directory to find the site's C<embra.ini>. Defaults to the current directory.

=head2 --missing

List only plugins which are not installed.

=head2 --versions

List the required version number for the required plugins.

=cut

sub execute {
    my ( $self, $opt, $arg ) = @_;
    require Path::Class;

    my $deps = _format_deps(
        _extract_deps(
            Path::Class::dir(defined $opt->root ? $opt->root : '.'),
            $opt->missing,
        ),
        $opt->versions
    );

    if( $deps ) {
        print $deps, "\n";
    }
}

# straight from the mouth of App::Zilla::Util

sub _extract_deps {
    my ($root, $missing) = @_;

    my $ini = $root->file('embra.ini');

    die "embra listdeps only works on embra.ini files, and I couldn't find one at: $ini\n"
        unless -e $ini;

    my $fh = $ini->openr;

    require Config::INI::Reader;
    my $config = Config::INI::Reader->read_handle($fh);

    require CPAN::Meta::Requirements;
    my $reqs = CPAN::Meta::Requirements->new;

    my @packs =
        map    { s/\s.*//; $_ }
        grep { $_ ne '_' }
        keys %$config;

    foreach my $pack (@packs) {

        my $version = 0;
        if(exists $config->{$pack} && exists $config->{$pack}->{':version'}) {
            $version = $config->{$pack}->{':version'};
        }
        my $realname = App::Embra::Util->expand_config_package_name($pack);
        $reqs->add_minimum($realname => $version);
    }

    seek $fh, 0, 0;

    my $in_filter = 0;
    while (<$fh>) {
        next unless $in_filter or /^\[\s*\@Filter/;
        $in_filter = 0, next if /^\[/ and ! /^\[\s*\@Filter/;
        $in_filter = 1;

        next unless /\A-bundle\s*=\s*([^;\s]+)/;
        my $pname = $1;
        chomp($pname);
        $reqs->add_minimum(App::Embra::Util->expand_config_package_name($1) => 0)
    }

    seek $fh, 0, 0;

    my @packages;
    while (<$fh>) {
        chomp;
        next unless /\A\s*;\s*extradep\s*(\S+)\s*(=\s*(\S+))?\s*\z/;
        my $ver = defined $3 ? $3 : "0";
        # Any "; extradep " is inserted at the beginning of the list
        # in the file order so the user can control the order of at least a part of
        # the plugin list
        push @packages, $1;
        # And added to the requirements so we can use it later
        $reqs->add_minimum($1 => $ver);
    }

    my $vermap = $reqs->as_string_hash;
    # Add the other requirements
    push(@packages, sort keys %{ $vermap });

    # Move inc:: first in list as they may impact the loading of other
    # plugins (in particular local ones).
    # Also order inc:: so that thoses that want to hack @INC with inc:: plugins
    # can have a consistant playground.
    # We don't sort the others packages to preserve the same (random) ordering
    # for the common case (no inc::, no '; authordep') as in previous dzil
    # releases.
    @packages = ((sort grep /^inc::/, @packages), (grep !/^inc::/, @packages));

    # Now that we have a sorted list of packages, use that to build an array of
    # hashrefs for display.
    require List::MoreUtils;
    require Class::Load;

    my @final =
        map { { $_ => $vermap->{$_} } }
        grep { $missing ? (! Class::Load::try_load_class($_, ($vermap->{$_} ? {-version => $vermap->{$_}} : ()))) : 1 }
        List::MoreUtils::uniq( @packages );

    return \@final;
}

sub _format_deps {
    my ($reqs, $versions) = @_;

    my $formatted = '';
    foreach my $rec (@{ $reqs }) {
        my ($mod, $ver) = each(%{ $rec });
        $formatted .= $versions ? "$mod = $ver\n" : "$mod\n";
    }
    chomp($formatted);
    return $formatted;
}

1;
