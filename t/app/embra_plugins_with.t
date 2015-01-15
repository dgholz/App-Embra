use strict;
use warnings;

use App::Embra;
use lib 't/lib';

use Method::Signatures;
use Test::Roo;

{
    package App::Embra::Plugin::TestRole;
    use Method::Signatures;
    use List::Util qw< any >;
    use Moo;
    extends 'App::Embra::Plugin::Test';

    around 'does' => func( $orig, $self, $role ) {
        return any { $_ eq $role } qw< App::Embra::Role::Test App::Embra::Role::Plugin > or $orig->($self, $role);
    };
}

has embra => (
    is => 'ro',
    default => sub { App::Embra->new },
);

has 'plugin_with_role' => (
    is => 'lazy',
    default => method { App::Embra::Plugin::TestRole-> new( embra => $self->embra ) },
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
