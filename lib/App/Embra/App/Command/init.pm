use strict;
use warnings;

package App::Embra::App::Command::init;

# ABSTRACT: initialises a new site

use App::Embra::App -command;
use List::Util qw< first >;
use User::pwent;
use Path::Class;
use File::Basename; # for fileparse
use File::ShareDir;
use Cwd qw< cwd >;

=head1 SYNOPSIS

    embra init

=head1 DESCRIPTION

This command creates some minimal Embra config in the current directory. It guesses the name & publisher of the site, based on the current working directory & user's full name.

It creates a simple F<embra.ini> & a F<Makefile>.

=cut

sub abstract { 'initialise a new site'; }

=head1 EXAMPLE

    $ embra init

=cut

=head1 OPTIONS

No new options; the standard L<embra options|App::Embra::App::Command/GLOBAL OPTIONS> are available, including C<-g|--debug> to enable detailed progress logging.

=cut

sub guess_template_vars {
    my ( $cwd ) = @_;

    my $username = getlogin;
    my $publisher = first { length } (split q{,}, getpw($username)->gecos)[0], $username, 'Anonymous';

    my $sitename = first { length } $cwd->basename, "${publisher}'s Site";

    return (
        publisher => $publisher,
        sitename => $sitename,
    );
}

sub embra {
    my ( $self, $v ) = @_;
    if ( scalar @_ > 1 ) {
        return $self->{embra} = $v;
    }
    return $self->{embra} if defined $self->{embra};

    require App::Embra;
    require App::Embra::MVP::Assembler;
    require Config::MVP::Reader::INI;

    my $templates_dir = File::ShareDir::module_dir(__PACKAGE__);
    (my $config = <<"") =~ s/^\s+//gms;
      [GatherDir]
      from = $templates_dir
      
      [TemplateToolkit]
      source_file_ext = *
      
      [PublishFiles]

    my $assembler = App::Embra::MVP::Assembler->new();
    my $reader = Config::MVP::Reader::INI::INIReader->new($assembler);
    $reader->read_string($config);

    return $self->{embra} = App::Embra->from_config_mvp_sequence( sequence => $assembler->sequence );
}


sub execute {
    my ( $self, $opt, $arg ) = @_;

    my %template_vars = guess_template_vars( dir( cwd ) );
    for my $file ( @{ $self->embra->files } ) {
        $file->update_notes( %template_vars );
    }
    $self->embra->collate;
}

1;
