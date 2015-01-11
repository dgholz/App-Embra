use strict;
use warnings;

use lib 't/lib';
use App::Embra::File;
use App::Embra::Plugin::WrapZillaPlugin;

use Method::Signatures;
use Test::Roo;

method _build_plugin {
    return App::Embra::Plugin::WrapZillaPlugin->new( embra => $self->embra, name => 'Wrap::Me' );
}

with 'App::Embra::Role::TestPlugin';

{
    package Dist::Zilla::Role::Plugin;
    use Moo::Role;
}

{
    package Wrap::Me;
    use Moo;
    with 'Dist::Zilla::Role::Plugin';
}

test 'creates instance of wrapped plugin ...' => method {
    isa_ok $self->plugin->plugin, 'Wrap::Me';
};

run_me();

done_testing;
