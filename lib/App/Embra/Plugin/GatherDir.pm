use strict;
use warnings;

package App::Embra::Plugin::GatherDir;

# ABSTRACT: gather all the files in a directory

use Moo;
use Method::Signatures;

use App::Embra::File;
use Path::Class::Dir;

=head1 DESCRIPTION

This plugin recursively add all files in a directory to the site.

=cut

=attr from

The directory to gather files from. Defaults to F<.> (the current directory).

=cut

has 'from' => (
    is => 'ro',
    required => 1,
    default => sub { '.' },
    coerce => sub { Path::Class::Dir->new( $_[0] ) },
);

=attr include_dotfiles

Whether to consider files and directories beginning with C<.> (dot) when gathering files. Defaults to false.

=cut

has 'include_dotfiles' => (
    is => 'ro',
    default => sub { !1 },
);

method gather_files {
    $self->debug( 'gathering a *lot* of files' );
    $self->info( 'yay files' );
    $self->from->recurse( callback => func( $file ) {
        my $skip = $file->basename =~ m/ \A [.] /xms && not $self->include_dotfiles;
        return $file->PRUNE if $file->is_dir and $skip;
        return if $file->is_dir;
        return if $skip;
        $self->add_file( App::Embra::File->new( name => $file->stringify ) );
    } );
}

with 'App::Embra::Role::FileGatherer';

1;
