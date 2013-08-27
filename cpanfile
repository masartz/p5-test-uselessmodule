requires 'Cwd';
requires 'Data::Util';
requires 'File::Find';
requires 'List::MoreUtils';
requires 'Test::More';

on build => sub {
    requires 'ExtUtils::MakeMaker', '6.36';
};
