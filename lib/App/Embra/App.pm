use strict;
use warnings;

package App::Embra::App;

# ABSTRACT: App::Embra's App::Cmd

use App::Cmd::Setup -app;

use Log::Any::Adapter;
Log::Any::Adapter->set( 'Stdout' );

1;
