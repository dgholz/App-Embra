use strict;
use warnings;

use lib 't/lib';
use App::Embra::Plugin::Zilla;

use Method::Signatures;
use Test::Roo;

package Dist::Zilla::Plugin::For::Sure;
use Moo;

with 'Dist::Zilla::Role::Plugin';

has 'certainty' => (
    is => 'ro',
    default => 100,
);

package main;

method _build_plugin {
    return App::Embra::Plugin::Zilla->new(
        embra => $self->embra,
        name => 'For::Sure',
    );
}

with 'App::Embra::Role::TestPlugin';

test 'creates instance of wrapped plugin ...' => method {
    isa_ok $self->plugin->plugin, 'Dist::Zilla::Plugin::For::Sure';
};

run_me();

done_testing;
