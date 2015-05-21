use strict;
use warnings;

use lib 't/lib';
use App::Embra::File;
use App::Embra::Plugin::SnippetsToNotes;
use App::Embra::Role::Snippet;
use App::Embra::Role::Plugin;

package TestSnippet;
use Moo;

sub _build_fragment  { 'TestSnippet' }
sub _build_clipboard { 'test' }

with 'App::Embra::Role::Snippet';
with 'App::Embra::Role::Plugin';

package main;

use Method::Signatures;
use Test::Roo;

method _build_plugin {
    return App::Embra::Plugin::SnippetsToNotes->new( embra => $self->embra );
}

after setup => method {
    TestSnippet->register_plugin( embra => $self->embra );
};

with 'App::Embra::Role::TestTransformPlugin';

test 'add snippets to notes' => method {
    my $file = $self->embra->files->[0];

    is_deeply(
        $file->notes->{snippets}->{test},
        [ 'TestSnippet' ],
        'snippet plugins added to file notes'
    );
};

run_me( {
    embra_files => [
        App::Embra::File->new(
            name => 'hi',
            content => 'im file',
        ),
    ],
});

done_testing;
