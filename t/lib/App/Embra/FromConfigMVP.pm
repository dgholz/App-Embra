use strict;
use warnings;

package App::Embra::FromConfigMVP;
use Test::Roo::Role;

use App::Embra;
use Method::Signatures;

method _build_config_mvp_sequence( %assembler_args ) {
    require Config::MVP::Reader::Hash;
    require App::Embra::MVP::Assembler;
    Config::MVP::Reader::Hash->read_config(
        {
            _ => {
                __package => '=App::Embra',
            },
            %{ $self->config }
        },
        {
            assembler => App::Embra::MVP::Assembler->new( %assembler_args ),
        },
    );
}

has 'config_mvp_sequence' => (
    is => 'lazy',
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
