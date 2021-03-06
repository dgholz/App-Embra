use strict;
use warnings;

package App::Embra::Role::TestPrunePlugin;
use Test::Roo::Role;
with 'App::Embra::Role::TestPlugin';

after setup => sub {
    shift->plugin->prune_files;
};

1;
