use strict;
use warnings;

use lib 't/lib';
use App::Embra::Plugin::WrapZillaPlugin;

use Test::Exception;
use Method::Signatures;
use Test::Roo;

method _build_plugin {
    use Carp::Always;
    return App::Embra::Plugin::WrapZillaPlugin->new(
        embra => $self->embra,
        name => 'TestPlugin',
    );
}

with 'App::Embra::Role::TestPlugin';

{
    package Dist::Zilla::Role::Plugin;
    use Moo::Role;
    has 'zilla' => (
        is => 'ro',
    );

    package TestPlugin;;
    use Moo;

    has 'files' => (
        is => 'ro',
        default => sub {[]},
    );
}

test q{ctor checks whether name is a Dist::Zilla::Role::Plugin} => method {
    throws_ok { $self->plugin } qr/can't wrap/, 'refused to wrap a non-Dist::Zilla plugin';

    package TestPlugin;
    with 'Dist::Zilla::Role::Plugin';

    package main;
    lives_ok { $self->plugin } 'wrapped a Dist::Zilla plugin';
};

run_me;

done_testing;
