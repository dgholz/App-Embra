use lib 't/lib';

use Method::Signatures;
use Test::Roo;

with 'App::Embra::StubConfig';
with 'App::Embra::FromConfigMVP';

test 'create from Config::MVP::Sequence' => method {
    is(
        scalar @{ $self->embra->plugins },
        1,
        'added plugin ...'
    );
    is(
        ref $self->embra->plugins->[0],
        'App::Embra::Plugin::Test',
        '... of the right class ...'
    );
    is(
        $self->embra->plugins->[0]->greeting,
        'howdy',
        '... with the right ctor args'
    );
};

run_me;

done_testing;
