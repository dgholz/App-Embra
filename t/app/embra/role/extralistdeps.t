use strict;
use warnings;

use App::Embra::Role::ExtraListDeps;
use CPAN::Meta::Requirements;


package TestConsumer;
use Method::Signatures;
use Moo;

method extra_list_deps( $class:, :$config ) {
    @{ $config->{TestConsumer} };
}
with 'App::Embra::Role::ExtraListDeps';

package main;
use Method::Signatures;
use Test::Roo;

has 'plugin_class' => (
    is => 'ro',
    default => 'TestConsumer',
);

has 'config' => (
    is => 'ro',
    default => method { {} },
);

has 'reqs' => (
    is => 'ro',
    default => method { CPAN::Meta::Requirements->new() },
);

test 'composes' => method {
    $self->plugin_class->add_extra_deps( config => $self->config, reqs => $self->reqs );
    is_deeply(
        $self->reqs->as_string_hash,
        { hi => 1, howdy => 0 },
        'extra_list_deps get added to reqs'
    );
};

run_me({ config => { 'TestConsumer' => [ qw<hi=1 howdy> ] } });

done_testing;
