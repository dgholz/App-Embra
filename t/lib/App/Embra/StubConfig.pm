use strict;
use warnings;

package App::Embra::StubConfig;
use Test::Roo::Role;

use Method::Signatures;

has config => (
    is => 'ro',
    default => method {
        {
            'Test' => {
                greeting => 'howdy',
            },
        };
    },
);

1;
