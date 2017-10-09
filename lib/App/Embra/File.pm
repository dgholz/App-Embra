use strict;
use warnings;

package App::Embra::File;

# ABSTRACT: a file from your site

use File::Basename;
use File::Spec::Functions qw< canonpath >;
use Method::Signatures;
use Moo;

# mostly Dist::Zilla::File::OnDisk

=head1 DESCRIPTION

This represents a file to be included in your site. In string context, returns the path to the file.

=cut

use overload fallback => 1,
    '""' => method( @_ ) { $self->name };

=attr name

The path to the file. Change this to change where the file will appear in the site. If only one argument is provided to the constructor, C<name> will be set to it.

=cut

has 'name' => (
    is => 'rw',
    required => 1,
);

method BUILDARGS( @args ) {
    if( @args == 1 ) {
        unshift @args, 'name';
    }
    return { @args };
}

=attr content

The contents of the file in the site. Defaults to the contents of C<L</_original_name>>.

=cut

has 'content' => (
  is      => 'rw',
  lazy    => 1,
  builder => 1,
);

method _build_content {
  my $fname = $self->_original_name;
  open my $fh, '<', $fname or die "can't open $fname for reading: $!";

  binmode $fh, ':raw';

  my $content = do { local $/; <$fh> };
}

=attr mode

The permissions of the file. Defaults to 0644.

=cut

has 'mode' => (
  is  => 'rw',
  lazy => 1,
  default => method { oct(644) },
);

=attr _original_name

The original name of this file. This is automatically saved from the C<L</name>> attribute used to construct the object, and can't be altered.

=cut

has '_original_name' => (
  is  => 'rwp',
  init_arg => undef,
);

method BUILD( @args ) {
    $self->_set__original_name( $self->name );
}

=attr notes

A hash ref which stores extra values associated with the file. It is read and written by L<Transform|App::Embra::Role::FileTransformer> plugins. Defaults to an empty hash ref.

=cut

has 'notes' => (
    is => 'ro',
    default => method { {} },
);

=attr ext

The extension of the file's C<L</name>>. Changing this will cause the file's C<L</name>> attribute to be updated to match.

=cut

# I lied, this is actually a couple of methods, since this 'attribute'' is wholely dependent on $self->name

method _split_name {
    fileparse( $self->name, "?x)(?: [.] ) ( [^.]+ " );
}

method ext( $ext? ) {
    if ( defined $ext ) {
        $self->name( $self->with_ext( $ext ) );
    } else {
        ($self->_split_name)[2];
    }
}

=method with_ext

    my $file = App::Embra::File->new( 'filename.txt' );
    my $ext = 'html';
    $file->with_ext( $ext ); # filename.html
    $file->with_ext( '.md' ); # filename.md

Returns L</name> with its extension changed to C<$ext>. The leading period on C<$ext> is automatically stripped. If C<$ext> is undef, the empty string, or not supplied, returns L</name> with the last extension removed.

    my $file = App::Embra::File->new('hi.hello.howdy');
    my $stripped_ext = $file->with_ext( q{} ); # hi.hello
    App::Embra::File->new( $stripped_ext )->with_ext(); # hi

=cut

method with_ext( $ext = undef when q{} ) {
    my ($f, $d, $e) = $self->_split_name;
    return canonpath( $d . $f ) if not defined $ext;
    $ext =~ s/ \A [.] //xms;
    return $self->name if $e eq $ext;
    return canonpath( $d . $f . q{.} . $ext );
}

=method update_notes

    $file->update_notes( %more_notes );

Merges C<%more_notes> into the file's notes.

=cut

method update_notes( %notes ) {
    @{ $self->notes }{ keys %notes } = values %notes;
}

1;
