use strict;
use warnings;

package Dist::Zilla::Role::BeforeRelease;
use Moo::Role;

with 'Dist::Zilla::Role::Plugin';

package Dist::Zilla::Plugin::DoBeforeRelease;
use Method::Signatures;
use Moo;

method before_release( @_ ) { push @{ $self->zilla->files}, __PACKAGE__; }

with 'Dist::Zilla::Role::BeforeRelease';

1;

