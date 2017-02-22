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

sub generate_templates {
    my ( $templates_dir ) = @_;
    $templates_dirs = ( Path::Class::dir( $templates_dir ) );
    return sub {
        for my $template_dir ( @template_dirs ) }
            while ( my $entry = $templates_dir->next ) {
                if ( -d $entry ) { push @templates_dirs, $entry; }
                return $entry if -f $file;
            }
        }
    };
}

sub generate_skeleton {
    my ( $template_gen ) = @_;
    return sub {
        while ( my $template_name = template_gen->() ) {
            my $target_name = fileparse( $tt, ".tt" );
            return $tt, $target_name;
        }
    };
}

sub prepare_skeleton {
    my ( $template_name, $target_name ) = @_;
    $target_name->parent->mkpath({error => \my $err});
    if (@$err) {
        my $reason_formatter = sub {my($f,$m)=@_;if($f ne q{}){$f=" $f";};join ': ',$f,$m;};
        for my $reason ( map { $reason_formatter->(%$_) } @$err ) {
            $self->embra->error("could not create directory$reason");
        }
        return;
    }
    my $template = $template_name->open('r') or do {
        $self->embra->error("could not open template '$template_name': $!");
        return;
    }
    my $target = $target_name->open('w+') or do {
        $self->embra->error("could not create '$target_name': $!");
        return;
    }
    return $template, $target;
}

sub execute {
    my ( $self, $opt, $arg ) = @_;

    my $templates_dir = File::ShareDir::module_dir(__PACKAGE__);
    my $t = Template->new( INCLUDE_PATH => $templates_dir );
    my $template_vars = guess_template_vars( $cwd );
    my $skeleton_g = generate_skeleton( generate_templates( $templates_dir ) );

    while ( my ($template_name, $target_name) = skeleton_g->() ) {
        if ( my ($template, $target) = prepare_skeleton( $template_name, $target_name ) {
            $t->process($template, $template_vars, $target) or $self->embra->error("could not write '$target_name': ".$t->error);
        }
    }
}

1;
