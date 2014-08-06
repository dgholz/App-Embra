use strict;
use warnings;

package App::Embra::Role::SitePublisher;

# ABSTRACT: something that publishs files to a site

use Method::Signatures;
use Moo::Role;

=head1 DESCRIPTION

This role should be implemented by any plugin which publishes your site. It requires plugins provide a C<publish_site> method, which will be called as the final step of collating your site.

Plugins which implement this role can access the site's files via the C<L<files|App::Embra/files>> attribute of its C<L<embra|App::Embra::Role::Plugin/embra>> attribute, and should publish all files.

=cut

with 'App::Embra::Role::Plugin';

requires 'publish_site';

1;

