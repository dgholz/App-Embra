use lib 't/lib';
use Test::Roo;
extends 'App::Embra::FromConfigMVP';
use Method::Signatures;
use Path::Class qw< dir >;

test 'stopped files from being processed' => method {
    $self->embra->collate;
    my @filesnames = sort map { $_->_original_name } @{ $self->embra->files };
    my $corpus = dir( 't/corpus/gatherdir' );
    is_deeply(
        \@filesnames,
        [ sort map { $corpus->file( $_ ) } qw< foo/bie/bletch quux/quuux xzxxy > ],
        'excluded the right files'
    );
};

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
