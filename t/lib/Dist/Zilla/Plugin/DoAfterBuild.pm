use strict;
use warnings;

package Dist::Zilla::Role::AfterBuild;
use Moo::Role;

with 'Dist::Zilla::Role::Plugin';

package Dist::Zilla::Plugin::DoAfterBuild;
use Method::Signatures;
use Moo;

method after_build( @_ ) { push @{ $self->zilla->files}, __PACKAGE__; }

with 'Dist::Zilla::Role::AfterBuild';

1;
