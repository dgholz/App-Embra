use strict;
use warnings;

package App::Embra;

# ABSTRACT: build-a-blog from parts

use Moo;
use Method::Signatures;

method from_config_mvp_sequence( $class:, Config::MVP::Sequence :$sequence ) {
    my $root_section = $sequence->section_named( '_' );
    my $creatura = $class->new( $root_section->payload );
    for my $plugin_section ( $sequence->sections ) {
        next if $plugin_section == $root_section;
        my $plugin = $plugin_section->package->new( $plugin_section->payload );
        $creatura->add_plugin( $plugin_section->name, $plugin );
    }
}

1;
