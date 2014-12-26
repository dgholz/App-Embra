use lib 't/lib';
use Test::Roo;
use Method::Signatures;

has config => (
    is => 'ro',
);

test 'stopped files from being processed' => method {
    $self->embra->collate;
    my @filesnames = sort map { $_->name } @{ $self->embra->files };
    is_deeply(
        \@filesnames,
        [ sort qw< foo/bie/bletch quux/quuux > ],
        'excluded the right files'
    );
};

with 'App::Embra::FromConfigMVP';

run_me( {
    config => {
        'App::Embra::Plugin::GatherDir' => {
            from => 't/corpus/gatherdir',
        },
        'App::Embra::Plugin::PruneFiles' => {
            filename => [ qw< xzxxy > ],
        },
    }
} );

done_testing;
