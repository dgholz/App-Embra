use lib 't/lib';
use Test::Roo;
extends 'App::Embra::FromConfigMVP';
use Method::Signatures;
use Path::Class qw< dir >;

test 'excluded the right files' => method {
    $self->embra->collate;
    my @filesnames = sort map { $_->name } @{ $self->embra->files };
    is_deeply(
        \@filesnames,
        [ sort qw< xzxxy > ],
        'excluded the right files'
    );
};

run_me( {
    config => {
        'App::Embra::Plugin::GatherDir' => {
            from => 't/corpus/gatherdir',
            exclude_match => [ qw< /bie\z uu > ],
        }
    }
} );

done_testing;
