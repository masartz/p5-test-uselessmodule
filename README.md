# NAME

Test::UselessModule - finding useless module

# SYNOPSIS

use Test::More;
use Test::UselessModule;

add\_exception\_module( \[qw/
    TheService::Module::Except1
    TheService::Module::Except2
/\]);

lean\_module\_use\_ok(); \# finding under lib directories.

lean\_module\_use\_ok('TheService::Module'); \# finding under lib/TheService/Module directories.

done\_testing();

# DESCRIPTION

Test::UselessModule finds module which is written use , but does not be used.
=head1 METHODS

## lean\_module\_use\_ok

## add\_exception\_module

you can add modules which is except from lean\_module\_use\_ok's check.
you have to give one ARRAY\_REF as parameter.

# AUTHOR

masartz <masartz@gmail.com>
HARUYAMA Seigo <haruyama@unixuser.org>

# SEE ALSO

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
