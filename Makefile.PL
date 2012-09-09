use inc::Module::Install;

name 'Test::UselessModule';
all_from 'lib/Test::UselessModule.pm';

requires 'List::MoreUtils';

tests 't/*.t';
author_tests 'xt';

auto_set_repository;
auto_include;

WriteAll;
