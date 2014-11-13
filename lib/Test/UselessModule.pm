package Test::UselessModule;
use strict;
use warnings;

our $VERSION = '0.03';

use Exporter qw(import);
use Cwd;
use Data::Util;
use File::Find;
use Test::More;
use Test::UselessModule::Finder;
use Test::UselessModule::ExceptTarget;

our @EXPORT = qw/
    lean_module_use_ok
    add_exception_module
/;

sub lean_module_use_ok {
    my ( $namespace ) = @_;

    my $current = sprintf '%s' , getcwd();
    my $dir = Test::UselessModule::Finder::namespace2path( $namespace );

    File::Find::find({
        wanted => sub {
            my $path = $File::Find::name;
            if ($path =~ qr{(.*\.pm)$}xms) {
                my $name = $1;
                my $full_path = sprintf '%s/%s', $current , $path;
                my $ret = Test::UselessModule::Finder::check_file($full_path);
                if ( scalar @{$ret} ){
                    ok 0 , $name;
                    map{ diag "    - $_ \n" } @{$ret};
                }
                else{
                    ok 1 , $name;
                }
            }
        },
        preprocess => sub {
            grep { $_ ne '.git' } @_;
        },
    }, $dir);
}

sub add_exception_module{
    my $exception_module = shift;

    Data::Util::is_array_ref( $exception_module ) or die;

    return Test::UselessModule::ExceptTarget::add($exception_module);
}

1;

__END__

=head1 NAME

Test::UselessModule - finding useless module

=head1 SYNOPSIS

use Test::More;
use Test::UselessModule;

add_exception_module( [qw/
    TheService::Module::Except1
    TheService::Module::Except2
/]);

lean_module_use_ok(); # finding under lib directories.

lean_module_use_ok('TheService::Module'); # finding under lib/TheService/Module directories.

done_testing();

=head1 DESCRIPTION

Test::UselessModule finds module which is written use , but does not be used.
=head1 METHODS

=head2 lean_module_use_ok

=head2 add_exception_module

you can add modules which is except from lean_module_use_ok's check.
you have to give one ARRAY_REF as parameter.

=head1 AUTHOR

masartz E<lt>masartz@gmail.comE<gt>
HARUYAMA Seigo E<lt>haruyama@unixuser.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
