use strict;
use warnings;

package App::Embra::Plugin::Cname;

# ABSTRACT: adds a file containing the site's canonical domain name

use Moo;
use Method::Signatures;

use App::Embra::File;

has 'domain' => (
    is => 'ro',
);

has 'filename' => (
    is => 'ro',
    default => sub { 'CNAME' },
);

method gather_files {
    $self->add_file( App::Embra::File->new( name => $self->filename, content => $self->domain ) );
}

with 'App::Embra::Role::FileGatherer';

1;
