use inc::Module::Install;

name 'Test-UselessModule';
all_from 'lib/Test/UselessModule.pm';

requires 'Cwd';
requires 'Data::Util';
requires 'File::Find';
requires 'List::MoreUtils';
requires 'Test::More';

tests 't/*.t';
author_tests 'xt';

auto_set_repository;
auto_include;

WriteAll;
