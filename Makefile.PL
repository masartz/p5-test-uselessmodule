use inc::Module::Install;

name 'Test-UselessModule';
all_from 'lib/Test/UselessModule.pm';

requires 'Test::More';
requires 'List::MoreUtils';
requires 'Cwd';

tests 't/*.t';
author_tests 'xt';

auto_set_repository;
auto_include;

WriteAll;
