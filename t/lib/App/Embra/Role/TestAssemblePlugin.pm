use strict;
use warnings;

package App::Embra::Role::TestAssemblePlugin;
use Test::Roo::Role;
with 'App::Embra::Role::TestPlugin';

after setup => sub {
    shift->plugin->assemble_files;
};

1;
