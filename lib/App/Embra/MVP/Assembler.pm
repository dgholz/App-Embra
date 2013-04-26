use strict;
use warnings;

package App::Embra::MVP::Assembler;

# ABSTRACT: App::Embra-specific subclass of Config::MVP::Assembler

use Moo;
extends 'Config::MVP::Assembler';
with 'Config::MVP::Assembler::WithBundles';
use App::Embra::Util;

sub expand_package {
    my ( $self, $pkg_name ) = @_;
    App::Embra::Util->expand_config_package_name( $pkg_name );
}

1;
