use strict;
use warnings;

package App::Embra::App::Command::listdeps;

# ABSTRACT: list plugins required to collate your site

use App::Embra::App -command;
use App::Embra::Util qw< expand_config_package_name >;

=head1 SYNOPSIS

    embra listdeps [ --missing ] [ --versions ]

=head1 DESCRIPTION

This command examines your F<embra.ini> and prints the packages required to collate your site. See L<App::Embra::App/embra> for more details of the format of F<embra.ini>

=cut

sub abstract { 'list required plugins' }

=head1 EXAMPLE

    $ embra listdeps
    $ embra listdeps --missing | cpanm

=cut

sub opt_spec {
    my ( $self, @args ) = @_;
    return (
        $self->SUPER::opt_spec(@args),
        [ 'missing'  => 'list only the missing dependencies' ],
        [ 'versions' => 'include required version numbers in listing' ],
    );
};

=head1 OPTIONS

The standard L<embra options|App::Embra::App::Command/GLOBAL OPTIONS> are available, plus the following.

=head2 --missing

List only plugins which are not installed.

=head2 --versions

List the required version number for the required plugins.

=cut

sub execute {
    my ( $self, $opt, $arg ) = @_;

    local $App::Embra::MODE = 'deps';
    my $deps_from_seq = _format_deps(
        _deps_from_seq(
            $self->app->_create_seq(
                section_class => 'App::Embra::App::Command::Listdeps::Section',
            ),
            $opt->missing
        ),
        $opt->versions
    );

    if( $deps_from_seq ) {
        print $deps_from_seq, "\n";
    }
}

sub _deps_from_seq {
    my ($seq, $missing) = @_;
    my @deps;
    my %seen;
    for my $plugin_section ( $seq->sections ) {
        next if $plugin_section->name eq '_';
        next if $seen{$plugin_section->package};
        next if $missing and not $plugin_section->is_missing;
        push @deps, {
            $plugin_section->package,
            $plugin_section->payload->{version} // 0,
        };
        ++$seen{$plugin_section->package};
    }
    return \@deps;
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
