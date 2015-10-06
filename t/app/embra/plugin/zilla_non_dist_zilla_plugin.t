use strict;
use warnings;

use lib 't/lib';
use App::Embra::Plugin::Zilla;

use Test::Exception;
use Method::Signatures;
use Test::Roo;

method _build_plugin {
    return App::Embra::Plugin::Zilla->new(
        embra => $self->embra,
        name => '=Dist::Zilla::Not::A::Plugin',
    );
}

with 'App::Embra::Role::TestPlugin';

test q{ctor checks whether name is a Dist::Zilla::Role::Plugin} => method {
    throws_ok { $self->plugin->plugin } qr/can't wrap/, 'refused to wrap a non-Dist::Zilla plugin';
};

run_me;

done_testing;
