use strict;
use warnings;

package App::Embra::Role::TestPlugin;
use App::Embra;

use Test::Roo::Role;

requires '_build_plugin';

has plugin => (
    is => 'lazy',
);

has embra => (
    is => 'lazy',
);

sub _build_embra {
    App::Embra->new;
}

with 'App::Embra::Role::EmbraWithFiles';

1;
