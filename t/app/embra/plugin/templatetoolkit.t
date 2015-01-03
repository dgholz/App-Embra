use lib 't/lib';
use App::Embra::File;
use App::Embra::Plugin::TemplateToolkit;

use List::Util qw< first >;
use Method::Signatures;
use Test::Roo;

method _build_plugin {
    return App::Embra::Plugin::TemplateToolkit->new(
        embra => $self->embra,
        include_path => 't/corpus/tt_templates',
    );
}

with 'App::Embra::Role::TestAssemblePlugin';
with 'App::Embra::Role::TestPrunePlugin';

test 'assembles from default template' => method {
    my $should_be_html = first { defined and $_->name eq 'assemble me.html' } @{ $self->embra->files };

    isnt(
        $should_be_html,
        undef,
        'did not change name of assembled file ...'
    );
    is(
        $should_be_html->notes->{assembled_by},
        'App::Embra::Plugin::TemplateToolkit',
        '... and noted that it assembled the file ...'
    );
    is(
        $should_be_html->content,
        '<html><body>hello</body></html>',
        '... and assembled the file'
    );
};

test 'assembles from non-default template' => method {
    my $should_be_html = first { defined and $_->name eq 'with_vars.html' } @{ $self->embra->files };

    isnt(
        $should_be_html,
        undef,
        'changed name of assembled file ...'
    );
    is(
        $should_be_html->notes->{assembled_by},
        'App::Embra::Plugin::TemplateToolkit',
        '... and noted that it assembled the file ...'
    );
    is(
        $should_be_html->content,
        '<html><title>A Brief Interlude</title><body><h1>HI MA</h1>howdy</body></html>',
        '... and assembled the file'
    );
};

test 'prunes files in include_path' => method {
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
            name => 'assemble me.html',
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
