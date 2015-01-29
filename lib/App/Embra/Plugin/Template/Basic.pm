use strict;
use warnings;

package App::Embra::Plugin::Template::Basic;

# ABSTRACT: simple HTML5 template

use Method::Signatures;
use App::Embra::Plugin::TemplateToolkit;
use File::ShareDir;
use Moo;

=head1 DESCRIPTION

This plugin will process site files through Template Toolkit with a pre-defined set of templates. For each file with a C<.html> extension, it will look for a template with a matching name and use it to process the contents of the file into an assembled HTML document.

The templates are stored as a L<File::ShareDir>, which in the source of the distribution are located at C<share/Plugin/Template/Basic>.

=cut

=attr assembler

The object used to assemble files. Defaults to an instance of L<App::Embra::Plugin::TemplateToolkit>.

=cut

has 'assembler' => (
    is => 'lazy',
    handles => 'assemble_files',
);

method _build_assembler {
    App::Embra::Plugin::TemplateToolkit->new(
        include_path => File::ShareDir::module_dir(__PACKAGE__),
    );
}

with 'App::Embra::Role::FileAssembler';

1;
