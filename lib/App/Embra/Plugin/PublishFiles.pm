use strict;
use warnings;

package App::Embra::Plugin::PublishFiles;

# ABSTRACT: write site files into a directory

use Path::Class qw<>;
use Method::Signatures;
use Moo;

=head1 SYNOPSIS

In your F<embra.ini>:

    [PublishFiles]
    to = heres_my_site_directory

=cut

=head1 DESCRIPTION

This plugin creates your site in a directory. The name of each file is used as the path to write its content to, relative to the destination directory.

This plugin also prunes files in C<L</to>> from your site. This is to stop the contents of C<to> from being published again, if your L<gatherer|App::Embra::Role::FileGather> plugins finds it and adds it to your site again.

=cut

=attr to

The directory where site files will be written. Defaults to F<.> (the current directory).

=cut

has 'to' => (
    is => 'ro',
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
