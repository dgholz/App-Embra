use strict;
use warnings;

use lib 't/lib';
use App::Embra::Role::IncludeFromSrc;

package Foo;
use Moo;

with 'App::Embra::Role::IncludeFromSrc';

package main;

use List::Util qw< first >;
use Method::Signatures;
use Test::Roo;

method _build_plugin {
    Foo->new(
        src => 'http://hello',
        embra => $self->embra,
    );
}

test 'composes' => method {
    is(
        $self->plugin->src,
        'http://hello',
        'composer has src ...'
    );
    is(
        $self->plugin->href,
        'http://hello',
        '... and href'
    );
};

test q{doesn't gather local file} => method {

    ok(
        ! $self->plugin->is_local,
        'src is not local ...'
    );
    $self->plugin->gather_files;
    my $hello_file = first { defined and $_->name =~ /hello/ } @{ $self->embra->files };
    is(
        $hello_file,
        undef,
        q{... and file isn't added when files are gathered}
    );
};

with 'App::Embra::Role::TestPlugin';

run_me;

done_testing;
