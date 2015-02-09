use strict;
use warnings;

use lib 't/lib';
use App::Embra::Plugin::Favicon;
use App::Embra::File;
use List::Util qw< first >;

use Method::Signatures;
use Test::Roo;

method _build_plugin {
    return App::Embra::Plugin::Favicon->new(
        embra => $self->embra,
    );
}

with 'App::Embra::Role::TestGatherPlugin';

test 'adds favicon file' => method {
    my $favicon_file = first { defined and $_->name eq 'favicon.ico' } @{ $self->embra->files };

    isnt(
        $favicon_file,
        undef,
        'added a favicon file'
    );
    like(
        $self->plugin->fragment,
        qr/href="favicon.ico"/,
        'HTML fragment for favicon looks sane'
    );

};

run_me;

done_testing;
