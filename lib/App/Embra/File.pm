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
    '""' => method( $other, $swap ) { $self->name };

=attr name

The name of the file. Change this to change where the file will appear in the site. If only one argument is provided to the constructor, C<name> will be set to it.

=cut

has 'name' => (
    is => 'rw',
    required => 1,
);

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

The original name of this file. This is automatically saved from the C<name> attributes used to construct the object, and can't be altered.

=cut

has '_original_name' => (
  is  => 'ro',
  init_arg => undef,
);

=attr notes

A hash ref which stores extra values associated with the file. Transform plugins will read and write notes, and Assemble plugins will read notes.

=cut

has 'notes' => (
    is => 'ro',
    default => method { {} },
);

=attr ext

The extention of the file's C<name>. Changing this will cause the file's C<name> to be updated to match.

=cut

has 'ext' => (
    is => 'rw',
    lazy => 1,
    builder => 1,
    trigger => 1,
);

method _split_name {
    fileparse( $self->name, qr{ (?<= [.] ) [^.]+ $ }x );
}

method _build_ext {
    ($self->_split_name)[2];
}

=method with_ext

    $file->with_ext( $ext );

Returns file's name with its extension changed to <$ext>.

=cut

method with_ext( $ext ) {
    $ext =~ s/ \A [.] //xms;
    my ($f, $d, $e) = $self->_split_name;
    return $self->name if $e eq $ext;
    return canonpath( $d . $f . $ext );
}

method _trigger_ext( $old_ext ) {
    $self->name( $self->with_ext( $self->ext ) );
}

method BUILD( $args ) {
  $self->{_original_name} = $self->name;
}

method BUILDARGS( @args ) {
    if( @args == 1 ) {
        unshift @args, 'name';
    }
    return { @args };
}

=method update_notes

    $file->update_notes( %more_notes );

Merges C<%more_notes> into the file's existing notes.

=cut

method update_notes( %notes ) {
    @{ $self->notes }{ keys %notes } = values %notes;
}

1;
