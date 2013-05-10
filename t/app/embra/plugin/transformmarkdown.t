use lib 't/lib';
use Test::Roo;
use Method::Signatures;
use App::Embra::File;
use List::Util qw< first >;

extends 'App::Embra::FromConfigMVP';

has 'test_files' => (
    is => 'ro',
    default => method {
        App::Embra::File->new( name => 'dummy', content => 'mannequin' );
    },
);

before 'setup' => method {
    push @{ $self->embra->files }, @{ $self->test_files };
    $self->embra->collate;
};

test 'tranforms markdown files' => method {
    my $should_transform = first { defined and $_->name eq 'transform me.md' } @{ $self->embra->files };

    isnt(
        $should_transform,
        undef,
        'did not change name of markdown file ...'
    );
    is(
        $should_transform->notes->{converted_from},
        'markdown',
        '... and noted that the file was converted from markdown ...'
    );
    is(
        $should_transform->content,
        "<h1>I am a file</h1>\n",
        '... and transformed the file'
    );
};

test 'does not tranforms non-markdown files' => method {
    my $should_not_transform = first { defined and $_->name eq 'do not transform me' } @{ $self->embra->files };

    isnt(
        $should_not_transform,
        undef,
        'did not change name of untransformed file ...'
    );
    is(
        $should_not_transform->content,
        "can't touch this\n================\n",
        '... and did not transform the file'
    );
};

run_me( {
    config => {
        'App::Embra::Plugin::TransformMarkdown' => {
        },
    },
    test_files => [
        App::Embra::File->new(
            name => 'transform me.md',
            content => <<EOM,
I am a file
===========
EOM
        ),
        App::Embra::File->new(
            name => 'do not transform me',
            content => <<EOM,
can't touch this
================
EOM
        ),
    ],
});

done_testing;
