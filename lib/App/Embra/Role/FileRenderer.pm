use strict;
use warnings;

package App::Embra::Role::FileRenderer;

# ABSTRACT: something that renders file content into HTML

use Method::Signatures;
use Moo::Role;

with 'App::Embra::Role::Plugin';

requires 'render_files';

1;

