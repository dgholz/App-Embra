use strict;
use warnings;

use lib 't/lib';
use App::Embra::Role::IncludeFromSrc;

package Foo;
use Moo;

with 'App::Embra::Role::IncludeFromSrc';

package main;

use List::Util qw< first >;
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
        '... and href'
    );
};

test 'gathers local file' => method {

    $self->plugin->gather_files;
    my $hi_file = first { defined and $_->name eq 'hi' } @{ $self->embra->files };
    isnt(
        $hi_file,
        undef,
        'adds local file when files are gathered'
    );
};

with 'App::Embra::Role::TestPlugin';

run_me;

done_testing;
