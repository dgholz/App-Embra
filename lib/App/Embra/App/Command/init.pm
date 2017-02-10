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
use Template;

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

No new options; the standard L<embra options|fApp::Embra::App::Command/GLOBAL OPTIONS> are available, including C<-g|--debug> to enable detailed progress logging.

=cut

{
    my $dir;
 
    sub get_templates {
        $dir ||= Path::Class::dir( @_ );
        while (my $file = $dir->next) {
            return $file if -f $file;
        }
        undef $dir;
    }

}

sub guess_template_vars {
    my ( $cwd ) = @_;

    my $username = getlogin;
    my $publisher = first { length } (split q{,}, getpw($username)->gecos)[0], $username, 'Anonymous';

    my $sitename = first { length } $cwd->basename, "${publisher}'s Site";

    return {
        publisher => $publisher,
        sitename => $sitename,
    };
}

sub execute {
    my ( $self, $opt, $arg ) = @_;

    my $templates_dir = File::ShareDir::module_dir(__PACKAGE__);
    my $t = Template->new( INCLUDE_PATH => $templates_dir );
    my $cwd = Path::Class::dir->absolute;
    my $template_vars = guess_template_vars( $cwd );

    while ( my $tt = get_templates( $templates_dir ) ) {
        open(my $emplate, q{<}, $tt) or $self->embra->error("could not open '$tt': $!");
        my $target_file = $cwd->file( scalar fileparse( $tt->relative( $templates_dir ), ".tt" ) );
        $target_file->parent->mkpath or $self->embra->error("could not create '".$target_file->parent."': $!");
        my $target = $target_file->open('w+') or $self->embra->error("could not create '$target_file': $!");
        $t->process($tt, $template_vars, $target) or $self->embra->error('could not write target config: '.$t->error);
    }
}

1;
