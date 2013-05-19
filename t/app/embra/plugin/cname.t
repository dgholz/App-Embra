use lib 't/lib';

use App::Embra::Plugin::Cname;

use List::Util qw< first >;
use Test::Roo;
use Method::Signatures;

method _build_plugin {
    return App::Embra::Plugin::Cname->new(
        embra => $self->embra,
        domain => 'www.example.org',
        filename => 'my domain',
    );
}

with 'App::Embra::Role::TestGatherPlugin';

test 'adds cname file' => method {
    my $cname_file = first { defined and $_->name eq 'my domain' } @{ $self->embra->files };

    isnt(
        $cname_file,
        undef,
        'added a cname file ...'
    );
    is(
        $cname_file->content,
        'www.example.org',
        '... with the domain name of the site as its contents'
    );
};

run_me;

done_testing;
