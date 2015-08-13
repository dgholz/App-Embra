use strict;
use warnings;

package App::Embra::Role::FileGatherer;

# ABSTRACT: something that adds files to your site

use Method::Signatures;
use Moo::Role;

=head1 DESCRIPTION

This should be consumed by plugins who want their C<gather_files> method called as soon as the site collation starts. That method should call C<< L<$self->add_file( $file )|/add_file> >> (provided by this role) to include files in the site when it is published.

=cut

with 'App::Embra::Role::Plugin';

requires 'gather_files';

=method add_file

    $plugin->add_file( $app_embra_file );

This adds a file to the site.

=cut

method add_file( App::Embra::File $file ) {
    $self->debug( "gathered $file" );
    push @{ $self->embra->files }, $file;
}

=head1 OTHER ROLES FOR WORKING WITH FILES

=for :list
* L<FilePruner|App::Embra::Role::FilePruner> to remove already-added files
* L<FileTransformer|App::Embra::Role::FileTransformer> to significantly change files
* L<FileAssembler|App::Embra::Role::FileAssembler> to prepare files to be published

=cut

1;
