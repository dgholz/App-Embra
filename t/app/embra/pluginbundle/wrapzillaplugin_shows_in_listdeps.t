use strict;
use warnings;

use lib 't/lib';

use Method::Signatures;
use Test::Roo;
use App::Embra::App::Command::listdeps;
use List::Util qw< first >;

method _create_seq( @_ ) {
    $self->_build_config_mvp_sequence( @_ );
}

test 'WrapZillaPlugin adds wrapped plugin to list of dependencies' => method {

    my $listdeps = App::Embra::App::Command::listdeps->new({ app => $self });
    my $deps = $listdeps->_get_deps;
    my $wrapped = first { exists $_->{'Dist::Zilla::Plugin::Foo'} } @{ $deps };

    isnt(
        $wrapped,
        undef,
        q{wrapped plugin appears in embra's list of deps}
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
