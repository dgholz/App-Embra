use strict;
use warnings;

package App::Embra::Role::FileTransformer;

# ABSTRACT: something that transforms file content from one format into another

use Moo::Role;

=head1 DESCRIPTION

This should be consumed by plugins who want their C<transform_files> method called before the files are published. That method should examine C<< $self->embra->files >> to find files which meet the criteria of the plugin, and tranform their content into a new form (which includes adding new files wut content derived from some matching file).

=cut

with 'App::Embra::Role::Plugin';

requires 'transform_files';

=head1 OTHER ROLES FOR WORKING WITH FILES

=for :list
* L<FileGatherer|App::Embra::Role::FileGatherer> to add new files
* L<FilePruner|App::Embra::Role::FilePruner> to remove already-added files
* L<FileAssembler|App::Embra::Role::FileAssembler> to prepare files to be published

=cut

1;
