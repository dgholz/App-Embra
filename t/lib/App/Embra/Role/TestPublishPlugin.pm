use strict;
use warnings;

package App::Embra::Role::TestPublishPlugin;
use Test::Roo::Role;
with 'App::Embra::Role::TestPlugin';

after setup => sub {
    shift->plugin->publish_site;
};

1;
