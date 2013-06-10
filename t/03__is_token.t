use strict;
use warnings;

use Test::More;
use Test::UselessModule::Finder;

subtest '_is_token' => sub{
    my @tokens = qw/
        __END__
        __DATA__
    /;
    for my $token ( @tokens ){
        ok Test::UselessModule::Finder::_is_token($token);
    }
    ok ! Test::UselessModule::Finder::_is_token('Mixi::Other');
    ok ! Test::UselessModule::Finder::_is_token('__END__0');
    ok ! Test::UselessModule::Finder::_is_token('1__END__');
    ok ! Test::UselessModule::Finder::_is_token('__PACKAGE__');
};

done_testing;
