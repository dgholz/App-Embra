use strict;
use warnings;

package App::Embra::Plugin::DetectYamlFrontMatter;

# ABSTRACT: detect YAML front matter & save as notes

use Moo;
use Method::Signatures;
use Try::Tiny;

method transform_files {
    for my $file ( @{ $self->embra->files } ) {
        my ( $yaml_front_matter ) = 
            $file->content =~ m/
              \A        # beginning of file
              --- \s* ^ # first line is three dashes
              ( .*? ) ^ # then the smallest amount of stuff until
              --- \s* ^ # the next line of three dashes
            /xmsp;
        next if not $yaml_front_matter;
        my $notes;
        try {
            require YAML::XS;
            $notes = YAML::XS::Load( $yaml_front_matter );
        } catch {
            die 'cannot read front-matter of '.$file->name.': '.$_;
        };
        $file->update_notes( $notes );
        $file->content( ${^POSTMATCH} );
    }
}

with 'App::Embra::Role::FileTransformer';

1;
