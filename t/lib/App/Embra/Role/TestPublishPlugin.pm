package App::Embra::Role::TestPublishPlugin;
use Test::Roo::Role;
with 'App::Embra::Role::TestPlugin';

before setup => sub {
    shift->plugin->publish_files;
};

1;
