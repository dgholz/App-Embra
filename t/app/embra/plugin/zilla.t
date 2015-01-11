use strict;
use warnings;

use lib 't/lib';
use App::Embra::Plugin::Zilla;

use Method::Signatures;
use Test::Roo;

method _build_plugin {
    return App::Embra::Plugin::Zilla->new(
        embra => $self->embra,
    );
}

with 'App::Embra::Role::TestPlugin';

test 'pretends to be something like Dist::Zilla' => method {
    ok(
        $self->plugin->isa('Dist::Zilla'),
        'App::embra::Plugin::Zilla isa Dist::Zilla'
    );
};

run_me;

done_testing;
