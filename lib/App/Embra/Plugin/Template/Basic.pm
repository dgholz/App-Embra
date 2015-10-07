use strict;
use warnings;

package App::Embra::Plugin::Template::Basic;

# ABSTRACT: simple HTML5 template

use App::Embra::Plugin::TemplateToolkit;
use File::ShareDir;
use Method::Signatures;
use Moo;

=head1 SYNOPSIS

    # embra.ini
    [Template::Basic]

=cut

=head1 DESCRIPTION

This plugin will process site files through L<Template Toolkit|Template> with a pre-defined set of templates. For each file with a C<.html> extension, it will look for a template with a matching name (or use the default template). That template is then used to process the contents of the file into an transformd HTML document.


=cut

=attr templates_path

Where to look for templates.

This plugin defines some minimal templates in a L<File::ShareDir>. They are (in source of the distribution) at C<share/Plugin/Template/Basic>, and (installed on your host) at C<perl -MApp::Embra::Plugin::Template::Basic -e'print App::Embra::Plugin::Template::Basic->_build_templates_path, "\n"'>.

If you want to use your own templates. use L<TemplateToolkit|App::Embra::Plugin::TemplateToolkit> directly.

=cut

has 'templates_path' => (
    is      => 'ro',
    builder => 1,
);

func _build_templates_path($cls) {
    File::ShareDir::module_dir(__PACKAGE__),
}

=attr transformer

The object used to transform files. Defaults to an instance of L<App::Embra::Plugin::TemplateToolkit> with its C<INCLUDE_PATH> set to L<C<templates_path>|/templates_path>. This plugin delegates L<C<transform_files>|App::Embra::Role::Filetransformer> to the transformer.

=cut

has 'transformer' => (
    is => 'lazy',
    handles => [ 'transform_files' ],
);

method _build_transformer {
    App::Embra::Plugin::TemplateToolkit->new(
        embra          => $self->embra,
        logger         => $self,
        name           => 'TemplateToolkit',
        templates_path => $self->templates_path,
    );
}

with 'App::Embra::Role::FileTransformer';

1;
