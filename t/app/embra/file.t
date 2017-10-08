use strict;
use warnings;

use lib 't/lib';
use App::Embra::File;

use Method::Signatures;
use Test::Roo;

has 'file' => (
    is => 'lazy',
    clearer => 1,
    default => method { App::Embra::File->new(name => 'hi im file.cool extension') },
);

after each_test => sub { shift->clear_file };

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
        'hi im file.cool extension',
        '_original_name matches name given to ctor'
    );
};

test 'setting name also sets extension' => method {
    $self->file->name( 'new file name.with ext' );
    is(
        $self->file->ext,
        'with ext',
        'extension gets set when name changes'
    );
    $self->file->name( 'another file name' );
    is(
        $self->file->ext,
        '',
        q{extension gets cleared when new name doesn't have one}
    );
};

test 'ext set from ctor' => method {
    is(
        $self->file->ext,
        'cool extension',
        'ext is set from extension of name given to ctor'
    );
};

test 'changing ext changes name' => method {
    $self->file->ext( 'another ext' );
    is(
        $self->file->name,
        'hi im file.another ext',
        'name got a new extension when ext changed'
    );
};

run_me;

done_testing;
