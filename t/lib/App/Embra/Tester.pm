package App::Embra::Tester;
use Test::Roo;

use App::Embra;
use App::Embra::Plugin::Test;

has embra => (
    is => 'ro',
    default => sub { App::Embra->new },
);

has plugin => (
    is => 'ro',
    default => sub { App::Embra::Plugin::Test->new },
);

1;
