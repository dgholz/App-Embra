use strict;
use warnings;

use lib 't/lib';
use App::Embra::Plugin::IncludeJavaScript;

use List::Util qw< first >;
use Method::Signatures;
use Test::Roo;

method _build_plugin {
    App::Embra::Plugin::IncludeJavaScript->new(
        embra => $self->embra,
        src   => 'parallax.js',
    );
}

with 'App::Embra::Role::TestGatherPlugin';

test 'adds js file' => method {
    my $js_file = first { defined and $_->name eq 'parallax.js' } @{ $self->embra->files };

    isnt(
        $js_file,
        undef,
        'added the js file'
    );
    is(
        $self->plugin->fragment,
        qq{<script src="parallax.js"></script>},
        'fragments links to javascript ...'
    );
    is(
        $self->plugin->clipboard,
        'body',
        '... and indicates it should go in body'
    );
};

run_me;

done_testing;
