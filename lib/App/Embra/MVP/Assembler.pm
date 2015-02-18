use strict;
use warnings;

package App::Embra::MVP::Assembler;

# ABSTRACT: App::Embra-specific subclass of Config::MVP::Assembler

use App::Embra::Util qw< expand_config_package_name >;

use Moo;
use Method::Signatures;
extends 'Config::MVP::Assembler';
with 'Config::MVP::Assembler::WithBundles';

=head1 DESCRIPTION

App::Embra::MVP::Assembler extends L<Config::MVP::Assembler> and composes L<Config::MVP::Assembler::WithBundles>, to allow plugins composing L<App::Embra::Role::PluginBundle> to add multiple plugins at once.

The Assembler's C<expand_package> method delegates to L<App::Embra::Util/expand_config_package_name>.

=cut

method expand_package( $pkg_name ) {
    expand_config_package_name( $pkg_name );
}

method package_bundle_method($pkg) {
    return if not $pkg->does('App::Embra::Role::PluginBundle');
    return 'bundled_plugins_config';
}

1;
