use strict;
use warnings;

use lib 't/lib';
use App::Embra::Plugin::Sitemap;

use Method::Signatures;
use Test::Roo;

method _build_plugin {
    return App::Embra::Plugin::Sitemap->new(
        embra => $self->embra,
    );
}

with 'App::Embra::Role::TestGatherPlugin';

test 'lists all HTML files' => method {
    is(
        $self->plugin->sitemap_file->content,
        '',
        'sitemap is empty before getting transformed'
    );
};

run_me;

done_testing;
