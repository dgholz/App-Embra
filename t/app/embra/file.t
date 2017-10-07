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
        [ 'bar', [ 'quux', 'quuux' ] ],
        'notes are updated with params passed to update_notes'
    );
};

test '_original_name saves name given to constructor' => method {
    $self->file->name( 'hello, me am file' );
    is(
        $self->file->_original_name,
        'hi im file',
        '_original_name matches name given to ctor'
    );
};

run_me;

done_testing;
