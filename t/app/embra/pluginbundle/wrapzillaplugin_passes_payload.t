use strict;
use warnings;

use lib 't/lib';

use Method::Signatures;
use Test::Roo;
use App::Embra::PluginBundle::WrapZillaPlugin;
use List::Util qw< first >;

method _build_plugin {
    App::Embra::PluginBundle::WrapZillaPlugin->new(
        foo   => 'bar',
        quux  => 1,
        quuux => [ 9..17 ],
    );
}

test 'WrapZillaPlugin passes payload to Zilla' => method {

    $self->plugin->configure_bundle;
    my $zilla = first { $_->[1] eq 'App::Embra::Plugin::Zilla' } @{ $self->plugin->bundled_plugins };

    is_deeply
        { @{ $zilla->[2] } },
        {
            foo   => 'bar',
            quux  => 1,
            quuux => [ 9..17 ],
        },
        'passed args from config to Zilla';

};

with 'App::Embra::Role::TestPlugin';

run_me;

done_testing;
