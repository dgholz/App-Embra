use strict;
use warnings;

package App::Embra::FromConfigMVP;
use Test::Roo::Role;

use App::Embra;
use Method::Signatures;

has 'config_mvp_sequence' => (
    is => 'lazy',
    default => method {
        use Config::MVP::Reader::Hash;
        Config::MVP::Reader::Hash->read_config( {
            _ => {
                __package => 'App::Embra',
            },
            %{ $self->config }
        } );
    },
);

has 'config' => (
    is => 'ro',
);

has 'embra' => (
    is => 'ro',
    default => method {
        App::Embra->from_config_mvp_sequence( sequence => $self->config_mvp_sequence );
    },
);

1;
