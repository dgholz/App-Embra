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
  default => method { shift->_read_file },
);
 
has '_original_name' => (
  is  => 'ro',
  init_arg => undef,
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

1;
