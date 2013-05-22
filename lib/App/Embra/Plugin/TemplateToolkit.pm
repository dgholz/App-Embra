use strict;
use warnings;

package App::Embra::Plugin::TemplateToolkit;

# ABSTRACT: use Template::Toolkit to turn file content into HTML

use Moo;
use Method::Signatures;
use Template;
use Path::Class qw<>;

has 'include_path' => (
    is => 'ro',
    default => sub { 'templates' },
    coerce => sub { Path::Class::dir( $_[0] ) },
);

has 'default_template' => (
    is => 'lazy',
    default => method { 'default'. $self->extension },
);

has 'extension' => (
    is => 'ro',
    default => sub { '.tt' },
);

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
        $self->renderer->process( $template, $notes, \$rendered );
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
