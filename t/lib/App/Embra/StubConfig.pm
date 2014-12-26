package App::Embra::StubConfig;
use Test::Roo::Role;

use Method::Signatures;

has config => (
    is => 'ro',
    default => method {
        {
            'App::Embra::Plugin::Test' => {
                greeting => 'howdy',
            },
        };
    },
);

1;
