use strict;
use warnings;

package App::Embra::Plugin::Cname;

# ABSTRACT: adds a file containing the site's canonical domain name

use Moo;
use Method::Signatures;

use App::Embra::File;

=head1 DESCRIPTION

This plugin will add a F<CNAME> file to the site. Use this plugin if you are hosting the site L<on GitHub with a custom domain name|https://help.github.com/articles/setting-up-a-custom-domain-with-pages#setting-the-domain-in-your-repo>.

=cut

=attr domain

The canonical domain name for the site (the host part of its URI). This is required.

=cut

has 'domain' => (
    is => 'ro',
    required => 1,
);

=attr filename

The filename to store the site's canonical domain name in. It defaults to F<CNAME>.

=cut

has 'filename' => (
    is => 'ro',
    default => sub { 'CNAME' },
);

method gather_files {
    $self->add_file( App::Embra::File->new( name => $self->filename, content => $self->domain ) );
}

with 'App::Embra::Role::FileGatherer';

1;
