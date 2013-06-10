use strict;
use warnings;

use Test::More;
use Test::UselessModule::Finder;

subtest '_is_test_module' => sub{
    my @classes = qw/
        Test::More
        Test::Exception
    /;
    for my $class ( @classes ){
        ok Test::UselessModule::Finder::_is_test_module($class);
    }
    ok ! Test::UselessModule::Finder::_is_test_module('TheService::Other');
};

done_testing;
