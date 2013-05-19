package App::Embra::Role::TestGatherPlugin;
use Test::Roo::Role;
with 'App::Embra::Role::TestPlugin';

before setup => sub {
    shift->plugin->gather_files;
};

1;
