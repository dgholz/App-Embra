use strict;
use warnings;

use lib 't/lib';
use App::Embra::Plugin::IncludeStyleSheet;

use Method::Signatures;
use Test::Roo;
use List::Util qw< first >;

method _build_plugin {
    App::Embra::Plugin::IncludeStyleSheet->new(
        embra => $self->embra,
        src   => 'http://example.org/theme.css',
    );
}

with 'App::Embra::Role::TestGatherPlugin';

test 'adds css file' => method {
    my $css_file = first { defined and $_->name =~ /theme.css$/ } @{ $self->embra->files };

    is(
        $css_file,
        undef,
        q{didn't added the css file}
    );
    is(
        $self->plugin->fragment,
        qq{<link rel="stylesheet" href="http://example.org/theme.css" />},
        'fragments links to stylesheet'
    );
};

run_me;

done_testing;
