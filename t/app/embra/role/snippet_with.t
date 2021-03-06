use strict;
use warnings;

use App::Embra::Role::Snippet;

package Foo;
use Moo;

sub _build_fragment  { 'hi' }
sub _build_clipboard { 'hello' }

with 'App::Embra::Role::Snippet';

package main;

use Method::Signatures;
use Test::Roo;

has foo_plugin => (
    is => 'ro',
    default => method { Foo->new() },
);

test 'composes' => method {
    is(
        $self->foo_plugin->fragment,
        'hi',
        'composer has own fragment'
    );
};

run_me;

done_testing;
