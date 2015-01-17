use strict;
use warnings;

package App::Embra::Plugin::PublishFiles;

# ABSTRACT: write site files into a directory

use Path::Class qw<>;
use Method::Signatures;
use Moo;

=head1 DESCRIPTION

This plugin creates your site in a directory. The name of each file is used as the path to write its content to, relative to the destination directory.

This plugin additionally prunes already-published files from the list of files to include in the site. This is useful if your L<App::Embra::Role::FileGather> plugins find the L</to> directory and add the previous version of the published site to be re-published.

=cut

=attr to

The directory where site files will be written. Defaults to F<.> (the current directory).

=cut

has 'to' => (
    is => 'ro',
    required => 1,
    default => '.',
    coerce => func( $path_as_str ) { Path::Class::dir( $path_as_str ) },
);

method publish_site {
    for my $file ( @{ $self->embra->files } ) {
        my $f = $self->to->file( $file->name );
        $f->parent->mkpath;
        $f->spew( $file->content );
        chmod $file->mode, $f or die "could't chmod $file: $!";
    }
}

method exclude_file( $file ) {
    return 1 if $self->to->subsumes( $file->name );
    return;
}

with 'App::Embra::Role::SitePublisher';
with 'App::Embra::Role::FilePruner';

1;
