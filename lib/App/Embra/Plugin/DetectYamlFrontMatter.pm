use strict;
use warnings;

package App::Embra::Plugin::DetectYamlFrontMatter;

# ABSTRACT: detect YAML front matter & save as notes

use Try::Tiny;
use Method::Signatures;
use Moo;

=head1 DESCRIPTION

This plugin will check each gathered file for L<YAML front-matter|http://jekyllrb.com/docs/frontmatter/>. The front-matter will be parsed as YAML, and the resulting data will be added to the file's L<notes|App::Embra::File/notes>.

Typical YAML front matter looks similar to:

    ---
    key: value
    key2: value2
    other_yaml:
     - and
     - so
     - on
    ---
    << rest of file … >>

=cut

method transform_files {
    for my $file ( @{ $self->embra->files } ) {
        my ( $yaml_front_matter ) =
            $file->content =~ m/
              \A         # beginning of file
              --- \s* \n # first line is three dashes
              ( .*? ) \n # then the smallest amount of stuff until
              --- \s* \n # the next line of three dashes
            /xmsp;
        next if not $yaml_front_matter;
        my $notes;
        try {
            require YAML::XS;
            $notes = YAML::XS::Load( $yaml_front_matter );
        } catch {
            die 'cannot read front-matter of '.$file->name.': '.$_;
        };
        $file->update_notes( %$notes );
        $file->content( ${^POSTMATCH} );
    }
}

with 'App::Embra::Role::FileTransformer';

1;
