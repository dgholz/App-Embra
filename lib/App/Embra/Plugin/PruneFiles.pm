use strict;
use warnings;

package App::Embra::Plugin::PruneFiles;

# ABSTRACT: stops chosen files from being published

use List::MoreUtils qw< any >;
use Method::Signatures;
use Moo;

=head1 SYNOPSIS

    [PruneFiles]
    filename = not_this_file
    filename = dont_even_think_about_publishing_this

=cut

=head1 DESCRIPTION

This plugin will remove files matching C<L</filename>> from the site before the site is processed and published.

=cut

=attr filename

Exact name of file to exclude. May be used multiple times to exclude multiple files.

=cut

has 'filename' => (
    is => 'ro',
    default => sub { [] },
);

method mvp_multivalue_args() { qw< filename > }

method exclude_file( $file ) {
    return 1 if any { $_ eq $file->name } @{ $self->filename };
    return;
}

with 'App::Embra::Role::FilePruner';

1;
