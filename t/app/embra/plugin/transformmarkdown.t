use lib 't/lib';
use App::Embra::File;
use App::Embra::Plugin::TransformMarkdown;

use List::Util qw< first >;
use Method::Signatures;
use Test::Roo;

method _build_plugin {
    return App::Embra::Plugin::TransformMarkdown->new( embra => $self->embra );
}

with 'App::Embra::Role::TestTransformPlugin';

test 'tranforms markdown files' => method {
    my $should_transform = first { defined and $_->name eq 'transform me.html' } @{ $self->embra->files };

    isnt(
        $should_transform,
        undef,
        'changed the name of markdown file to indicate it is now html ...'
    );
    is(
        $should_transform->notes->{transformed_by},
        'App::Embra::Plugin::TransformMarkdown',
        '... and noted that the file was converted by the plugin ...'
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
    ok(
        ! exists $should_not_transform->notes->{transformed_by},
        '... and did not note that the file was converted by the plugin ...'
    );
    is(
        $should_not_transform->content,
        "can't touch this\n================\n",
        '... and did not transform the file'
    );
};

run_me( {
    embra_files => [
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
