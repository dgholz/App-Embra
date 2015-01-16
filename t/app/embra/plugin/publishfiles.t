use strict;
use warnings;

use lib 't/lib';
use App::Embra::File;
use App::Embra::Plugin::PublishFiles;

use List::Util qw< first >;
use Method::Signatures;
use Path::Class qw<>;
use Test::Roo;

has output_dir => (
    is => 'ro',
    default => sub { Path::Class::tempdir( CLEANUP => 1 ) },
);

has published_files => (
    is => 'ro',
    default => sub { {} },
);

method _build_plugin {
    return App::Embra::Plugin::PublishFiles->new(
        embra => $self->embra,
        to => $self->output_dir,
    );
}

with 'App::Embra::Role::TestPrunePlugin';
with 'App::Embra::Role::TestPublishPlugin';

after setup => method {
    $self->output_dir->recurse( callback => func( $file ) {
        return if $file->is_dir;
        $self->published_files->{ $file->relative( $self->output_dir )->stringify } = $file->slurp;
    } );
};

test 'publishes files' => method {
    is_deeply(
        $self->published_files,
        {
            'foo' => 'bar',
            'quux/quuux' => 'quuuux',
        },
        'published the expected files'
    );
};

test 'prunes files in publish dir' => method {
    my $should_be_pruned = first { defined and $_->name eq $self->output_dir.'/prune me' } @{ $self->embra->files };

    is(
        $should_be_pruned,
        undef,
        'pruned files which were already in the directory to publish to'
    );
};

before '_build_embra' => method( @_ ) {
    push @{ $self->embra_files }, App::Embra::File->new(
        name => $self->output_dir.'/prune me',
    );
};

run_me( {
    embra_files => [
        App::Embra::File->new(
            name => 'foo',
            content => 'bar',
        ),
        App::Embra::File->new(
            name => 'quux/quuux',
            content => 'quuuux',
        ),
    ],
});

done_testing;
