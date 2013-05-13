use lib 't/lib';
use App::Embra::File;
use App::Embra::Plugin::DetectYamlFrontMatter;

use List::Util qw< first >;
use Test::Roo;
use Method::Signatures;

method _build_plugin {
    return App::Embra::Plugin::DetectYamlFrontMatter->new( embra => $self->embra );
}

with 'App::Embra::Role::TestTransformPlugin';

test 'detects frontmatter' => method {
    my $should_have_notes = first { defined and $_->name eq 'has YAML front matter' } @{ $self->embra->files };

    isnt(
        $should_have_notes,
        undef,
        'did not change name of file with YAML front matter ...'
    );
    is(
        $should_have_notes->notes->{hi},
        'there',
        '... and noted the value of the YAML front matter ...'
    );
    is(
        $should_have_notes->content,
        "hello\n",
        '... and removed the YAML front matter'
    );
};

test 'frontmatter not detected if not present' => method {
    my $should_not_have_notes = first { defined and $_->name eq 'no YAML front matter' } @{ $self->embra->files };

    isnt(
        $should_not_have_notes,
        undef,
        'did not change name of file with no YAML front matter ...'
    );
    is_deeply(
        $should_not_have_notes->notes,
        {},
        '... and did not add front matter ...'
    );
    is(
        $should_not_have_notes->content,
        <<EOM,
--
just some text
---
howdy
EOM
        '... and left content alone'
    );
};

run_me( {
    embra_files => [
        App::Embra::File->new(
            name => 'has YAML front matter',
            content => <<EOM,
---
hi: there
---
hello
EOM
        ),
        App::Embra::File->new(
            name => 'no YAML front matter',
            content => <<EOM,
--
just some text
---
howdy
EOM
        ),
    ],
});

done_testing;
