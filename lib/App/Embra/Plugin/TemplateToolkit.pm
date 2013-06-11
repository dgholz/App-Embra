use strict;
use warnings;

package App::Embra::Plugin::TemplateToolkit;

# ABSTRACT: use Template::Toolkit to turn file content into HTML

use Moo;
use Method::Signatures;
use Template;
use Path::Class qw<>;

=head1 DESCRIPTION

This plugin will process site files through Template Toolkit. For each file with a C<.html> extension, it will look for a template in the C<include_path> with a matching name and use it to process the contents of the file into a rendered HTML document.

Templates will be passed the file's content and body as variables, as well as each of the file's notes.

=cut

=attr include_path

Where to find templates. Defaults to F<templates> in the current directory.

=cut

has 'include_path' => (
    is => 'ro',
    default => sub { 'templates' },
    coerce => sub { Path::Class::dir( $_[0] ) },
);

=attr default_template

Template to use if a file doesn't have a matching template. Defaults to F<default.tt>.

=cut

has 'default_template' => (
    is => 'lazy',
    default => method { 'default'. $self->extension },
);

=attr extension

The extension of template files. Defaults to C<.tt>.

=cut

has 'extension' => (
    is => 'ro',
    default => sub { '.tt' },
);

=attr renderer

The object used to render files. Defaults to an instance of L<Template Toolkit|Template>.

=cut

has 'renderer' => (
    is => 'lazy',
);

method _build_renderer {
    Template->new({
        INCLUDE_PATH => $self->include_path,
        DEFAULT => $self->default_template,
        TRIM => 1,
    });
}

method render_files {
    for my $file ( @{ $self->embra->files } ) {
        next if $file->ext ne 'html';

        my $template = $file->with_ext( $self->extension );
        my $rendered;
        my $notes = {
            content => $file->content,
            name    => $file->name,
            %{ $file->notes },
        };
        use Try::Tiny;
        try {
            $self->renderer->process( $template, $notes, \$rendered ) or $self->debug( $self->renderer->error );
        } catch {
            $self->debug( $_ );
        };
        $file->content( $rendered );
        $file->notes->{rendered_by} = __PACKAGE__;
    }
}

method exclude_file( $file ) {
    return 1 if $self->include_path->subsumes( $file->name );
    return;
}

with 'App::Embra::Role::FileRenderer';
with 'App::Embra::Role::FilePruner';

1;
