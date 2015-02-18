use strict;
use warnings;

use lib 't/lib';
use App::Embra::Role::PluginBundle;

package TestPluginBundle;
use Moo;
use Method::Signatures;

method configure_bundle { $self->add_plugin('=Foo') }

with 'App::Embra::Role::PluginBundle';

package main;

use Test::Roo;
use Method::Signatures;
use Test::Exception;

test 'plugin bundle from MVP' => method {
    my @bpc;
    lives_ok {
        @bpc = TestPluginBundle->bundled_plugins_config({
            name => 'hi',
            package => 'TestPluginBundle',
            payload => { hello => 'howdy'}
        })
    } 'returned config for bundled plugins ...';
    is_deeply(
        \@bpc,
        [ [ qw< =Foo Foo >, [] ] ],
        '... with the right values'
    );
};

run_me;

done_testing;
