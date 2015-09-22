use strict;
use warnings;

package App::Embra::App::Command::Listdeps::Section;
# ABSTRACT: a section of an MVP config sequence which doesn't try to load the section's class

use App::Embra::App -ignore;

use Moo;
extends 'Config::MVP::Section';

1;
