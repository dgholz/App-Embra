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
    config => {
        'App::Embra::Plugin::DetectYamlFrontMatter' => {
        },
    },
    test_files => [
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
