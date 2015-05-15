use strict;
use warnings;

use lib 't/lib';
use App::Embra::Plugin::IncludeJavaScript;

use Method::Signatures;
use Test::Roo;
use List::Util qw< first >;

method _build_plugin {
    App::Embra::Plugin::IncludeJavaScript->new(
        embra => $self->embra,
        src   => 'http://example.org/parallax.js',
    );
}

with 'App::Embra::Role::TestGatherPlugin';

test 'adds js file' => method {
    my $js_file = first { defined and $_->name =~ /parallax.js$/ } @{ $self->embra->files };

    is(
        $js_file,
        undef,
        q{didn't added the js file}
    );
    is(
        $self->plugin->fragment,
        qq{<script src="http://example.org/parallax.js"></script>},
        'fragments links to javascript'
    );
};

run_me;

done_testing;
