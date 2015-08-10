use strict;
use warnings;

package App::Embra::Plugin::Sitemap;

# ABSTRACT: adds a file which lists the pages in the site

use Template;

use App::Embra::File;
use Method::Signatures;
use Moo;

=head1 SYNOPSIS

    # embra.ini
    [Sitemap]
    filename = My_pages.html

=cut

=head1 DESCRIPTION

This plugin will add a F<sitemap.html> file to your site, with a list of links to all the HTML pages in your site.

=cut

=attr filename

Name of the name to store the sitemap in. Defaults to F<sitemap.html>.

=cut

has 'filename' => (
    is => 'ro',
    default => 'sitemap.html',
);

=attr sitemap_file

The L<App::Embra::File> for the sitemap. It will be created automatically with the name given in L</filename>.

=cut

has 'sitemap_file' => (
    is => 'lazy',
    default => method { App::Embra::File->new( name => $self->filename, content => '', notes => { title => $self->title, }, ) },
);

=attr title

The title for the sitemap page. Defaults to C<Sitemap>.

=cut

has 'title' => (
    is      => 'lazy',
    default => 'Sitemap',
);

# not sure about this, might remove
has 'template' => (
    is => 'lazy',
    default => method { Template->new },
);

# not sure about this, might remove
has 'sitemap_template' => (
    is => 'ro',
    default => '<ul>[% FOREACH page IN pages %]<li><a href="[% page.name %]">[% page.notes.title or page.name %]</a></li>[% END %]</ul>',
);

method gather_files {
    $self->add_file( $self->sitemap_file );
}

method transform_files {
    my @html_files = grep { $_->ext eq 'html' } @{ $self->embra->files };
    my $sm;
    my $vars = { pages => \@html_files };
    $self->template->process( \ $self->sitemap_template, $vars, \$sm );
    $self->sitemap_file->content( $sm );
}

with 'App::Embra::Role::FileGatherer';
with 'App::Embra::Role::FileTransformer';

1;
