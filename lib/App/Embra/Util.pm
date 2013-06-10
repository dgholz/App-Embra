use strict;
use warnings;

package App::Embra::Util;

# ABSTRACT: place for misc. code

use String::RewritePrefix;

=method expand_config_package_name

    App::Embra::Util->expand_config_package_name( $pkg_name )

Returns C<$pkg_name> rewritten into a package name. If C<$pkg_name> starts with C<=>, it is treated as a package name and returned unmodified. Otherwise, a copy of it is prefixed with C<App::Embra::Plugin> (and then C<Bundle>, if it starts with C<@>) and returned.

Used by l<App::Embra::MVP::Assembler> and L<App::Embra::App::Command::listdeps>, to turn section names in config files into package names.

=cut

sub expand_config_package_name {
    my( $class, $pkg_name ) = @_;
    String::RewritePrefix->rewrite(
        {
          '=' => '',
          '@' => 'App::Embra::PluginBundle::',
          ''  => 'App::Embra::Plugin::',
        },
        $pkg_name,
    );
}

1;
