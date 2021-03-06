use strict;
use warnings;

package App::Embra::App::Command::collate;

# ABSTRACT: collate your site

use App::Embra::App -command;

=head1 SYNOPSIS

    embra collate

=head1 DESCRIPTION

This command is a very thin layer over L<App::Embra/collate>, which does all the things required to collate your site.

=cut

sub abstract { 'collate your site'; }

=head1 EXAMPLE

    $ embra collate

=cut

=head1 OPTIONS

No new options; the standard L<embra options|App::Embra::App::Command/GLOBAL OPTIONS> are available, including C<-g|--debug> to enable detailed progress logging.

=cut

sub execute {
    my ( $self, $opt, $arg ) = @_;
    $self->embra->collate;
}

1;
