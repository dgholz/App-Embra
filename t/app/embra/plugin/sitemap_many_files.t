use strict;
use warnings;

use lib 't/lib';
use App::Embra::File;
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

before 'setup' => method {
    for my $fake_file ( qw< hi hello.html howdy hey.html > ) {
        my $file = App::Embra::File->new( name => $fake_file );
        $self->plugin->add_file( $file );
    }
};

test 'lists all HTML files' => method {
    is(
        $self->plugin->sitemap_file->content,
        '<ul><li><a href="hello.html">hello.html</a></li><li><a href="hey.html">hey.html</a></li><li><a href="sitemap.html">Sitemap</a></li></ul>',
        'sitemap has list of links to all pages in the site'
    );
};

run_me;

done_testing;
