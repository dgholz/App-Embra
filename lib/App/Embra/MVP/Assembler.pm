use strict;
use warnings;

package App::Embra::MVP::Assembler;

# ABSTRACT: App::Embra-specific subclass of Config::MVP::Assembler

use Moo;
extends 'Config::MVP::Assembler';
with 'Config::MVP::Assembler::WithBundles';

use String::RewritePrefix;

sub expand_package {
    my ( $self, $pkg_name ) = @_;
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
