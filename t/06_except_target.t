use strict;
use warnings;

use Test::More;
use Test::UselessModule::ExceptTarget;

can_ok 'Test::UselessModule::ExceptTarget' ,
    qw/ get add clear /;

subtest 'basic' => sub{

    my @ret = Test::UselessModule::ExceptTarget::get();
    is_deeply \@ret , [] , 'default empty';

    @ret = Test::UselessModule::ExceptTarget::add( ['TheService::Add'] );
    is_deeply 
        \@ret,
        ['TheService::Add'],
        'add OK';

    @ret = Test::UselessModule::ExceptTarget::add( [
        'TheService::Add::More1',
        'TheService::Add::More2',
    ] );
    is_deeply 
        \@ret,
        [qw/TheService::Add
            TheService::Add::More1
            TheService::Add::More2/],
        'add more OK';

    @ret = Test::UselessModule::ExceptTarget::get();
    is_deeply 
        \@ret,
        [qw/TheService::Add
            TheService::Add::More1
            TheService::Add::More2/],
        'get OK';

    Test::UselessModule::ExceptTarget::clear();

    @ret = Test::UselessModule::ExceptTarget::get();
    is_deeply \@ret , [] , 'clear OK';
};


done_testing;

