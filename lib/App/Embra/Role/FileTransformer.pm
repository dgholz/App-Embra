use strict;
use warnings;

package App::Embra::Role::FileTransformer;

# ABSTRACT: something that transforms file content, but not into its publishable form

use Method::Signatures;
use Moo::Role;

=head1 DESCRIPTION

This role should be implemented by any plugin which alters a file's content. It requires plugins provide a C<transform_files> method, which will be called early in the process of collating your site.

Plugins which implement this role can access the site's files via the C<L<files|App::Embra/files>> attribute of its C<L<embra|App::Embra::Role::Plugin/embra>> attribute.

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
