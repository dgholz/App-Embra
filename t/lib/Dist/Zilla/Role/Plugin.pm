use strict;
use warnings;

package Dist::Zilla::Role::Plugin;
use Moo::Role;

has 'zilla' => (
    is       => 'ro',
    required => 1,
);

has 'plugin_name' => (
    is       => 'ro',
    required => 1,
);

has 'logger' => (
    is       => 'ro',
    required => 1,
);

1;
