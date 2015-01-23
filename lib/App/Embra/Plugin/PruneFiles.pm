use strict;
use warnings;

package App::Embra::Plugin::PruneFiles;

# ABSTRACT: exclude files from the site

use List::MoreUtils qw< any >;
use Method::Signatures;
use Moo;

=head1 DESCRIPTION

This plugin will remove files from the site and prevent them from being processed.

In your F<embra.ini>:

  [PruneFiles]
  filename = not_this_file
  filename = dont_even_think_about_publishing_this

=cut

=attr filename

Name of file to exclude. May be used multiple times to exclude multiple files.

=cut

has 'filename' => (
    is => 'ro',
    default => sub { [] },
);

method mvp_multivalue_args() { qw< filename >; }

method exclude_file( $file ) {
    return 1 if any { $_ eq $file->name } @{ $self->filename };
    return;
}

with 'App::Embra::Role::FilePruner';

1;