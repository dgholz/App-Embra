use lib 't/lib';
use Test::Roo;
extends 'App::Embra::FromConfigMVP';
use Method::Signatures;
use Path::Class qw< dir >;
use App::Embra::File;

{
    package Dist::Zilla::Plugin::Hello;
    use Moo;
    with 'Dist::Zilla::Role::BeforeRelease';
    has 'files' => (
        is => 'ro',
        default => sub {[]},
    );
    sub before_release {
        my( $self ) = @_;
        push @{ $self->files }, @{ $self->zilla->files };
    }
}

test 'fakes enough of Dist::Zilla to fool a plugin' => method {

    $self->embra->collate;

    my $foo = $self->embra->find_plugin( 'App::Embra::Plugin::WrapZillaPlugin' );
    is_deeply(
        $foo->plugin->files,
        [],
    );

};

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
