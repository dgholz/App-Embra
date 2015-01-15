use strict;
use warnings;

use lib 't/lib';
use App::Embra::Plugin::WrapZillaPlugin;

use Method::Signatures;
use Test::Roo;

has 'dist_zilla_plugin_name' => (
    is => 'ro',
    default => '-DoBeforeRelease',
);

with 'App::Embra::Role::TestWrapZillaPlugin';

test 'BeforeRelease' => method {
    $self->plugin->publish_site();
    is_deeply(
        [ grep { /DoBeforeRelease/ } @{ $self->embra->files } ],
        [ 'Dist::Zilla::Plugin::DoBeforeRelease' ],
        'DoBeforeRelease ran'
    );
};

run_me();

done_testing;
