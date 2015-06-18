use strict;
use warnings;

use lib 't/lib';
use App::Embra::Plugin::Template::Basic;

use Method::Signatures;
use Test::Roo;
use FindBin;

use Test::File::ShareDir {
        '-root' => "$FindBin::Bin/../../../../..",
        '-share' => {
            '-module' => {
                'App::Embra::Plugin::Template::Basic' => 'share/',
            },
        },
    },
    qw< with_module_dir >
;

method _build_plugin {
    return App::Embra::Plugin::Template::Basic->new(
        embra => $self->embra,
    );
}

with 'App::Embra::Role::TestAssemblePlugin';

test 'ctor' => method {
    ok( $self->plugin );
};

test 'templates path' => method {
    ok( $self->plugin->templates_path );
};

run_me;

done_testing;
