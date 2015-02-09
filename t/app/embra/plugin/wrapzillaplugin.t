use strict;
use warnings;

use lib 't/lib';
use App::Embra::File;

use Method::Signatures;
use Test::Roo;

has 'config' => (
    is => 'ro',
);

{
    package Dist::Zilla::Plugin::Hello;
    use Moo;
    extends 'Dist::Zilla::Plugin::DoBeforeRelease';
    has 'files' => (
        is => 'ro',
        default => sub {[]},
    );
    sub before_release {
        my( $self ) = @_;
        push @{ $self->files }, @{ $self->zilla->files };
    }
}

test 'fake enough of Dist::Zilla to fool a plugin' => method {

    $self->embra->collate;

    my $foo = $self->embra->find_plugin( 'App::Embra::Plugin::WrapZillaPlugin' );
    is_deeply(
        $foo->plugin->files,
        [],
    );

};

with 'App::Embra::FromConfigMVP';

run_me( {
    embra_files => [
        App::Embra::File->new( name => "hi", content => "hello" ),
    ],
    config => {
        '-Hello' => {
            __package => 'App::Embra::Plugin::WrapZillaPlugin',
        }
    },
} );

done_testing;
