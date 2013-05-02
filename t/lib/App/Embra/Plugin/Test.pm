use strict;
use warnings;

package App::Embra::Plugin::Test;
use Moo;
with 'App::Embra::Role::Plugin';

has 'greeting' => (
    is => 'ro',
);

1;
