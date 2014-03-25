use strict;
use warnings;

package App::Embra::Plugin::PruneFiles;

# ABSTRACT: exclude files from the site

use Moo;
use Method::Signatures;
use List::MoreUtils qw< any >;

=head1 DESCRIPTION

This plugin will remove files from the site and prevent them from being processed.

In your F<embra.ini>:

  [PruneFiles]
  filename = not_this_file
  filename = dont_even_think_about_publishing_this

=cut

=attr filename

Name of file to exclude. It can be specified multiple times in your F<embra.ini>.

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
