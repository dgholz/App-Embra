use lib 't/lib';
use Test::Roo;
use Method::Signatures;
use App::Embra;
use Test::MockObject;

has 'config_mvp_sequence' => (
    is => 'lazy',
    default => method {
        use Config::MVP::Reader::Hash;
        Config::MVP::Reader::Hash->read_config( $self->config );
    },
);

has 'config' => (
    is => 'ro',
    default => method {
        {
            _ => {
                __package => 'App::Embra',
            },
            'App::Embra::Plugin::Test' => {
                greeting => 'howdy',
            },
        };
    },
);

test 'create from Config::MVP::Sequence' => method {
    my $e = App::Embra->from_config_mvp_sequence( sequence => $self->config_mvp_sequence );
    is(
        scalar @{ $e->plugins },
        1,
        'added plugin ...'
    );
    is(
        ref $e->plugins->[0],
        'App::Embra::Plugin::Test',
        '... of the right class ...'
    );
    is(
        $e->plugins->[0]->greeting,
        'howdy',
        '... with the right ctor args'
    );
};

run_me;

done_testing;
