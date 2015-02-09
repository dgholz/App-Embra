use strict;
use warnings;

package App::Embra::Role::FilePruner;

# ABSTRACT: something that stops files from appearing in a site

use List::MoreUtils qw< part >;
use Method::Signatures;
use Moo::Role;

=head1 DESCRIPTION

This role should be implemented by any plugin which prevents files from appearing in your site. It provides one method (C<L</prune_files>>), and requires plugins provide an C<exclude_file> method, which accepts a single L<App::Embra::File> object and return true if the file should be removed.

C<prune_files> will be called after all L<FileGatherer|App::Embra::Role::FileGatherer>-type plugins have added files, and will remove from the site all files which cause C<L</exclude_file>> to return true.

=cut

with 'App::Embra::Role::Plugin';

requires 'exclude_file';

=method prune_files

    $plugin->prune_files;

Passes each of the site's files to the plugin's C<exclude_file> method, and removes the file from the site if the method returns true.

=cut

method prune_files {
    my $files = $self->embra->files;
    my ($remove, $keep) = part { ! $self->exclude_file( $_ ) } @{ $files };

    $self->debug( "pruning $_" ) for @{ $remove };
    splice @{ $files }, 0, @{ $files }, @{ $keep };

    return;
}

1;

