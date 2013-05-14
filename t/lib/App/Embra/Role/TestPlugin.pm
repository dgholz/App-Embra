package App::Embra::Role::TestPlugin;
use Test::Roo::Role;

use App::Embra;

requires '_build_plugin';

has plugin => (
    is => 'lazy',
);

has embra_files => (
    is => 'ro',
    default => sub { [] },
);

has embra => (
    is => 'lazy',
);

sub _build_embra {
    App::Embra->new( files => shift->embra_files );
}

1;