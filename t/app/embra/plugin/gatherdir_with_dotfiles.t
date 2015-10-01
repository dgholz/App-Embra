use strict;
use warnings;

use lib 't/lib';

use Method::Signatures;
use Test::Roo;

test 'gathered all files including dotfiles' => method {
    $self->embra->collate;
    my @filesnames = sort map { $_->name } @{ $self->embra->files };
    is_deeply(
        \@filesnames,
        [ sort qw< .dont_include .ignore/this_file foo/bie/bletch quux/quuux xzxxy > ],
        'gathered the right files'
    );
};

with 'App::Embra::FromConfigMVP';

run_me( {
    config => {
        'GatherDir' => {
            from => 't/corpus/gatherdir',
            include_dotfiles => 1,
        }
    }
} );

done_testing;
