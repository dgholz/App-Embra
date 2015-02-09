use strict;
use warnings;

use App::Embra::Plugin::Snippet;

package main;

use Method::Signatures;
use Test::Roo;

has plugin => (
    is => 'ro',
    default => method { App::Embra::Plugin::Snippet->new( fragment => "foo", clipboard => 'test' ) },
);

test 'ctor' => method {
    is(
        $self->plugin->fragment,
        'foo',
        'snippet has fragment ...'
    );
    is(
        $self->plugin->clipboard,
        'test',
        '... and clipboard'
    );
};

run_me;

done_testing;
