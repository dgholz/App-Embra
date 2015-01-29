use strict;
use warnings;

use lib 't/lib';
use App::Embra::Plugin::Template::Basic;

use Method::Signatures;
use Test::Roo;

method _build_plugin {
    return App::Embra::Plugin::Template::Basic->new(
        embra => $self->embra,
    );
}

with 'App::Embra::Role::TestAssemblePlugin';

test 'ctor' => method {
    ok( $self->plugin );
};

run_me;

done_testing;
