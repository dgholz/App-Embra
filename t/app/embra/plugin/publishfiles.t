use lib 't/lib';
use App::Embra::File;

use App::Embra::Plugin::PublishFiles;

use List::Util qw< first >;
use Test::Roo;
use Method::Signatures;
use Path::Class qw<>;

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
