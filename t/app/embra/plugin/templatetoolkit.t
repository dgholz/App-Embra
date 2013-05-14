use lib 't/lib';
use App::Embra::File;
use App::Embra::Plugin::TemplateToolkit;

use List::Util qw< first >;
use Test::Roo;
use Method::Signatures;

method _build_plugin {
    return App::Embra::Plugin::TemplateToolkit->new(
        embra => $self->embra,
        include_path => 't/corpus/tt_templates',
    );
}

with 'App::Embra::Role::TestRenderPlugin';

test 'renders from default template' => method {
    my $should_be_html = first { defined and $_->name eq 'render me.html' } @{ $self->embra->files };

    isnt(
        $should_be_html,
        undef,
        'did not change name of rendered file ...'
    );
    is(
        $should_be_html->notes->{rendered_by},
        'App::Embra::Plugin::TemplateToolkit',
        '... and noted that it rendered the file ...'
    );
    is(
        $should_be_html->content,
        '<html><body>hello</body></html>',
        '... and rendered the file'
    );
};

test 'renders from non-default template' => method {
    my $should_be_html = first { defined and $_->name eq 'with_vars.html' } @{ $self->embra->files };

    isnt(
        $should_be_html,
        undef,
        'changed name of rendered file ...'
    );
    is(
        $should_be_html->notes->{rendered_by},
        'App::Embra::Plugin::TemplateToolkit',
        '... and noted that it rendered the file ...'
    );
    is(
        $should_be_html->content,
        '<html><title>A Brief Interlude</title><body><h1>HI MA</h1>howdy</body></html>',
        '... and rendered the file'
    );
};

run_me( {
    embra_files => [
        App::Embra::File->new(
            name => 'render me.html',
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
    ],
});

done_testing;
