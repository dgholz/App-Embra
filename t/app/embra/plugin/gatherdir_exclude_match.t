use strict;
use warnings;

use lib 't/lib';

use Method::Signatures;
use Test::Roo;

test 'excluded the right files' => method {
    $self->embra->collate;
    my @filesnames = sort map { $_->name } @{ $self->embra->files };
    is_deeply(
        \@filesnames,
        [ sort qw< xzxxy > ],
        'excluded the right files'
    );
};

with 'App::Embra::FromConfigMVP';

run_me( {
    config =>  {
        'GatherDir' => {
            from => 't/corpus/gatherdir',
            exclude_match => [ qw< /bie\z uu > ],
        }
    },
});

done_testing;
