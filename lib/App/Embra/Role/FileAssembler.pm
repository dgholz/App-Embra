use strict;
use warnings;

package App::Embra::Role::FileAssembler;

# ABSTRACT: something that assembles file content into its publishable form

use Moo::Role;

=head1 DESCRIPTION

This should be consumed by plugins who want their C<assemble_files> method called just before the site is published. That method should examine C<< $self->embra->files >> to find files which meet the criteria of the plugin, and alter them into their final publishable form.

=cut

with 'App::Embra::Role::Plugin';

requires 'assemble_files';

=head1 OTHER ROLES FOR WORKING WITH FILES

=for :list
* L<FileGatherer|App::Embra::Role::FileGatherer> to add new files
* L<FilePruner|App::Embra::Role::FilePruner> to remove already-added files
* L<FileTransformer|App::Embra::Role::FileTransformer> to significantly change files

=cut

1;
