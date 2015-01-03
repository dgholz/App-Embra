use lib 't/lib';

use Method::Signatures;
use Test::Roo;

extends 'App::Embra::Tester';

test 'add a plugin' => method {
    my $before = grep { $_ == $self->plugin } @{ $self->embra->plugins };
    $self->embra->add_plugin( $self->plugin );
    my $after  = grep { $_ == $self->plugin } @{ $self->embra->plugins };

    is(
        $before + 1,
        $after,
        'adding a plugin adds it to the list of plugins'
    );
};

test q{can't add a non-plugin} => method {
    use Test::Exception;
    throws_ok(
        sub { $self->embra->add_plugin( 'a bean' ) },
        qr/does not satisfy constraint/,
        q{can't add something that doesn't consume the plugin role to the list of plugins}
    );
};

run_me;

done_testing;
