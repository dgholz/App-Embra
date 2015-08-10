use strict;
use warnings;

use App::Embra::Role::Snippet;

package Foo;
use Moo;

sub _build_fragment  {}
sub _build_clipboard {}

with 'App::Embra::Role::Snippet';

package main;

use Method::Signatures;
use Test::Roo;

has foo_plugin => (
    is => 'ro',
    default => method { Foo->new( fragment => "foo", clipboard => 'test' ) },
);

test 'composes' => method {
    is(
        $self->foo_plugin->fragment,
        'foo',
        'composer has fragment ...'
    );
    is(
        $self->foo_plugin->clipboard,
        'test',
        '... and clipboard'
    );
};

run_me;

done_testing;
