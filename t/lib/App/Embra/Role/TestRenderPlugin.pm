package App::Embra::Role::TestRenderPlugin;
use Test::Roo::Role;
with 'App::Embra::Role::TestPlugin';

before setup => sub {
    shift->plugin->render_files;
};

1;
