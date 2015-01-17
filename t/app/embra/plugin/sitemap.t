use strict;
use warnings;

use lib 't/lib';
use App::Embra::Plugin::Sitemap;

use List::Util qw< first >;
use Method::Signatures;
use Test::Roo;

method _build_plugin {
    return App::Embra::Plugin::Sitemap->new(
        embra => $self->embra,
    );
}

with 'App::Embra::Role::TestGatherPlugin';
with 'App::Embra::Role::TestTransformPlugin';

test 'adds sitemap file' => method {
    my $sitemap_file = first { defined and $_->name eq 'sitemap.html' } @{ $self->embra->files };

    isnt(
        $sitemap_file,
        undef,
        'added a sitemap file ...'
    );
    is(
        $sitemap_file->content,
        '<ul><li><a href="sitemap.html">sitemap.html</a></li></ul>',
        '... with a list of links to the pages on the site as its cotents'
    );
};

run_me;

done_testing;
