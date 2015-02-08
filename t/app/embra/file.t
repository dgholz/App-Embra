use strict;
use warnings;

use lib 't/lib';
use App::Embra::File;

use Method::Signatures;
use Test::Roo;

has 'file' => (
    is => 'ro',
    default => method { App::Embra::File->new(name => 'hi im file') },
);

test 'update notes on file' => method {
    $self->file->update_notes( foo => 'bar', baz => [ qw< quux quuux > ] );

    is_deeply(
        [ @{ $self->file->notes }{qw<foo baz>} ],
        [ 'bar', [ 'quux', 'quuux' ]],
        'hi'
    );
};

run_me;

done_testing;
