use strict;
use warnings;

use Test::More;
use Test::UselessModule;

can_ok 'Test::UselessModule' ,
    qw/ lean_module_use_ok add_exception_module /;

subtest 'add_exception_module' => sub{
    my @ret_add = add_exception_module( ['TheService::Add'] );
    is_deeply
        \@ret_add,
        ['TheService::Add'],
        'add OK';

    @ret_add = add_exception_module( [
        'TheService::Add::More1',
        'TheService::Add::More2',
    ] );
    is_deeply
        \@ret_add,
        [qw/TheService::Add
            TheService::Add::More1
            TheService::Add::More2/],
        'add more OK';

};


done_testing;

