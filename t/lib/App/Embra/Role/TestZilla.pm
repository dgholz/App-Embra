use strict;
use warnings;

package App::Embra::Role::TestZilla;

use App::Embra::Plugin::Zilla;

use Method::Signatures;
use Moo::Role;

requires 'dist_zilla_plugin_name';

method _build_plugin {
    App::Embra::Plugin::Zilla->new( embra => $self->embra, name => $self->dist_zilla_plugin_name );
}

with 'App::Embra::Role::TestPlugin';

1;
