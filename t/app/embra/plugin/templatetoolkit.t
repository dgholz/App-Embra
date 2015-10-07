use strict;
use warnings;

use lib 't/lib';
use App::Embra::File;
use App::Embra::Plugin::TemplateToolkit;

use List::Util qw< first >;
use Method::Signatures;
use Test::Roo;

method _build_plugin {
    return App::Embra::Plugin::TemplateToolkit->new(
        embra => $self->embra,
        templates_path => 't/corpus/tt_templates',
    );
}

with 'App::Embra::Role::TestTransformPlugin';
with 'App::Embra::Role::TestPrunePlugin';

test 'transforms from default template' => method {
    my $should_be_html = first { defined and $_->name eq 'transform me.html' } @{ $self->embra->files };

    isnt(
        $should_be_html,
        undef,
        'did not change name of transformed file ...'
    );
    is(
        $should_be_html->notes->{transformed_by},
        'App::Embra::Plugin::TemplateToolkit',
        '... and noted that it transformed the file ...'
    );
    is(
        $should_be_html->content,
        '<html><body>hello</body></html>',
        '... and transformed the file'
    );
};

test 'transforms from non-default template' => method {
    my $should_be_html = first { defined and $_->name eq 'with_vars.html' } @{ $self->embra->files };

    isnt(
        $should_be_html,
        undef,
        'changed name of transformed file ...'
    );
    is(
        $should_be_html->notes->{transformed_by},
        'App::Embra::Plugin::TemplateToolkit',
        '... and noted that it transformed the file ...'
    );
    is(
        $should_be_html->content,
        '<html><title>A Brief Interlude</title><body><h1>HI MA</h1>howdy</body></html>',
        '... and transformed the file'
    );
};

test 'prunes files in templates_path' => method {
    my $should_be_pruned = first { defined and $_->name eq 't/corpus/tt_templates/prune me' } @{ $self->embra->files };

    is(
        $should_be_pruned,
        undef,
        'pruned template files'
    );
};

run_me( {
    embra_files => [
        App::Embra::File->new(
            name => 'transform me.html',
            content => 'hello',
        ),
        App::Embra::File->new(
            name => 'with_vars.html',
            content => 'howdy',
            notes => {
                title => 'A Brief Interlude',
                header => 'HI MA',
            },
        ),
        App::Embra::File->new(
            name => 't/corpus/tt_templates/prune me',
        ),
    ],
});

done_testing;
