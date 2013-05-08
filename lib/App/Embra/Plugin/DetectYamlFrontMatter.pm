use strict;
use warnings;

package App::Embra::Plugin::DetectYamlFrontMatter;

# ABSTRACT: detect YAML front matter & save for later

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
        my $front_matter;
        try {
            require YAML::XS;
            $front_matter = YAML::XS::Load( $yaml_front_matter );
        } catch {
            die 'cannot read front-matter of '.$file->name.': '.$_;
        };
        if( ! $file->DOES( 'App::Embra::Role::WithFrontMatter' ) ) {
            Role::Tiny->apply_roles_to_object( $file, 'App::Embra::Role::WithFrontMatter' );
        }
        $file->update_front_matter( $front_matter );
        $file->content( ${^POSTMATCH} );
    }
}

with 'App::Embra::Role::FileTransformer';

1;
