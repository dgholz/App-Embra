use lib 't/lib';
use Test::Roo;
use Method::Signatures;

has config => (
    is => 'ro',
);

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
        'App::Embra::Plugin::GatherDir' => {
            from => 't/corpus/gatherdir',
            include_dotfiles => 1,
        }
    }
} );

done_testing;
