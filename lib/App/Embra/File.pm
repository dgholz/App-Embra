use strict;
use warnings;

package App::Embra::File;

# ABSTRACT: a file from your site

use Moo;
use Method::Signatures;
use File::Basename;
use File::Spec::Functions qw< canonpath >;

has 'name' => (
    is => 'rw',
    required => 1,
);

has 'content' => (
  is  => 'rw',
  lazy => 1,
  default => method { $self->_read_file },
);

has '_original_name' => (
  is  => 'ro',
  init_arg => undef,
);

has 'notes' => (
    is => 'ro',
    default => method { {} },
);

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

method _read_file {
  my $fname = $self->_original_name;
  open my $fh, '<', $fname or die "can't open $fname for reading: $!";

  binmode $fh, ':raw';

  my $content = do { local $/; <$fh> };
}

method update_notes( HashRef $update ) {
    @{ $self->notes }{ keys %$update } = values %$update;
}

1;
