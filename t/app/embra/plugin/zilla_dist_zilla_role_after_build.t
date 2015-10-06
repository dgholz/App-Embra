use strict;
use warnings;

use lib 't/lib';
use App::Embra::Plugin::Zilla;

use Method::Signatures;
use Test::Roo;

has 'dist_zilla_plugin_name' => (
    is => 'ro',
    default => 'DoAfterBuild',
);

with 'App::Embra::Role::TestZilla';

test 'AfterBuild' => method {
    $self->plugin->publish_site();
    is_deeply(
        [ grep { /DoAfterBuild/ } @{ $self->embra->files } ],
        [ 'Dist::Zilla::Plugin::DoAfterBuild' ],
        'DoAfterBuild ran'
    );
};

run_me();

done_testing;
