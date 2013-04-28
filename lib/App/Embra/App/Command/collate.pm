use strict;
use warnings;

package App::Embra::App::Command::collate;

# ABSTRACT: collate your site

use App::Embra::App -command;

sub abstract { 'collate your site'; }

sub execute {
    my ( $self, $opt, $arg ) = @_;
    $self->embra->collate;
}

1;
