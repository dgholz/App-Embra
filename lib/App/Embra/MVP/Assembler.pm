use strict;
use warnings;

package App::Embra::MVP::Assembler;

# ABSTRACT: App::Embra-specific subclass of Config::MVP::Assembler

use App::Embra::Util qw< expand_config_package_name >;

use Moo;
extends 'Config::MVP::Assembler';
with 'Config::MVP::Assembler::WithBundles';

=head1 DESCRIPTION

App::Embra::MVP::Assembler extends L<Config::MVP::Assembler> and composes L<Config::MVP::Assembler::WithBundles> for potential plugin bundles (things composing L<App::Embra::Role::PluginBundle> (once that role is written)).

The Assembler's C<expand_package> method delegates to L<App::Embra::Util/expand_config_package_name>.

=cut

sub expand_package {
    my ( $self, $pkg_name ) = @_;
    expand_config_package_name( $pkg_name );
}

1;
