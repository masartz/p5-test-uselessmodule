use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok 'Test::UselessModule';
    use_ok 'Test::UselessModule::Finder';
    use_ok 'Test::UselessModule::ExceptTarget';
};

done_testing();
