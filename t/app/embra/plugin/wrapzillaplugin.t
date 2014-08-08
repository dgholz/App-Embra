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
    my $fake_file = App::Embra::File( name => "hi", content => "hellow" );
    push @{ $self->embra->files }, $fake_file;

    $self->embra->collate;

    my $foo = grep { $_->name eq 'Hello' } @{ $self->embra->plugins };
    my $bar = grep { $_->name eq 'Dist::Zilla::Plugin::Hello' } @{ $foo->plugins };
    is_deeply(
        $bar->files,
        [ $fake_file ],
    );

};

run_me( {
    config => {
        'Hello' => {
            __package => 'App::Embra::Plugin::Zilla',
        }
    }
} );

done_testing;
