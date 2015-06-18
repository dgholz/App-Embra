use strict;
use warnings;

package App::Embra::Plugin::TemplateToolkit;

# ABSTRACT: use Template::Toolkit to turn file content into HTML

use Template;
use Path::Class qw<>;
use Method::Signatures;
use Moo;

=head1 SYNOPSIS

    # embra.ini
    [TemplateToolkit]
    templates_path = templates # default

=cut

=head1 DESCRIPTION

This plugin will process site files through Template Toolkit. For each file with an C<html> extension, it will look for a template in the C<templates_path> with a matching name and use it to process the contents of the file into an assembled HTML document.

Templates will be passed the file's content and body as variables, as well as each of the file's notes.

=cut

=attr templates_path

Where to find templates. Defaults to F<templates> in the current directory. All files within the path will be pruned, to prevent them from appearing in the published version of the site.

=cut

has 'templates_path' => (
    is => 'ro',
    default => sub { 'templates' },
    coerce => sub { Path::Class::dir( $_[0] ) },
);

=attr default_template

Which template to use if a file doesn't have a matching template. Defaults to F<default.tt>.

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

=attr assembler

The object used to assemble files. Defaults to an instance of L<Template Toolkit|Template>.

=cut

has 'assembler' => (
    is => 'lazy',
);

method _build_assembler {
    Template->new({
        INCLUDE_PATH => $self->templates_path,
        DEFAULT => $self->default_template,
        TRIM => 1,
    });
}

method assemble_files {
    for my $file ( @{ $self->embra->files } ) {
        next if $file->ext ne 'html';

        my $template = $file->with_ext( $self->extension );
        my $assembled;
        my $notes = {
            content => $file->content,
            name    => $file->name,
            %{ $file->notes },
        };
        use Try::Tiny;
        try {
            $self->assembler->process( $template, $notes, \$assembled ) or $self->debug( $self->assembler->error );
        } catch {
            $self->debug( $_ );
        };
        $file->content( $assembled );
        $file->notes->{assembled_by} = __PACKAGE__;
    }
}

method exclude_file( $file ) {
    return 1 if $self->templates_path->subsumes( $file->name );
    return;
}

with 'App::Embra::Role::FileAssembler';
with 'App::Embra::Role::FilePruner';

1;
