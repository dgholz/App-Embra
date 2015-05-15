use strict;
use warnings;

package App::Embra::Role::FileAssembler;

# ABSTRACT: something that assembles file content into its publishable form

use Method::Signatures;
use Moo::Role;

=head1 DESCRIPTION

This role should be implemented by any plugin which alters a file's content into its final format. It requires plugins provide a C<assemble_files> method, which will be called late in the process of collating your site.

Plugins which implement this role can access the site's files via the C<L<files|App::Embra/files>> attribute of its C<L<embra|App::Embra::Role::Plugin/embra>> attribute.

=cut

with 'App::Embra::Role::Plugin';

requires 'assemble_files';

1;
