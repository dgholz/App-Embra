package App::Embra::Role::TestTransformPlugin;
use Test::Roo::Role;
with 'App::Embra::Role::TestPlugin';

before setup => sub {
    shift->plugin->transform_files;
};

1;
