use strict;
use warnings;

package App::Embra::Util;

# ABSTRACT: place for misc. code

use String::RewritePrefix;

sub expand_config_package_name {
    my( $class, $pkg_name ) = @_;
    String::RewritePrefix->rewrite(
        {
          '=' => '',
          '@' => 'App::Embra::PluginBundle::',
          '%' => 'App::Embra::Stash::',
          ''  => 'App::Embra::Plugin::',
        },
        $pkg_name,
    );
}

1;
