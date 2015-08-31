use strict;
use warnings;

use lib 't/lib';
use App::Embra::Role::PluginBundle;

package TestPluginBundle;
use Moo;
use Method::Signatures;

method configure_bundle {}

with 'App::Embra::Role::PluginBundle';

package main;

use Test::Roo;
use Method::Signatures;
use Test::Exception;

method _build_plugin_bundle {
    TestPluginBundle->new( embra => $self->embra );
}

with 'App::Embra::Role::TestPluginBundle';

test 'plugin bundle ctor' => method {
    isa_ok(
        $self->plugin_bundle,
        'TestPluginBundle',
        'PluginBundle ctor ...'
    );
};

test 'basic plugin bundle' => method {
    lives_ok {
        $self->plugin_bundle->add_plugin( '=Foo' );
    } '... add plugin ...';
    is_deeply(
        $self->plugin_bundle->bundled_plugins,
        [ [ qw< =Foo Foo >, [] ] ],
        '... and stored correct config for it'
    );
};

test 'embra plugin bundle' => method {
    lives_ok {
        $self->plugin_bundle->add_plugin( 'Foo' );
    } 'add plugin ...';
    is_deeply(
        $self->plugin_bundle->bundled_plugins,
        [ [ qw< Foo App::Embra::Plugin::Foo >, [] ] ],
        '... and stored correct config for it'
    );
};

test 'plugin with name' => method {
    lives_ok {
        $self->plugin_bundle->add_plugin( 'Foo', 'Bar' );
    } 'add plugin with name ...';
    is_deeply(
        $self->plugin_bundle->bundled_plugins,
        [ [ qw< Bar App::Embra::Plugin::Foo >, [] ] ],
        '... and stored correct config for it'
    );
};

test 'plugin with payload' => method {
    lives_ok {
        $self->plugin_bundle->add_plugin( 'Foo', hi => 'hello' );
    } 'add plugin with extra named args ...';
    is_deeply(
        $self->plugin_bundle->bundled_plugins,
        [ [ 'Foo', 'App::Embra::Plugin::Foo', [ 'hi', 'hello' ] ] ],
        '... and stored correct config for it'
    );
};

test 'plugin with reference to payload' => method {
    lives_ok {
        $self->plugin_bundle->add_plugin( 'Foo', { hi => 'hello' } );
    } 'add plugin with hashref...';
    is_deeply(
        $self->plugin_bundle->bundled_plugins,
        [ [ 'Foo', 'App::Embra::Plugin::Foo', [ 'hi', 'hello' ] ] ],
        '... and stored correct config for it'
    );
};

test 'plugin with name and payload' => method {
    lives_ok {
        $self->plugin_bundle->add_plugin( 'Foo', 'Bar', hi => 'hello' );
    } 'add plugin with name and extra named args...';
    is_deeply(
        $self->plugin_bundle->bundled_plugins,
        [ [ 'Bar', 'App::Embra::Plugin::Foo', [ 'hi', 'hello' ] ] ],
        '... and stored correct config for it'
    );
};

test 'plugin with name and reference to payload' => method {
    lives_ok {
        $self->plugin_bundle->add_plugin( 'Foo', 'Bar', { hi => 'hello' } );
    } 'add plugin with name and hashref ...';
    is_deeply(
        $self->plugin_bundle->bundled_plugins,
        [ [ 'Bar', 'App::Embra::Plugin::Foo', [ 'hi', 'hello' ] ] ],
        '... and stored correct config for it'
    );
};

test 'plugin with name in payload' => method {
    lives_ok {
        $self->plugin_bundle->add_plugin( 'Foo', name => 'Bar', hi => 'hello' );
    } 'add plugin with named args including name ...';
    is_deeply(
        $self->plugin_bundle->bundled_plugins,
        [ [ 'Bar', 'App::Embra::Plugin::Foo', [ 'hi', 'hello' ] ] ],
        '... and stored correct config for it'
    );
};

test 'plugin with name in referenced payload' => method {
    lives_ok {
        $self->plugin_bundle->add_plugin( 'Foo', { name => 'Bar', hi => 'hello' } );
    } 'add plugin with name in hashref...';
    is_deeply(
        $self->plugin_bundle->bundled_plugins,
        [ [ 'Bar', 'App::Embra::Plugin::Foo', [ 'hi', 'hello' ] ] ],
        '... and stored correct config for it'
    );
};

test 'plugin with reference and payload' => method {
    lives_ok {
        $self->plugin_bundle->add_plugin( 'Foo', { hi => 'hello' }, hey => 'howdy' );
    } 'add plugin with hashref and named args';
    # pop off payload, since we won't know what order the key-values
    # will be in, and we have to turn it into a hash
    my %payload = ( @{ pop @{ $self->plugin_bundle->bundled_plugins->[0] } } );
    is_deeply(
        $self->plugin_bundle->bundled_plugins->[0],
        [ 'Foo', 'App::Embra::Plugin::Foo' ],
        '... and stored correct package and name and config for it'
    );
    is_deeply(
        \ %payload,
        { qw< hi hello hey howdy > },
        '... and config for it'
    );
};

run_me;

done_testing;
