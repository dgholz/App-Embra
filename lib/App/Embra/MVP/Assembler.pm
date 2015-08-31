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

This extends L<Config::MVP::Assembler> and composes L<Config::MVP::Assembler::WithBundles>, to allow plugins composing L<App::Embra::Role::PluginBundle> to add multiple plugins at once.

Its C<L</expand_package>> method delegates to L<App::Embra::Util/expand_config_package_name>.

=cut

=method expand_package

    $assmbler->expand_package( $section_name );

Returns the full package name for a section in F<embra.ini>. This is required by L<Config::MVP::Assembler> and should not be called by any other module; use L<App::Embra::Util/expand_config_package_name> directly instead.

=cut

method expand_package( $pkg_name ) {
    expand_config_package_name( $pkg_name );
}

=method package_bundle_method($pkg) {

    $assembler->package_bundle_method( $pkg );

Returns the method name to invoke on C<$pkg> to get the config for its bundled plugins. This is required by L<Config::MVP::Assembler>. Defaults to C<undef> if C<$pkg> does not consume L<App::Embra::Role::PluginBundle> (i.e. it is not a plugin bundle), C<bundled_plugins_config> otherwise.

=cut

method package_bundle_method( $pkg ) {
    return if not $pkg->does('App::Embra::Role::PluginBundle');
    return 'bundled_plugins_config';
}

1;
