use strict;
use warnings;

use lib 't/lib';

use Method::Signatures;
use Test::Roo;

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
        'GatherDir' => {
            from => 't/corpus/gatherdir',
        },
        'PruneFiles' => {
            filename => [ qw< xzxxy > ],
        },
    }
} );

done_testing;
