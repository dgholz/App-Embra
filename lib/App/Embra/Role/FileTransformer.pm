use strict;
use warnings;

package App::Embra::Role::FileTransformer;

# ABSTRACT: something that transforms files before App::Embra turns them into a site

use Method::Signatures;
use Moo::Role;

with 'App::Embra::Role::Plugin';

requires 'transform_files';

1;

