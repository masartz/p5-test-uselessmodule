use strict;
use warnings;

use Test::More;
use Test::UselessModule::Finder;

subtest '_is_test_module' => sub{
    my @classes = (
        'use Plack::Test;',

        'use Test::Apache2;',
        'use Test::Apache2::RequestRec;',
        'use Test::Base;',
        'use Test::Deep;',
        'use Test::Exception;',
        'use Test::Exit;',
        'use Test::Flatten;',
        'use Test::MockTime::DateCalc;',
        'use Test::More;',
        'use Test::Pod;',
        'use Test::Random;',
        'use Test::Synchronized;',
        'use Test::Warn;',
        'use Test::XML;'
    );
    for my $class ( @classes ){
        ok Test::UselessModule::Finder::_is_test_module($class);
    }
    ok ! Test::UselessModule::Finder::_is_test_module('use TheService::Other;');
};

done_testing;
