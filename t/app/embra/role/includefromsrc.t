use strict;
use warnings;

use lib 't/lib';
use App::Embra::Role::IncludeFromSrc;

package Foo;
use Moo;

with 'App::Embra::Role::IncludeFromSrc';

package main;

use Method::Signatures;
use Test::Roo;

method _build_plugin {
    Foo->new(
        src => 'hi',
        embra => $self->embra,
    );
}

test 'composes' => method {
    is(
        $self->plugin->src,
        'hi',
        'composer has src ...'
    );
    is(
        $self->plugin->href,
        'hi',
        '... and href ...'
    );
    is(
        $self->plugin->file->name,
        'hi',
        '... and file points to src'
    );
};

with 'App::Embra::Role::TestPlugin';

run_me;

done_testing;
