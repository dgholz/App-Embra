use strict;
use warnings;

package App::Embra::Role::SitePublisher;

# ABSTRACT: something that publishs files into a site

use Method::Signatures;
use Moo::Role;

=head1 DESCRIPTION

This should be consumed by plugins who want their C<publish_site> method called when the files are published. That method should examine C<< $self->embra->files >>, and publish those files into a site.

=cut

with 'App::Embra::Role::Plugin';

requires 'publish_site';

1;
