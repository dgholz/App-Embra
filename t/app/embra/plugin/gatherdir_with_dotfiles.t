use lib 't/lib';
use Test::Roo;
extends 'App::Embra::FromConfigMVP';
use Method::Signatures;
use Path::Class qw< dir >;

test 'gathered all files including dotfiles' => method {
    $self->embra->collate;
    my @filesnames = sort map { $_->_original_name } @{ $self->embra->files };
    my $corpus = dir( 't/corpus/gatherdir' );
    is_deeply(
        \@filesnames,
        [ sort map { $corpus->file( $_ ) } qw< .dont_include .ignore/this_file foo/bie/bletch quux/quuux xzxxy > ],
        'gathered the right files'
    );
};

run_me( {
    config => {
        'App::Embra::Plugin::GatherDir' => {
            from => 't/corpus/gatherdir',
            include_dotfiles => 1,
        }
    }
} );

done_testing;