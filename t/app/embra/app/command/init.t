use strict;
use warnings;

use App::Embra;
use lib 't/lib';

use Method::Signatures;
use Test::Roo;

has embra => (
    is => 'ro',
    default => sub { App::Embra->new },
);

test 'add a plugin' => method {
    my $plugin = App::Embra::Plugin::Test->new( embra => $self->embra );
    my $before = grep { $_ == $plugin } @{ $self->embra->plugins };
    $self->embra->add_plugin( $plugin );
    my $after  = grep { $_ == $plugin } @{ $self->embra->plugins };

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
