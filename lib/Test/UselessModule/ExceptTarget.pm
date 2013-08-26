package Test::UselessModule::ExceptTarget;
use strict;
use warnings;

use Data::Util;

my @EXCEPT_TARGET_MODULE = ();

sub get{
    return @EXCEPT_TARGET_MODULE;
}

sub add{
    my $add_list = shift;
    
    Data::Util::is_array_ref( $add_list ) or die;
    
    push @EXCEPT_TARGET_MODULE , @{$add_list};

    return @EXCEPT_TARGET_MODULE;
}

sub clear{
    @EXCEPT_TARGET_MODULE = ();
}

1;
