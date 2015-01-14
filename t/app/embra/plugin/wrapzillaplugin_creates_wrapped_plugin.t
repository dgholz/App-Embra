use strict;
use warnings;

use lib 't/lib';
use App::Embra::Plugin::WrapZillaPlugin;

use Method::Signatures;
use Test::Roo;

method _build_plugin {
    return App::Embra::Plugin::WrapZillaPlugin->new(
        embra => $self->embra,
        name => '-For::Sure',
    );
}

with 'App::Embra::Role::TestPlugin';

test 'creates instance of wrapped plugin ...' => method {
    isa_ok $self->plugin->plugin, 'Dist::Zilla::Plugin::For::Sure';
};

run_me();

done_testing;
