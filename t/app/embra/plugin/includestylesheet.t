use strict;
use warnings;

use lib 't/lib';
use App::Embra::Plugin::IncludeStyleSheet;

use List::Util qw< first >;
use Method::Signatures;
use Test::Roo;

method _build_plugin {
    App::Embra::Plugin::IncludeStyleSheet->new(
        embra => $self->embra,
        src   => 'theme.css',
    );
}

with 'App::Embra::Role::TestGatherPlugin';

test 'adds css file' => method {
    my $css_file = first { defined and $_->name eq 'theme.css' } @{ $self->embra->files };

    isnt(
        $css_file,
        undef,
        'added the css file'
    );
    is(
        $self->plugin->fragment,
        qq{<link rel="stylesheet" href="theme.css" />},
        'fragments links to stylesheet ...'
    );
    is(
        $self->plugin->clipboard,
        'head',
        '... and indicates it should go in the head'
    );
};

run_me;

done_testing;
