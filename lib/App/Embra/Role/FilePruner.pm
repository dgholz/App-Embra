use strict;
use warnings;

package App::Embra::Role::FilePruner;

# ABSTRACT: something that prevents files from being published in your site

use List::MoreUtils qw< part >;
use Method::Signatures;
use Moo::Role;

=head1 DESCRIPTION

This should be consumed by plugins who want their C<exclude_file> method called for every file gathered into your site. That method should accept a single L<App::Embra::File> object, and return true if the file should not be published (otherwise it should return false).

The C<exclude_file> method will be called from the role's C<prune_files> method; this makes this role different to the other FileFoo roles, which expect the consuming plugin to provied a C<foo_files> method & call the role's C<foo_file> method.

=cut

with 'App::Embra::Role::Plugin';

requires 'exclude_file';

=method prune_files

    $plugin->prune_files;

Calls C<< $self->exclude_file >> for each elemnt in C<< $self->embra->files >>, and removes the element if the method returns true.

This method handles updating C<< $self->embra->files >> in-place (since it's a read-only attribute of L<App::Embra>).

=cut

method prune_files {
    my $files = $self->embra->files;
    my ($remove, $keep) = part { ! $self->exclude_file( $_ ) } @{ $files };

    $self->debug( "pruning $_" ) for @{ $remove };
    splice @{ $files }, 0, @{ $files }, @{ $keep };

    return;
}

=head1 OTHER ROLES FOR WORKING WITH FILES

=for :list
* L<FileGatherer|App::Embra::Role::FileGatherer> to add new files
* L<FileTransformer|App::Embra::Role::FileTransformer> to significantly change files
* L<FileAssembler|App::Embra::Role::FileAssembler> to prepare files to be published

=cut

1;
