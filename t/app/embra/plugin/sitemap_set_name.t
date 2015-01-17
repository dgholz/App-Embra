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
        filename => 'Site Directory',
    );
}

with 'App::Embra::Role::TestGatherPlugin';

test 'adds sitemap file with specific name' => method {
    my $sitemap_file = first { defined and $_->name eq 'Site Directory' } @{ $self->embra->files };

    isnt(
        $sitemap_file,
        undef,
        'added a sitemap file with name specified in ctor' 
    );
};

run_me;

done_testing;
