use lib 't/lib';
use Test::Roo;
extends 'App::Embra::Tester';
use Method::Signatures;

package App::Embra::Role::Test;
use Role::Tiny;

package App::Embra::Plugin::TestRole;
use Moo;
with 'App::Embra::Role::Test';
with 'App::Embra::Role::Plugin';

package main;

has 'plugin_with_role' => (
    is => 'ro',
    default => sub { App::Embra::Plugin::TestRole-> new },
);

before 'setup' => method {
    $self->embra->add_plugin( $self->plugin_with_role );
};

test 'finds a plugin' => method {
    is_deeply(
        [ $self->embra->plugins_with( 'App::Embra::Role::Test' ) ],
        [ $self->plugin_with_role ],
        'finds plugin by the role it consumes'
    );
};

test 'finds a plugin by short name' => method {
    is_deeply(
        [ $self->embra->plugins_with( -Test ) ],
        [ $self->plugin_with_role ],
        'finds plugin by the short name of the role it consumes'
    );
};

run_me;

done_testing;
