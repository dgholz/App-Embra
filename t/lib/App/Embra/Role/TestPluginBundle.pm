use strict;
use warnings;

package App::Embra::Role::TestPluginBundle;
use App::Embra;

use Test::Roo::Role;

requires '_build_plugin_bundle';

has plugin_bundle => (
    is => 'lazy',
    clearer => 1,
);

after 'each_test' => sub { shift->clear_plugin_bundle };

has embra_files => (
    is => 'ro',
    default => sub { [] },
);

has embra => (
    is => 'lazy',
);

sub _build_embra {
    App::Embra->new( files => shift->embra_files );
}

1;
