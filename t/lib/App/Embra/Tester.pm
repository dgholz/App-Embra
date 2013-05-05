package App::Embra::Tester;
use Test::Roo;

use App::Embra;
use App::Embra::Plugin::Test;

has embra => (
    is => 'ro',
    default => sub { App::Embra->new },
);

has plugin => (
    is => 'lazy',
    default => sub { App::Embra::Plugin::Test->new( embra => $_[0]->embra ) },
);

1;
