use strict;
use warnings;

use lib 't/lib';
use App::Embra::Role::Plugin;

package TestPlugin;
use Moo;
with 'App::Embra::Role::Plugin';

package main;

use Method::Signatures;
use Test::Roo;

test 'register plain plugin' => method {
    isa_ok(
        TestPlugin->register_plugin( embra => $self->embra ),
        'TestPlugin',
        'registered a plain plugin'
    );
};

method _build_plugin { }
with 'App::Embra::Role::TestPlugin';

run_me;

done_testing;
