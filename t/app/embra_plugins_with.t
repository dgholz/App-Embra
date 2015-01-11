use strict;
use warnings;

use lib 't/lib';

use Method::Signatures;
use Test::Roo;

extends 'App::Embra::Tester';

{
    package App::Embra::Role::Test;
    use Role::Tiny;
}

{
    package App::Embra::Plugin::TestRole;
    use Moo;
    with 'App::Embra::Role::Test';
    with 'App::Embra::Role::Plugin';
}

has 'plugin_with_role' => (
    is => 'lazy',
    default => sub { App::Embra::Plugin::TestRole-> new( embra => $_[0]->embra ) },
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
