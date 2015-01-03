use lib 't/lib';

use Method::Signatures;
use Test::Roo;

has 'config' => (
    is => 'ro',
);

test 'gathered the right files' => method {
    $self->embra->collate;
    my @filesnames = sort map { $_->name } @{ $self->embra->files };
    is_deeply(
        \@filesnames,
        [ sort qw< foo/bie/bletch quux/quuux xzxxy > ],
        'gathered the right files'
    );
};

with 'App::Embra::FromConfigMVP';

run_me( {
    config => {
        'App::Embra::Plugin::GatherDir' => {
            from => 't/corpus/gatherdir',
        }
    }
} );

done_testing;
