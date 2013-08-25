use strict;
use warnings;

use Test::More;
use Test::UselessModule::Finder;

subtest '_is_test_module' => sub{
    my @classes = qw/
        Plack::Test

        Test::Apache2
        Test::Apache2::RequestRec
        Test::Base
        Test::Deep
        Test::Exception
        Test::Exit
        Test::Flatten
        Test::MockTime::DateCalc
        Test::More
        Test::Pod
        Test::Random
        Test::Synchronized
        Test::Warn
        Test::XML
    /;
    for my $class ( @classes ){
        ok Test::UselessModule::Finder::_is_test_module($class);
    }
    ok ! Test::UselessModule::Finder::_is_test_module('TheService::Other');
};

done_testing;
