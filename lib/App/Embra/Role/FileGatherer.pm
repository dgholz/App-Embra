use strict;
use warnings;

package App::Embra::Role::FileGatherer;

# ABSTRACT: something that adds file to your site

use Method::Signatures;
use Moo::Role;

=head1 DESCRIPTION

This role should be implemented by any plugin which plans to add files to your site. It provides one method (C<L</add_file>>), and requires plugins provide a C<gather_files> method.

C<gather_files> will be called early in the site collation process, and is expected to call the provided C<L</add_file>> method for each file it wishes to include in the site.

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

1;
