use strict;
use warnings;

package App::Embra::Role::FilePublisher;

# ABSTRACT: something that publishs files to a site

use Method::Signatures;
use Moo::Role;

with 'App::Embra::Role::Plugin';

requires 'publish_files';

1;

