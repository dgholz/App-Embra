use strict;
use warnings;

package App::Embra::Role::ExtraListDeps;

# ABSTRACT: allow a plugin to add more things to listdeps

use Method::Signatures;
use Moo::Role;

=head1 DESCRIPTION

This role is used by plugins to add extra pacakges to the list of required dependencies when C<embra listdeps> is executed. This role is only checked when a package has a section name in config i.e.

    [SomePlugin] # will not get the chance to add extra dependencies

    [SomePlugin / foo bar] # will get its extra dependencies added

Plugins which consume this role must define C<extra_list_deps>, which will be passed the values from config for the associated section in config and returns a list of package names.

=cut

requires 'extra_list_deps';

=method add_extra_deps

    App::Embra::Role::ExtraListDeps->add_extra_deps( $config, $reqs );

Static method which adds all of the plugin's extra dependencies to C<$reqs>, which is a L<CPAN::Meta::Requirements>. The values for the plugin set in the relevant config section are passed as C<$config> (HashRef).

=cut

method add_extra_deps( $class:, HashRef :$config, CPAN::Meta::Requirements :$reqs ) {
    for my $extra ( $class->extra_list_deps( config => $config )) {
        my ($p, $ver) = split qr{[ ]* = [ ]*}xms, $extra;
        if( ! defined $ver ) {
            $ver = 0;
        }
        $reqs->add_minimum( $p, $ver );
    }
}

1;
