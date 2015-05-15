use strict;
use warnings;

package App::Embra::Plugin::GatherDir;

# ABSTRACT: gather all the files in a directory

use Path::Class::Dir;
use List::MoreUtils qw< any >;
use Method::Signatures;

use App::Embra::File;
use Moo;

method mvp_multivalue_args() { qw< exclude_match >; }

=head1 SYNOPSIS

    # in embra.ini
    [GatherDir]
    from = my_site_dir
    include_dotfiles = 0
    exclude_match = _draft$
    exclude_match = ^secret

=cut

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
    coerce => sub { Path::Class::Dir->new( $_[0] )->absolute },
);

=attr include_dotfiles

Whether to consider files and directories beginning with C<.> (dot) when gathering files. Defaults to false.

=cut

has 'include_dotfiles' => (
    is => 'ro',
    default => sub { !1 },
);

=attr exclude_match

A regular expression to match files which should not be gathered. May be used multiple times to specify multiple patterns to exclude.

=cut

has 'exclude_match' => (
    is => 'ro',
    coerce => sub { [ map { qr{$_} } @{ $_[0] } ] },
    default => sub { [] },
);

method gather_files {
    $self->debug( 'looking in '.$self->from );
    $self->from->recurse( callback => func( $file ) {
        return if $file eq $self->from;
        my $skip = $file->basename =~ m/ \A [.] /xms && not $self->include_dotfiles;
        my $exclude = any { $file =~ $_ } @{ $self->exclude_match };
        return $file->PRUNE if $file->is_dir and $skip || $exclude;
        return if $file->is_dir;
        $self->debug( "considering $file" );
        return if $skip or $exclude;
        my $embra_file = App::Embra::File->new( name => $file->stringify );
        $embra_file->name( $file->relative( $self->from )->stringify );
        $self->add_file( $embra_file );
    } );
}

with 'App::Embra::Role::FileGatherer';

1;
