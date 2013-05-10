use strict;
use warnings;

package App::Embra::File;

# ABSTRACT: a file from your site

use Moo;
use Method::Signatures;

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
