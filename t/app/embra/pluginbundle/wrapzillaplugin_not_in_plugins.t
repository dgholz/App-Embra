use strict;
use warnings;

use lib 't/lib';

use Method::Signatures;
use Test::Roo;
use List::Util qw< first >;

test 'WrapZillaPlugin adds wrapped plugin to list of dependencies' => method {

    my $wrapped = first { ref $_ eq 'Dist::Zilla::Plugin::Foo' } @{ $self->embra->plugins };

    is(
        $wrapped,
        undef,
        q{wrapped plugin doesn't appears in embra's list of plugins}
    );

};

with 'App::Embra::FromConfigMVP';

run_me( {
    config => {
        'Foo' => {
            __package => '@WrapZillaPlugin',
        }
    },
} );

done_testing;
